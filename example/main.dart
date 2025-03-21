import 'package:flutter/material.dart';
import 'package:easy_stripe_payment/easy_stripe_payment.dart';

String publishKey = your_publishable_key;
String secretKey = your_secret_key;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyStripePayment.instance
      .init(secretKey: secretKey, publishKey: publishKey);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String latestCharge = '';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Easy Stripe Payment Example")),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  //call the EasyStripePayment and create instance
                  // sent your data and simply will get the result true or issue
                  await EasyStripePayment.instance
                      .makePayment(amount: 50, currency: "eur" ,description: "my description" , clientEmail: "ahmad@just4prog.co")
                      .then((value) {
                    value.fold((fail) {
                      //TODO: DO SOMETHING
                    }, (success) {
                      //TODO: DO SOMETHING
                      //you can see all info here by get [success.data]
                      //like payment receipt
                      //example :
                      // await launchUrl(Uri.parse(response.data["receipt_url"]));
                      //you can get your ["latest_charge"]
                      //success.data["latest_charge"]
                      //to use it later for refund
                      setState(() {
                        latestCharge = success.data["latest_charge"];
                      });
                  });
                  });
                },
                child: Text("Pay Now"),
              ),
              ElevatedButton(
                onPressed: () async {
                  //to refund
                  EasyStripePayment.instance.refundPayment(latestCharge: latestCharge);
                },
                child: Text("refund Now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
