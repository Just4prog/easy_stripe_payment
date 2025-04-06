import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class EasyStripePaymentForPublish {
  EasyStripePaymentForPublish._();
  static final EasyStripePaymentForPublish instance = EasyStripePaymentForPublish._();

  final Dio dio = Dio();
  String? _backendBaseUrl;
  String? companyName = "Just4Prog";
  String? _paymentIntentId;

  Future<void> init({
    required String publishKey,
    required String backendBaseUrl,
  }) async {
    Stripe.publishableKey = publishKey;
    await Stripe.instance.applySettings();
    _backendBaseUrl = backendBaseUrl;
  }

  Future<Either<String, Map<String, dynamic>>> makePayment({
    required double amount,
    String currency = "eur",
    String? description,
    String? clientEmail = '',
  }) async {
    try {
      final clientSecretResponse = await dio.post(
        '$_backendBaseUrl/create-payment-intent',
        data: {
          'amount': amount,
          'currency': currency,
          'description': description,
        },
      );

      if (clientSecretResponse.statusCode != 200) {
        return Left('Failed to create payment intent');
      }

      final clientSecret = clientSecretResponse.data['clientSecret'];
      _paymentIntentId = clientSecretResponse.data['paymentIntentId'];

      await _initPaymentSheet(
        clientEmail: clientEmail ?? "",
        paymentIntentClientSecret: clientSecret,
      );

      await Stripe.instance.presentPaymentSheet();

      return await _verifyPaymentCompletion();
    } catch (e) {
      return Left('Payment Error: $e');
    }
  }

  Future<Either<String, Map<String, dynamic>>> _verifyPaymentCompletion() async {
    try {
      for (int i = 0; i < 15; i++) {
        await Future.delayed(const Duration(seconds: 2));

        final response = await dio.get(
          '$_backendBaseUrl/verify-payment/$_paymentIntentId',
        );

        if (response.data['status'] == 'succeeded') {
          return Right(response.data);
        } else if (response.data['status'] == 'failed') {
          return Left('Payment verification failed');
        }
      }
      return Left('Payment confirmation timeout');
    } catch (e) {
      return Left('Verification Error: $e');
    }
  }

  Future<void> _initPaymentSheet({
    required String paymentIntentClientSecret,
    String clientEmail = "",
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        billingDetails: BillingDetails(email: clientEmail),
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: companyName ?? "Just4Prog",
      ),
    );
  }

  Future<Either<String, dynamic>> refundPayment() async {
    try {
      final response = await dio.post(
        '$_backendBaseUrl/refund-payment',
        data: {'paymentIntentId': _paymentIntentId},
      );

      return Right(response.data);
    } catch (e) {
      return Left('Refund failed: $e');
    }
  }
}