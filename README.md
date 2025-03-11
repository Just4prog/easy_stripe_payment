
# 📦 Easy Stripe Payment

**Easy Stripe Payment** is a simple Flutter library to handle payments using **Stripe** easily and quickly, without complex setup. This library provides a flexible way to create **Payment Intents** and present a **Payment Sheet** directly.

## 🚀 Features

✅ Easy and fast setup with `init(secretKey , publishkey)`  
✅ Easily create **Payment Intent**  
✅ Open **Payment Sheet** to complete the payment  
✅ Multi-currency support  
✅ Uses **Dio** for API request handling  
✅ Compatible with the latest versions of **Flutter & Stripe**
✅ Everything automatically
---
## 🔧 Requirements

### Android
This plugin requires several changes to work on Android devices. Please make sure you follow all these steps:

- Use Android 5.0 (API level 21) and above.
- Use Kotlin version 1.8.0 and above
- Requires Android Gradle plugin 8 and higher: [Link](https://developer.android.com/studio/releases/gradle-plugin)
- Use a descendant of `Theme.AppCompat` for your activity: [Link](https://developer.android.com/reference/androidx/appcompat/R.styleable#AppCompatTheme)
- Use up-to-date Android gradle build tools version: [Link](https://developer.android.com/studio/releases/gradle) and an up-to-date gradle version accordingly: [Link](https://docs.gradle.org/current/userguide/installation.html)
- Use `FlutterFragmentActivity` instead of `FlutterActivity` in `MainActivity.kt`: [Link](https://docs.flutter.dev/release/notes/3.7.0#android)
- Add the following rules to your `proguard-rules.pro` file:
  ```plaintext
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
  ```
- Add the following line to your `gradle.properties` file:
  ```plaintext
  android.enableR8.fullMode=false
  ```
  This will prevent crashes with the Stripe SDK on Android (see [issue](https://github.com/stripe/stripe-android/issues/1522)).

- Rebuild the app, as the above changes don't update with hot reload.

These changes are necessary because the Android Stripe SDK requires the use of the AppCompat theme for their UI components and the Support Fragment Manager for the Payment Sheets.

If you face any trouble making this package work on Android, join [this discussion](https://github.com/YOUR_USERNAME/easy_stripe_payment/issues) for support.

### iOS
Compatible with apps targeting iOS 13 or above.

To upgrade your iOS deployment target to 13.0, you can either do so in Xcode under your Build Settings, or by modifying `IPHONEOS_DEPLOYMENT_TARGET` in your `project.pbxproj` directly.

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
```yaml
dependencies:
  easy_stripe_payment:
    git:
      url: https://github.com/YOUR_USERNAME/easy_stripe_payment.git
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

void main() {
  EasyStripePayment.instance.init(secretKey: "sk_test_YourSecretKey");
}
```

⚠️ **Security Warning**: Do not expose your **Stripe Secret Key** in the frontend, use a **secure server** to fetch it.

---

## 💳 Usage

### 🛒 Execute Payment

```dart
await EasyStripePayment.instance.makePayment(amount: 5000, currency: "usd");
```
📌 **Amount is in cents** (5000 = 50.00 USD)

### 🛠️ Full Example

```dart
import 'package:flutter/material.dart';
import 'package:easy_stripe_payment/easy_stripe_payment.dart';

void main() {
  EasyStripePayment.instance.init(secretKey: "sk_test_YourSecretKey");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Easy Stripe Payment Example")),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await EasyStripePayment.instance.makePayment(amount: 5000, currency: "usd");
            },
            child: Text("Pay Now"),
          ),
        ),
      ),
    );
  }
}
```

---

## ❓ Frequently Asked Questions

### 🔹 Does the package support **3D Secure & SCA**?
Yes ✅, **3D Secure** and **Strong Customer Authentication (SCA)** are automatically supported.

### 🔹 Can I customize the **Payment Sheet**?
Currently, you can customize the **merchantDisplayName**, and we will work on adding more customizations later.

### 🔹 What should I do if I encounter an error?
- Ensure you are using the correct **Stripe Secret Key**.
- Check the **Stripe Dashboard** settings.
- Review **console logs** for error details.

---

## 🤝 Contribution

We welcome contributions! 🚀 You can:
- Fix bugs or add new features
- Improve documentation
- Submit PRs on GitHub

### 🛠️ How to Contribute?
1. **Fork** the repository
2. Create a **new branch** (`git checkout -b feature-name`)
3. Make the necessary changes and **commit** them
4. Push the changes (`git push origin feature-name`)
5. Open a **Pull Request** 🎉

---

## 📜 License

This library is licensed under the **MIT License**, which means you are free to use and modify it under the terms of the license.

📌 **Get started now and provide a smooth payment experience for your users!** 💳🚀

---

