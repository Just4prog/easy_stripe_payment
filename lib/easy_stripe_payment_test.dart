import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

/// A singleton class for handling Stripe payments in Flutter apps.
class EasyStripePaymentTest {
  // Private constructor to ensure the class is a singleton.
  EasyStripePaymentTest._();

  /// Singleton instance of [EasyStripePaymentTest].
  static final EasyStripePaymentTest instance = EasyStripePaymentTest._();

  /// Secret key used for Stripe API requests.
  String? _secretKey;

  /// Default company name displayed in the Stripe Payment Sheet.
  String? companyName = "Just4Prog";

  // Initialize Dio to handle HTTP requests.
  final Dio dio = Dio();

  /// Initializes the Stripe payment service.
  /// [secretKey] is used to authenticate API requests.
  /// [publishKey] is used for client-side operations.
  Future<void> init({
    required String secretKey,
    required String publishKey,
  }) async {
    // Set the Stripe publishable key for client-side operations.
    Stripe.publishableKey = publishKey;

    // Apply the settings for Stripe.
    await Stripe.instance.applySettings();

    // Assign the secret key (for server-side operations) securely.
    // Be cautious not to expose this secret key in your app or public code.
    _secretKey = secretKey;
  }

  /// Makes a payment request with the given [amount] and [currency].
  /// Returns a [Right] with the success response or a [Left] with an error message.
  /// You can see all of the response by reaching the data (response.data).
  /// You can see all information like receipt_url and many things.
  Future<Either<String, Response<dynamic>>> makePayment({
    required double amount,
    String currency = "eur",
    String? description,
    String? clientEmail = '',
  }) async {
    try {
      // Step 1: Ensure that the secret key is initialized before proceeding with the payment.
      if (_secretKey == null) {
        return Left("Stripe Secret Key is not initialized. Call init() first.");
      }

      // Step 2: Create the payment intent (Server-side API request).
      final paymentIntent = await _createPaymentIntent(
        amount: amount,
        currency: currency,
        description: description ?? "",
      );

      // Get the client secret from the response to proceed with the payment sheet.
      String paymentIntentClientSecret = paymentIntent?.data["client_secret"];

      // Step 3: Initialize the payment sheet with the necessary details.
      await _initPaymentSheet(
        clientEmail: clientEmail ?? "",
        paymentIntentClientSecret: paymentIntentClientSecret,
      );

      // Step 4: Present the payment sheet to the user.
      await Stripe.instance.presentPaymentSheet();

      // Step 5: Process the payment and retrieve the final response after successful payment.
      return await _processPayment(paymentIntent?.data["id"]);
    } catch (e) {
      // If anything goes wrong, return an error message to indicate the failure.
      return Left("Payment Error: $e");
    }
  }

  /// Initializes the Stripe payment sheet with the provided [paymentIntentClientSecret].
  /// This method sets up the payment sheet with the merchant information and billing details.
  Future<void> _initPaymentSheet({
    required String paymentIntentClientSecret,
    String clientEmail = "",
  }) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        billingDetails: BillingDetails(email: clientEmail),
        // Customer email
        paymentIntentClientSecret: paymentIntentClientSecret,
        // Client secret for Stripe
        merchantDisplayName: companyName ??
            "Just4Prog", // Display merchant name in the payment sheet
      ),
    );
  }

  /// Creates a payment intent using the Stripe API.
  /// Returns the [Response] containing payment intent data.
  Future<Response<dynamic>?> _createPaymentIntent({
    required double amount,
    String? currency,
    String? description,
  }) async {
    try {
      // Stripe API requires the amount in cents, so multiply the amount by 100.
      final response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: {
          "amount": (amount * 100).toInt().toString(), // Amount in cents
          "currency": currency ?? "eur", // Currency (default to EUR)
          "description": description ?? "", // Description of the payment
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $_secretKey",
            // Provide the secret key in the authorization header
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
      );
      return response; // Return the response containing payment intent data
    } catch (e) {
      return null; // Return null if an error occurs while creating the payment intent
    }
  }

  /// Refunds a payment.
  /// Sends a request to the Stripe API to refund a specific charge.
  /// You must send the [latest_charge] which you can find in the response of [makePayment].
  ///
  /// Example usage:
  ///
  /// ```dart
  /// final response = makePayment(
  ///   amount: 30,
  ///   currency: "eur",
  ///   description: "my description",
  ///   clientEmail: "ahmad@just4prog.com",
  /// );
  ///
  /// response.fold(
  ///   (fail) {
  ///     // TODO: Handle failure
  ///   },
  ///   (response) async {
  ///     // TODO: Handle success
  ///     String latestCharge = response.data["latest_charge"];
  ///     // Create your refund
  ///     await refundPayment(latestCharge: latestCharge);
  ///   },
  /// );
  /// ```
  Future<Either<String, Response<dynamic>>> refundPayment({
    required String latestCharge,
  }) async {
    try {
      // Send a POST request to Stripe's API to refund a specific charge using its ID.
      final response = await dio.post(
        "https://api.stripe.com/v1/refunds",
        data: {
          "charge": latestCharge, // Charge ID that you want to refund
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $_secretKey",
            // Provide the secret key for authorization
            "Content-Type": "application/x-www-form-urlencoded",
          },
        ),
      );

      // Return the response containing the refund details if successful.
      return Right(response);
    } catch (e) {
      // Return an error message if the refund operation fails.
      return Left("Refund failed: $e");
    }
  }

  /// Processes the payment by checking the payment intent's status.
  /// Returns the final response containing charge details after a successful payment.
  Future<Either<String, Response<dynamic>>> _processPayment(
    String paymentIntentId,
  ) async {
    try {
      // Send a GET request to Stripe to retrieve the payment intent details.
      final response = await dio.get(
        "https://api.stripe.com/v1/payment_intents/$paymentIntentId",
        options: Options(
          headers: {
            "Authorization": "Bearer $_secretKey",
            // Provide the secret key for authorization
          },
        ),
      );

      // Get the charge ID from the payment intent response to check the charge details.
      String latestCharge = response.data["latest_charge"];

      // Step 1: Get the charge details using the charge ID.
      return Right(await _getFinalResponse(latestCharge));
    } catch (e) {
      // Return an error message if payment fails.
      return Left("Payment failed: $e");
    }
  }

  /// Retrieves the final charge details after a successful payment.
  Future<Response<dynamic>> _getFinalResponse(String latestCharge) async {
    return await dio.get(
      "https://api.stripe.com/v1/charges/$latestCharge",
      // Retrieve charge details from Stripe
      options: Options(
        headers: {
          "Authorization": "Bearer $_secretKey",
          // Provide the secret key for authorization
          "Content-Type": "application/x-www-form-urlencoded",
        },
      ),
    );
  }
}
