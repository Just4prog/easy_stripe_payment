# 💳 EasyStripePayment for Flutter

A lightweight yet powerful Flutter package that makes **Stripe payments integration a breeze**.  
It supports full payment flows including **payment intent creation**, **payment sheet UI**, **charge
verification**, **full & partial refunds**, and **charge detail retrieval** — all with a clean API
and modern Flutter standards.
you just have to active payment method in your stripe
dashboard from [here](https://dashboard.stripe.com/test/settings/payment_methods)


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


