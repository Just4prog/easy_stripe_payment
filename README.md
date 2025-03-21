# 📦 Easy Stripe Payment

**Easy Stripe Payment** is a simple Flutter library to handle payments using **Stripe** easily and
quickly, without complex setup. This library provides a flexible way to create **Payment Intents**
and present a **Payment Sheet** directly . you just have to active payment method in your stripe
dashboard from [here](https://dashboard.stripe.com/test/settings/payment_methods) and here you are
every think will be perfect >>

<p align="center">
  <img src="https://github.com/user-attachments/assets/dc22e4c1-613a-411e-92c4-c941496d099b" alt="Demo Vid" height="500" style="display:inline-block; margin-right: 60px;">
  <img src="https://github.com/user-attachments/assets/5d44d167-ed15-4bef-bc2e-060ec3369170" alt="Demo Vid" height="500" style="display:inline-block;">
</p>



## 🚀 Features

✅ Easy and fast setup with `init(secretKey , publishkey)`  
✅ Easily create **Payment Intent**  
✅ Open **Payment Sheet** to complete the payment  
✅ Multi-currency support  
✅ Uses **Dio** for API request handling  
✅ Compatible with the latest versions of **Flutter & Stripe**  
✅ Everything automatically  
✅ Returns Final Result using Either from [dartz](https://pub.dev/packages/dartz):  
✅ Right → Payment Success 🎉  **or** ❌ Left → Payment Failed (Error Message) ⚠️  
✅ Supports **Refund Payments**  

---

## 🔧 Requirements

### Android

This plugin requires several changes to work on Android devices. Please make sure you follow all
these steps:

- Use Android 5.0 (API level 21) and above.
- Use Kotlin version 1.8.0 and above
- Requires Android Gradle plugin 8 and
  higher: [Link](https://github.com/Just4prog/easy_stripe_payment/blob/master/example/android/settings.gradle.kts#L21)
- Use a descendant of `Theme.AppCompat` for your
  activity: [Link](https://github.com/Just4prog/easy_stripe_payment/blob/master/example/android/app/src/main/res/values/styles.xml#L15) , [Link](https://github.com/Just4prog/easy_stripe_payment/blob/master/example/android/app/src/main/res/values-night/styles.xml#L15)
- Use `FlutterFragmentActivity` instead of `FlutterActivity` in
  `MainActivity.kt`: [Link](https://github.com/Just4prog/easy_stripe_payment/blob/master/example/android/app/src/main/kotlin/com/example/example/MainActivity.kt#L3-L7)
- Add the following rules to your `proguard-rules.pro`
  file:[link](https://github.com/Just4prog/easy_stripe_payment/blob/master/example/android/app/proguard-rules.pro#L1-L5)
  ```plaintext
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
  ```
- edit your `gradle.properties` file to be like
  this : [link](https://github.com/Just4prog/easy_stripe_payment/blob/master/example/android/gradle.properties#L1-L4)

### iOS

Compatible with apps targeting iOS 13 or above.

To upgrade your iOS deployment target to 13.0, you can either do so in Xcode under your Build
Settings, or by modifying `IPHONEOS_DEPLOYMENT_TARGET` in your `project.pbxproj` directly.

You will also need to update your `Podfile`:

```ruby
platform :ios, '13.0'
```

For card scanning, add the following to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Scan your card to add it automatically</string>
<key>NSCameraUsageDescription</key>
<string>To scan cards</string>
```

---

## 📌 Installation

Add the package to `pubspec.yaml`:
run:

```sh
flutter pub add easy_stripe_payment
``` 


or :
```yaml
dependencies:
  easy_stripe_payment: ^3.0.6
```

Then run:

```sh
flutter pub get
```


---

## ⚙️ Setup

Before using the library, initialize it with your **Stripe Secret Key**:

```dart
import 'package:easy_stripe_payment/easy_stripe_payment.dart';

//bring your publishableKey , secretKey
String publishKey = your_publishable_key;
String secretKey = your_secret_key;

//in your main function or DI
//make the main function future by adding async

void main() async {
  //add these to line before your runApp
  WidgetsFlutterBinding.ensureInitialized();
  await EasyStripePayment.instance.init(secretKey: secretKey, publishKey: publishKey);


  runApp(const MyApp());
}
```
**IMPORTANT NOTE**  
**⚠️⚠️⚠️⚠️**  
⚠️ **Security Warning**:  
Do not expose your **Stripe Secret Key** in the frontend,  
use a **secure server** to fetch it.  
⚠️⚠️⚠️⚠️


---

## 💳 Usage

### 🛒 Execute Payment

```dart
//you can leave it like this  
await EasyStripePayment.instance.makePayment(amount : your_amount , currency: your_currency);
// or use it like in the example 
await EasyStripePayment.instance.makePayment(amount : your_amount , currency: your_currency).then((value){
    value.fold(
    (fail){
        //TODO: DO SOMETHING
      print("payment fail $fail");
    },(success){
        //TODO: DO SOMETHING
      print("payment success");
    }
  );
});

// or consider it like variable
paymentResult =  await EasyStripePayment.instance.makePayment(amount : your_amount , currency: your_currency);
paymentResult.fold(
    (fail){
          //TODO: DO SOMETHING
        print("payment fail $fail");
        },(success){
          //TODO: DO SOMETHING
        print("payment success");
      }
    );

```

📌 **Amount is simple** (50.00 USD = 50.00 USD , 50.00 EUR = 50.00 EUR etc..)

### 🔄 Refund Payment

```dart
await EasyStripePayment.instance.refundPayment(latestCharge: "your_charge_id").then((value) {
  value.fold(
    (fail) {
      print("Refund failed: $fail");
    },
    (success) {
      print("Refund success");
    }
  );
});
```

---
## ☕ Support My Work

If you find **Easy Stripe Payment** useful and would like to support my work, consider buying me a coffee!

A small cup of coffee might not mean much to you, but for me, it means a lot—it fuels my passion and helps me continue building and improving tools for the Flutter community. 🚀

👉 [Buy me a coffee](https://buymeacoffee.com/just4prog)

<p align="center">
  <img src="https://github.com/user-attachments/assets/a4c7373d-4f03-4c7c-98de-bce616eae8ed" alt="QR Code" width="200">
</p>

Your support keeps me motivated to provide more content, updates, and helpful tools. Thank you for being awesome! ❤️
---

## 📜 License

This library is licensed under the **MIT License**, which means you are free to use and modify it
under the terms of the license.

📌 **Get started now and provide a smooth payment experience for your users!** 💳🚀

---

## Contact

**Email: ahmadnahal7@gmail.com**

# Payment Methods Available

## **Cards**

- **Cards** - Popular globally.
- **Cartes Bancaires** - Popular in France.

## **Wallets**

- **Alipay** - Popular in China.
- **Apple Pay** - Popular globally.
- **Google Pay** - Popular globally.
- **Link** - Customized, popular globally.
- **MobilePay** - Popular in Denmark and Finland.
- **PayPal** - Popular globally.
- **Revolut Pay** - Popular in Europe and the United Kingdom.
- **WeChat Pay** - Popular in China.

## **Vouchers**

- **Multibanco** - Popular in Portugal.

## **Bank Redirects**

- **Bancontact** - Popular in Belgium.
- **BLIK** - Popular in Poland.
- **EPS** - Popular in Austria.
- **giropay** - Popular in Germany.
- **iDEAL** - Popular in the Netherlands.
- **Przelewy24** - Popular in Poland.
- **Sofort** - Popular in Germany, Austria, and Switzerland.
- **TWINT** - Popular in Switzerland.

## **Buy Now, Pay Later**

- **Klarna** - Popular in Europe and the United States.

## **Bank Debits**

- **SEPA Direct Debit** - Popular in Europe.
- **ACH Direct Debit** - Popular in the United States.

## **Bank Transfers**

- **Bank transfer** - Popular globally, used for large payments.

## **Webhooks (Recommended)**

- **Webhooks** - Recommended for improving transaction security.

## **Payment Methods by Country**

- **South Korea** - Includes South Korean cards, Naver Pay, Kakao Pay, Samsung Pay, and Payco.
