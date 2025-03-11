
# 📦 Easy Stripe Payment

**Easy Stripe Payment** is a simple Flutter library to handle payments using **Stripe** easily and quickly, without complex setup. This library provides a flexible way to create **Payment Intents** and present a **Payment Sheet** directly . you just have to active payment method in your stripe dashboard from [here](https://dashboard.stripe.com/test/settings/payment_methods) and here you are every think will be perfect >> 

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
- Requires Android Gradle plugin 8 and higher: [Link](https://github.com/Just4prog/easy_stripe_payment/blob/master/example/android/settings.gradle.kts#L21)
- Use a descendant of `Theme.AppCompat` for your activity: [Link](https://github.com/Just4prog/easy_stripe_payment/blob/master/example/android/app/src/main/res/values/styles.xml#L15) , [Link](https://github.com/Just4prog/easy_stripe_payment/blob/master/example/android/app/src/main/res/values-night/styles.xml#L15)
- Use `FlutterFragmentActivity` instead of `FlutterActivity` in `MainActivity.kt`: [Link](https://github.com/Just4prog/easy_stripe_payment/blob/master/example/android/app/src/main/kotlin/com/example/example/MainActivity.kt#L3-L7)
- Add the following rules to your `proguard-rules.pro` file:[link](https://github.com/Just4prog/easy_stripe_payment/blob/master/example/android/app/proguard-rules.pro#L1-L5)
  ```plaintext
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
  ```
- Add the following line to your `gradle.properties` file: [link](https://github.com/Just4prog/easy_stripe_payment/blob/master/example/android/gradle.properties#L1-L4)


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
  easy_stripe_payment: ^1.0.0
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
String publishKey = your_publishable_key;
String secretKey = your_secret_key;

void main() {
  await EasyStripePayment.instance.init(secretKey: secretKey, publishKey: publishKey);
}
```

⚠️ **Security Warning**: Do not expose your **Stripe Secret Key** in the frontend, use a **secure server** to fetch it.

---

## 💳 Usage

### 🛒 Execute Payment

```dart
await EasyStripePayment.instance.makePayment(amount: your_amount, currency: your_currency);
```
📌 **Amount is simple** (50.00 USD = 50.00 USD , 50.00 EUR = 50.00 EUR etc..)

---

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

