// easy_stripe_payment_test.dart

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

/// Main class for handling Stripe payments with secure backend integration
/// Uses ChangeNotifier for state management and Dartz for functional error handling
class EasyStripePayment with ChangeNotifier {
  // Singleton pattern implementation
  EasyStripePayment._();

  static final EasyStripePayment instance = EasyStripePayment._();

  final Dio dio = Dio(); // HTTP client for backend communication
  bool _paymentSuccess = false; // Internal payment state
  String? merchantName; // Merchant display name for payment sheet
  bool enableLogging = false; // Debug logging flag
  String? _baseUrl; // Base URL for backend API

  /// Public getter for payment success state
  bool get paymentSuccess => _paymentSuccess;

  /// Initializes Stripe payment system with required credentials
  /// [publishKey] - Stripe publishable key (pk_test_...)
  /// [baseUrl] - Base URL for your backend API
  /// [merchantName] - Display name shown in payment sheet
  Future<void> initStripe({
    required String publishKey,
    required String baseUrl,
    String? merchantName,
  }) async {
    Stripe.publishableKey = publishKey;
    this.merchantName = merchantName;
    _baseUrl = baseUrl;
    await Stripe.instance.applySettings();
  }

  /// Main payment flow handler
  /// [paymentIntentEndpoint] - Backend endpoint for creating payment intents
  /// [amount] - Payment amount in currency units (e.g., 50.00 EUR)
  /// [currency] - 3-letter currency code (default: EUR)
  /// [description] - Optional payment description
  /// [metadata] - Additional payment metadata
  /// [email], [phone], [name] - Customer details
  /// [city], [country], [line1], [line2], [postalCode], [state] - Billing address
  /// Returns Either:
  /// - Left(String): Error message
  /// - Right(String): Payment Intent ID for verification
  Future<Either<String, String>> makePayment({
    required String paymentIntentEndpoint,
    required double amount,
    String currency = "EUR",
    String? description,
    Map<String, dynamic>? metadata,
    String? email,
    String? phone,
    String? name,
    String? city,
    String? country,
    String? line1,
    String? line2,
    String? postalCode,
    String? state,
  }) async {
    try {
      if (_baseUrl == null) {
        return Left(
            'Base URL is not initialized. Please call initStripe first.');
      }

      String paymentIntentId = "";
      final result = await _createPaymentIntent(
        paymentIntentEndpoint: paymentIntentEndpoint,
        amount: amount,
        currency: currency,
        description: description,
        metadata: metadata,
      );

      return await result.fold(
        (error) => Left(error),
        (paymentIntent) async {
          paymentIntentId = paymentIntent.data["id"];
          String paymentIntentClientSecret =
              paymentIntent.data["client_secret"];

          await _initPaymentSheet(
            email: email,
            phone: phone,
            name: name,
            city: city,
            country: country,
            line1: line1,
            line2: line2,
            postalCode: postalCode,
            state: state,
            paymentIntentClientSecret: paymentIntentClientSecret,
          );

          await Stripe.instance.presentPaymentSheet();
          return Right(paymentIntentId);
        },
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  /// Internal method to create payment intent through backend
  Future<Either<String, Response<dynamic>>> _createPaymentIntent({
    required String paymentIntentEndpoint,
    required double amount,
    String currency = "EUR",
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await dio.post(
        "$_baseUrl$paymentIntentEndpoint",
        data: {
          'amount': amount * 100, // Convert to cents
          'currency': currency.toLowerCase(),
          'description': description,
          'metadata': metadata,
        },
      );

      if (response.statusCode != 200) {
        return Left('Payment intent creation failed: ${response.data}');
      }

      _paymentSuccess = false;
      notifyListeners();
      return Right(response);
    } catch (e) {
      return Left('Payment intent creation error: ${e.toString()}');
    }
  }

  /// Initializes Stripe payment sheet with collected details
  Future<void> _initPaymentSheet({
    required String paymentIntentClientSecret,
    String? email,
    String? phone,
    String? name,
    String? city,
    String? country,
    String? line1,
    String? line2,
    String? postalCode,
    String? state,
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        billingDetails: BillingDetails(
          email: email,
          name: name,
          address: Address(
            city: city,
            country: country,
            line1: line1,
            line2: line2,
            postalCode: postalCode,
            state: state,
          ),
          phone: phone,
        ),
        billingDetailsCollectionConfiguration:
            BillingDetailsCollectionConfiguration(
          email: CollectionMode.automatic,
          phone: CollectionMode.automatic,
          name: CollectionMode.automatic,
          address: AddressCollectionMode.automatic,
        ),
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: merchantName ?? "Just4Prog",
      ),
    );
  }

  /// Verifies payment status through backend
  /// [statusEndpoint] - Backend endpoint for payment verification
  /// [paymentIntentId] - Payment Intent ID from makePayment
  /// [maxRetries] - Maximum verification attempts (default: 5)
  /// [retryInterval] - Delay between attempts in seconds (default: 3)
  /// Returns Either:
  /// - Left(String): Error message
  /// - Right(Response): Verification response with payment details
  Future<Either<String, Response<dynamic>>> verifyPayment({
    required String statusEndpoint,
    required String paymentIntentId,
    int maxRetries = 5,
    int retryInterval = 3,
  }) async {
    try {
      if (_baseUrl == null) {
        return Left(
            'Base URL is not initialized. Please call initStripe first.');
      }

      for (int i = 0; i < maxRetries; i++) {
        await Future.delayed(Duration(seconds: retryInterval));
        final response =
            await dio.get("$_baseUrl$statusEndpoint$paymentIntentId");

        if (response.data['status'] == 'succeeded') {
          _paymentSuccess = true;
          notifyListeners();
          return Right(response);
        }
      }
      return Left('Payment verification timeout');
    } catch (e) {
      return Left('Verification error: ${e.toString()}');
    }
  }

  /// Retrieves detailed charge information
  /// [chargeDetailsEndpoint] - Backend endpoint for charge details
  /// [chargeId] - Charge ID from successful payment verification
  /// Returns Either:
  /// - Left(String): Error message
  /// - Right(Response): Charge details including receipt URL
  Future<Either<String, Response<dynamic>>> getChargeDetails({
    required String chargeDetailsEndpoint,
    required String chargeId,
  }) async {
    try {
      if (_baseUrl == null) {
        return Left(
            'Base URL is not initialized. Please call initStripe first.');
      }

      final response =
          await dio.get("$_baseUrl$chargeDetailsEndpoint$chargeId");
      return Right(response);
    } catch (e) {
      return Left('Charge details error: ${e.toString()}');
    }
  }

  /// Processes full refund for a charge
  /// [refundEndpoint] - Backend endpoint for refunds
  /// [chargeId] - Charge ID from successful payment
  /// [reason] - Optional refund reason
  /// Returns Either:
  /// - Left(String): Error message
  /// - Right(dynamic): Refund confirmation data
  Future<Either<String, dynamic>> refundPayment({
    required String refundEndpoint,
    required String chargeId,
    String? reason,
  }) async {
    try {
      if (_baseUrl == null) {
        return Left(
            'Base URL is not initialized. Please call initStripe first.');
      }

      final response = await dio.post(
        "$_baseUrl$refundEndpoint",
        data: {'charge_id': chargeId, 'reason': reason},
      );
      return Right(response.data);
    } catch (e) {
      return Left('Refund failed: ${e.toString()}');
    }
  }

  /// Processes partial refund for a charge
  /// [partialRefundEndpoint] - Backend endpoint for partial refunds
  /// [amount] - Amount to refund in original currency units
  /// [chargeId] - Charge ID from successful payment
  /// [reason] - Optional refund reason
  /// Returns Either:
  /// - Left(String): Error message
  /// - Right(dynamic): Refund confirmation data
  Future<Either<String, dynamic>> partialRefund({
    required String partialRefundEndpoint,
    required double amount,
    required String chargeId,
    String? reason,
  }) async {
    try {
      if (_baseUrl == null) {
        return Left(
            'Base URL is not initialized. Please call initStripe first.');
      }

      final response = await dio.post(
        "$_baseUrl$partialRefundEndpoint",
        data: {
          'charge_id': chargeId,
          'amount': (amount * 100).round(), // Convert to cents
          'reason': reason,
        },
      );
      return Right(response.data);
    } catch (e) {
      return Left('Partial refund failed: ${e.toString()}');
    }
  }

  /// Resets internal payment state
  void resetPaymentState() {
    _paymentSuccess = false;
    notifyListeners();
  }
}
