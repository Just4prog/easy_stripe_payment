import 'package:flutter/material.dart';
import 'package:easy_stripe_payment/easy_stripe_payment.dart';

String publishKey = your_publishable_key;
String secretKey = your_secret_key;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await EasyStripePayment.instance.init(secretKey: secretKey, publishKey: publishKey);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Easy Stripe Payment Example")),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await EasyStripePayment.instance.makePayment(amount: 50, currency: "eur");
            },
            child: Text("Pay Now"),
          ),
        ),
      ),
    );
  }
}
