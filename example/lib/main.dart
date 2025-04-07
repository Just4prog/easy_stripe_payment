// main.dart

import 'package:easy_stripe_payment/easy_stripe_payment.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyStripePayment.instance.initStripe(
    baseUrl: "https://just4prog.nl/",
    publishKey: "pk_test_51Q...",
    merchantName: "just4prog.nl",
  );
  runApp(const PaymentApp());
}

class PaymentApp extends StatefulWidget {
  const PaymentApp({super.key});

  @override
  State<PaymentApp> createState() => _PaymentAppState();
}

class _PaymentAppState extends State<PaymentApp> {
  String? _latestChargeId;
  final _stripe = EasyStripePayment.instance;

  Future<void> _handlePayment() async {
    final paymentResult = await _stripe.makePayment(
      paymentIntentEndpoint: "create-payment-intent",
      amount: 100,
      currency: "EUR",
      name: "Ahmed from Just4Prog",
      email: "customer@example.com",
      line1: "Main Street 123",
      city: "Amsterdam",
      country: "NL",
      postalCode: "1234AB",
    );

    paymentResult.fold((error) => _showError("Payment Failed: $error"), (
      paymentIntentId,
    ) async {
      final verification = await _stripe.verifyPayment(
        statusEndpoint: "verify-payment/",
        paymentIntentId: paymentIntentId,
      );

      verification.fold((error) => _showError("Verification Failed: $error"), (
        response,
      ) async {
        final chargeId = response.data['latest_charge'];
        _latestChargeId = chargeId;
        _showSuccess("Payment Verified!\nCharge ID: $chargeId");

        // Get full charge details
        final chargeDetails = await _stripe.getChargeDetails(
          chargeDetailsEndpoint: "charge-details/",
          chargeId: chargeId,
        );

        chargeDetails.fold(
          (error) => _showError("Details Error: $error"),
          (details) => _logDetails(details.data),
        );
      });
    });
  }

  Future<void> _handleFullRefund() async {
    if (_latestChargeId == null) return;

    final result = await _stripe.refundPayment(
      refundEndpoint: "process-refund",
      chargeId: _latestChargeId!,
      reason: "Customer request",
    );

    result.fold(
      (error) => _showError("Refund Failed: $error"),
      (success) => _showSuccess("Full Refund Processed!"),
    );
  }

  Future<void> _handlePartialRefund() async {
    if (_latestChargeId == null) return;

    final result = await _stripe.partialRefund(
      partialRefundEndpoint: "partial-refund",
      amount: 50,
      chargeId: _latestChargeId!,
    );

    result.fold(
      (error) => _showError("Partial Refund Failed: $error"),
      (success) => _showSuccess("€50 Partial Refund Processed!"),
    );
  }

  void _logDetails(dynamic details) {
    debugPrint('''
    Charge Details:
    ID: ${details['id']}
    Amount: ${details['amount']}
    Currency: ${details['currency']}
    Status: ${details['status']}
    Receipt URL: ${details['receipt_url']}
    Paid: ${details['paid']}
    ''');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Payment Demo")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPaymentButton(),
              const SizedBox(height: 20),
              _buildRefundButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentButton() {
    return ElevatedButton(
      onPressed: _handlePayment,
      style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
      child: const Text("Pay €100", style: TextStyle(fontSize: 18)),
    );
  }

  Widget _buildRefundButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _handleFullRefund,
          child: const Text("Full Refund"),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _handlePartialRefund,
          child: const Text("Partial Refund (€50)"),
        ),
      ],
    );
  }
}
