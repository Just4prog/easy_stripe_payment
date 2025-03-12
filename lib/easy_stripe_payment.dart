import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

/// A singleton class for handling Stripe payments in Flutter apps.
class EasyStripePayment {
  EasyStripePayment._();

  /// Singleton instance of [EasyStripePayment].
  static final EasyStripePayment instance = EasyStripePayment._();

  /// Secret key used for Stripe API requests.
  String? _secretKey;

  /// Default company name displayed in the Stripe Payment Sheet.
  String? companyName = "Just4Prog";

  /// Initializes the Stripe payment service.
  Future<void> init({required String secretKey, required String publishKey}) async {
    Stripe.publishableKey = publishKey;
    await Stripe.instance.applySettings();
    // be careful don't put your secret key in your documentation
    //try to put it in secure place like database then bring it securely
    _secretKey = secretKey;
  }

  /// Makes a payment request with the given [amount] and [currency].
  /// Returns [Either] with failure message or success status.
  Future<Either<String, bool>> makePayment({
    required double amount,
    String currency = "usd",
  }) async {
    try {
      if (_secretKey == null) {
        return Left("Stripe Secret Key is not initialized. Call init() first.");
      }

      final paymentIntentClientSecret = await _createPaymentIntent(amount: amount, currency: currency);
      if (paymentIntentClientSecret == null) {
        return Left("Failed to create payment intent.");
      }

      await _initPaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret);
      return await _processPayment();
    } catch (e) {
      return Left("Payment Error: $e");
    }
  }

  /// Initializes the Stripe payment sheet.
  Future<void> _initPaymentSheet({required String paymentIntentClientSecret}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: companyName ?? "Merchant",
      ),
    );
  }

  /// Creates a payment intent using the Stripe API.
  Future<String?> _createPaymentIntent({required double amount, String currency = "usd"}) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: {
          "amount": (amount * 100).toInt().toString(),
          "currency": currency,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $_secretKey",
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
      );
      return response.data["client_secret"];
    } catch (e) {
      if (kDebugMode) {
        print("Create Payment Intent Error: $e");
      }
      return null;
    }
  }

  /// Processes the payment through the Stripe payment sheet.
  Future<Either<String, bool>> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
      return Right(true);
    } on StripeException catch (e) {
      return Left("Stripe Error: ${e.error.localizedMessage}");
    } catch (e) {
      return Left("Payment failed: $e");
    }
  }
}
