Thought for a second


# TradeTrackr

A Flutter app for tracking real-time stock quotes, viewing simple charts, reading financial news, and managing a personalized watchlist. Backed by Firebase Auth and Finnhub’s free tier API.

---

## 🚀 Features

* **User Authentication**
  Sign up / log in / log out via Firebase Authentication.

* **Live Stock Quotes**
  Fetches current price, open/high/low, previous close and percent change for major tickers (AAPL, AMZN, MSFT, …).

* **Mini Sidebar Charts**
  Sparkline-style mini-charts in the sidebar for quick glance at price movement.

* **Detail Price Chart**
  Simple three-point line chart: previous close → midpoint → current price.

* **Watchlist Management**
  Add / remove tickers to your watchlist; pull to refresh.

* **Financial News**
  Fetches general & company-specific news using Finnhub’s news endpoints.

---

## 🛠 Prerequisites

* Flutter SDK (>=3.0)
* A Firebase project with **Authentication** enabled
* A free Finnhub API key (sign up at [https://finnhub.io](https://finnhub.io))

---

## 🔧 Setup

1. **Clone the repo**
   git clone [https://github.com/your-username/TradeTrackr.git](https://github.com/your-username/TradeTrackr.git)
   cd TradeTrackr

2. **Install dependencies**
   flutter pub get

3. **Configure Firebase**

   * Follow FlutterFire CLI instructions to register your app and download `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS).
   * Place them under `android/app/` and `ios/Runner/` respectively.

4. **Set your Finnhub key**
   Open `lib/services/stock_api_service.dart` (and `lib/services/news_api_service.dart`) and replace:

   ```dart
   static const String _apiKey = '<YOUR_FINNHUB_API_KEY>';
   ```

   with your actual key, or better yet, load it from a secure `.env`.

---

## ▶️ Running

```bash
# Android emulator
flutter run

# iOS simulator
flutter run -d ios

# Web
flutter run -d chrome
```

Hot-reload supported with `r`.

---

## 📦 Building

```bash
# Android APK
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web
```

---

## 🧩 Folder Structure

```
lib/
├── main.dart                # App entry point
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── stock_data_screen.dart
│   └── stock_watchlist_screen.dart
├── services/
│   ├── firebase_auth_service.dart
│   ├── stock_api_service.dart
│   └── news_api_service.dart
├── widgets/
│   ├── stock_card.dart
│   ├── news_card.dart
│   ├── search_bar.dart
│   ├── loading_indicator.dart
│   └── add_stock_button.dart
└── models/
    ├── stock.dart
    ├── candle.dart
    └── news.dart
```

---

## ✅ Testing

A basic widget test is included in `test/widget_test.dart`.
Run it with:

```bash
flutter test
```

---

## ⚠️ Troubleshooting

* **Perpetual loading spinner**
  Make sure your network calls complete before calling `setState`. See comments in `stock_data_screen.dart`.

* **“const constructor” errors**
  Remove `const` from any widget instantiation whose constructor isn’t marked `const`.

* **Late Firebase setup issues**
  Double-check your `google-services.json` / `GoogleService-Info.plist` placement and `firebase_core` initialization in `main.dart`.


---

Happy trading! 🚀
