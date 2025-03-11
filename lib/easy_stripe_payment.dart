import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class EasyStripePayment {
  EasyStripePayment._();

  static final EasyStripePayment instance = EasyStripePayment._();
  String? _secretKey;
  String? companyName = "Just4Prog";

  Future<void> init({required String secretKey , required String publishKey , String ? companyName}) async{
    Stripe.publishableKey = publishKey ;
    await Stripe.instance.applySettings();
    _secretKey = secretKey;
  }

  Future<void> makePayment({required int amount, String currency = "usd"}) async {
    try {
      if (_secretKey == null) {
        throw Exception("Stripe Secret Key is not initialized. Call init() first.");
      }

      String? paymentIntentClientSecret = await _createPaymentIntent(amount: amount, currency: currency);
      if (paymentIntentClientSecret == null) return;
      await _initPaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret);
      await _processPayment();
    } catch (e) {
      if (kDebugMode) {
        print("Payment Error: $e");
      }
    }
  }
  Future<void> _initPaymentSheet({required String paymentIntentClientSecret}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: companyName,
      ),
    );
  }

  Future<String?> _createPaymentIntent({required int amount, String currency = "usd"}) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": (amount * 100).toString(),
        "currency": currency,
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $_secretKey",
            "Content-Type": 'application/x-www-form-urlencoded',
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

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e) {
      if (kDebugMode) {
        print("Payment Sheet Error: $e");
      }
    }
  }
}
