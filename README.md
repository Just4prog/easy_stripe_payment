![logo](https://github.com/user-attachments/assets/7bc905d9-e4e4-4249-b636-fbd9f7d27d84)# 💳 EasyStripePayment for Flutter

A lightweight yet powerful Flutter package that makes **Stripe payments integration a breeze**.  
It supports full payment flows including **payment intent creation**, **payment sheet UI**, **charge
verification**, **full & partial refunds**, and **charge detail retrieval** — all with a clean API
and modern Flutter standards.
you just have to active payment method in your stripe
dashboard from [here](https://dashboard.stripe.com/test/settings/payment_methods)

![Uploading<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="363" height="245" viewBox="0 0 363 245">
  <image id="logo" width="363" height="245" xlink:href="data:image/png;base64,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"/>
</svg>
 logo.svg…]()

<p align="center">
  <img src="https://github.com/user-attachments/assets/dc22e4c1-613a-411e-92c4-c941496d099b" alt="Demo Vid" height="500" style="display:inline-block; margin-right: 60px;">
  <img src="https://github.com/user-attachments/assets/5d44d167-ed15-4bef-bc2e-060ec3369170" alt="Demo Vid" height="500" style="display:inline-block;">
</p>


---

## ☕ Support My Work

If you find **Easy Stripe Payment** useful and would like to support my work, consider buying me a
coffee!

A small cup of coffee might not mean much to you, but for me, it means a lot—it fuels my passion and
helps me continue building and improving tools for the Flutter community. 🚀

👉 [Buy me a coffee](https://buymeacoffee.com/just4prog)

<p align="center">
  <img src="https://github.com/user-attachments/assets/a4c7373d-4f03-4c7c-98de-bce616eae8ed" alt="QR Code" width="200">
</p>

Your support keeps me motivated to provide more content, updates, and helpful tools. Thank you for being awesome! ❤️
---


---

## 🚀 Features

- ✅ Easy Stripe initialization with publishable key
- 🧾 Create Payment Intents from backend
- 🧍 Collect user billing info (email, address, etc.)
- 💳 Show Stripe Payment Sheet with all payment method
- ✅ Verify payment status via backend
- 💸 Full or partial refunds
- 📄 Retrieve charge details (including receipt URL)
- 🔒 Secure integration with your backend API
- 💡 Uses `dartz` for functional error handling
- 🛠️ State managed with `ChangeNotifier`

🧪 Quick Test Mode with EasyStripePaymentTest
For testing purposes, you can use EasyStripePaymentTest which allows initializing directly with both
your publishableKey and secretKey (for local test only ⚠️). This skips the need for a backend during
development:

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
- edit your `gradle.properties` file to be like
  this : [link](https://github.com/Just4prog/easy_stripe_payment/blob/master/example/android/gradle.properties#L1-L4)
- Add the following rules to your `proguard-rules.pro`
  file:[link](https://github.com/Just4prog/easy_stripe_payment/blob/master/example/android/app/proguard-rules.pro#L1-L5)
  ```plaintext
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
  -dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
  ```

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
  easy_stripe_payment: ^4.0.8
```

---

## Test Mode :

```dart
await EasyStripePaymentTest.instance.init(
  secretKey: "sk_test_...",
  publishKey: "pk_test_...",
);
```

⚠️ Use this only in development — Never expose your secretKey in production apps.

---

## 🧪 Quick Start

### 1. Initialize Stripe

```dart
await EasyStripePayment.instance.initStripe(
  publishKey: "pk_test_...Just4prog.nl...",
  baseUrl: "https://Just4prog.nl/",
  merchantName: "Just4prog.nl",
);
```

---

### 2. Start Payment Flow

```dart
final result = await EasyStripePayment.instance.makePayment(
  paymentIntentEndpoint: "create-payment-intent/",
  amount: 99.99,
  currency: "eur",
  name: "Ahmed",
  email: "Ahmed@Just4prog.nl",
  city: "Amsterdam",
  country: "NL",
  postalCode: "1234AB",
);
```

---

### 3. Verify Payment

```dart
final verification = await EasyStripePayment.instance.verifyPayment(
  statusEndpoint: "verify-payment/",
  paymentIntentId: result.getOrElse(() => ""),
);
```

---

### 4. Get Charge Details

```dart
final chargeDetails = await EasyStripePayment.instance.getChargeDetails(
  chargeDetailsEndpoint: "charge-details/",
  chargeId: "ch_1XYZ...",
);
```

---

### 5. Refunds (Full / Partial)

```dart
// Full refund
await EasyStripePayment.instance.refundPayment(
  refundEndpoint: "process-refund/",
  chargeId: "ch_1XYZ...",
);

// Partial refund
await EasyStripePayment.instance.partialRefund(
  partialRefundEndpoint: "partial-refund/",
  amount: 50.00,
  chargeId: "ch_1XYZ...",
);
```

---

## 🧠 Architecture Overview

- `EasyStripePayment` is a singleton for global access.
- Integrates with your backend to handle all sensitive operations.
- Uses `Dio` for HTTP requests.
- Uses `Either<Error, Result>` from Dartz to make error handling easy and expressive.

---

## 📦 Backend Required Endpoints

| Endpoint                 | Description                         |
|--------------------------|-------------------------------------|
| `/create-payment-intent` | Create a payment intent             |
| `/verify-payment/:id`    | Verify payment status via intent ID |
| `/charge-details/:id`    | Retrieve charge details             |
| `/process-refund/`       | Refund full payment                 |
| `/partial-refund/`       | Refund partial amount               |

---

## 📸 UI Example (in Flutter)

```dart
ElevatedButton(
  onPressed: () async {
    final result = await EasyStripePayment.instance.makePayment(
      paymentIntentEndpoint: "create-payment-intent",
      amount: 49.99,
      currency: "eur",
      name: "Ahmed",
      email: "Ahmed@just4prog.nl",
    );
    result.fold(
      (error) => print("❌ Payment failed: $error"),
      (intentId) => print("✅ Success! Intent ID: $intentId"),
    );
  },
  child: const Text("Pay €49.99"),
);
```

## ✨ Author

Developed with ❤️ by [Ahmed @ Just4Prog](https://just4prog.nl/)  
Need a custom payment integration? Hit me up!

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


