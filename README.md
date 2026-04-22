# 💰 MoneyPlus

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![BLoC](https://img.shields.io/badge/BLoC-0175C2?style=for-the-badge&logo=bloc&logoColor=white)](https://bloclibrary.dev)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)](https://supabase.com)
[![Firebase](https://img.shields.io/badge/firebase-%23039BE5.svg?style=for-the-badge&logo=firebase)](https://firebase.google.com)


**MoneyPlus** is a premium, feature-rich financial management application built with Flutter. It provides a seamless experience for tracking expenses, managing categories, and visualizing financial health through modern charts and detailed reports.

---

## ✨ Key Features

- **📊 Comprehensive Expense Tracking**: Record and manage your daily transactions with ease.
- **📁 Category Management**: Organize your spending into custom categories for better insights.
- **📈 Data Visualization**: Interactive charts (powered by `fl_chart`) to visualize your financial trends.
- **📄 Professional PDF Reports**: Generate and export your financial summaries into PDF format.
- **🌍 Bi-directional Support**: Full localization support for **English** and **Arabic**, including RTL layout optimizations.
- **🔐 Secure Sync**: Real-time data synchronization and secure authentication via **Supabase**.
- **🚀 Performance Monitoring**: Integrated with **Firebase** for crashlytics, analytics, and performance tracking.

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (v3.10+)
- **State Management**: [BLoC / Cubit](https://pub.dev/packages/flutter_bloc)
- **Backend-as-a-Service**: [Supabase](https://supabase.com)
- **Analytics & Observability**: [Firebase](https://firebase.google.com)
- **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
- **Dependency Injection**: [GetIt](https://pub.dev/packages/get_it)
- **UI & Charts**: [FL Chart](https://pub.dev/packages/fl_chart), [Flutter SVG](https://pub.dev/packages/flutter_svg)

---

## 🏗️ Project Structure

The project follows a modular **Clean Architecture** pattern to ensure scalability and maintainability:

- `lib/core`: Essential utilities, configurations, and core logic.
- `lib/data`: Repository implementations and data source layers (Supabase, Local Storage).
- `lib/domain`: Business logic, entities, and repository interfaces.
- `lib/presentation`: UI components, screens, and BLoC/Cubit state management.
- `lib/design_system`: Reusable UI tokens, themes, and design components.

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (v3.10 or higher)
- Supabase account and project
- Firebase project (configured for Android/iOS)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/moneyplus.git
   cd moneyplus
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables:**
   Create a `.env` file in the root directory and add your Supabase credentials:
   ```env
   SUPABASE_URL=your-supabase-url
   SUPABASE_ANON_KEY=your-supabase-anon-key
   ```

4. **Run the application:**
   ```bash
   flutter run
   ```

---

## 🎨 Design & Typography

MoneyPlus uses a curated design system with a focus on readability and modern aesthetics:
- **English Font**: [Rubik](https://fonts.google.com/specimen/Rubik)
- **Arabic Font**: [Cairo](https://fonts.google.com/specimen/Cairo)
