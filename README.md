# 🌌 LunaFinance Pro

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-003B5C?style=for-the-badge&logo=sqlite&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**LunaFinance Pro** is a high-performance, professional financial management application designed for precision, efficiency, and aesthetic excellence. Built by **Luna Agent** for **Boss Her**, this app transforms the mundane task of expense tracking into a streamlined, data-driven experience.

---

## 🚀 Key Features

### 💎 Elite Dashboard
* **Real-time Balance:** Instant visibility of total funds, total income, and total expenses.
* **Modern UI:** Crafted with Material Design 3, featuring a sleek indigo-themed glassmorphism aesthetic.
* **Quick Summary:** At-a-glance cards for immediate financial awareness.

### 📊 Advanced Reporting (The "Pro" Suite)
* **Temporal Filtering:** Seamlessly switch between **Daily**, **Monthly**, and **Yearly** reports.
* **Visual Analytics:** Dynamic Pie Charts powered by `fl_chart` to visualize spending distribution across categories.
* **Data-Driven Insights:** Identify spending patterns and optimize budgets based on accurate temporal data.

### 🛠 Technical Excellence
* **Persistent Storage:** Local SQLite database via `sqflite` ensures your data remains on your device and is available offline.
* **Reactive State:** Built with the `Provider` pattern, ensuring the UI updates instantly upon every transaction.
* **Clean Architecture:** Structured using a Model-Service-Provider layer for maximum scalability and maintainability.

---

## 🛠 Tech Stack

| Component | Technology | Purpose |
| :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev) | Cross-platform UI development |
| **Language** | [Dart](https://dart.dev) | Strongly typed logic & performance |
| **Database** | [SQLite](https://www.sqlite.org/) | Local persistent storage |
| **State Mgmt** | [Provider](https://pub.dev/packages/provider) | Reactive state synchronization |
| **Charts** | [fl_chart](https://pub.dev/packages/fl_chart) | High-performance data visualization |
| **Formatting** | [intl](https://pub.dev/packages/intl) | Currency & Date localization (IDR) |

---

## 📦 Build & Installation

This project is integrated with **GitHub Actions**. You don't need to install Flutter locally to get the app.

### ☁️ Cloud Build (Automatic)
1. Every push to the `main` branch triggers the **Flutter Android Build** workflow.
2. Go to the **Actions** tab in this repository.
3. Select the latest successful run.
4. Scroll down to **Artifacts** and download `luna-finance-pro-apk`.
5. Install the `.apk` on your Android device.

### 💻 Manual Build
```bash
git clone https://github.com/NdronksG/luna-finance-pro.git
cd luna-finance-pro
flutter pub get
flutter run
```

---

## 🏗 Project Structure

```text
lib/
├── main.dart                # Application entry point & UI Root
├── models/
│   └── transaction.dart     # Data model for financial entries
├── services/
│   ├── database_helper.dart  # SQLite implementation (CRUD)
│   └── finance_provider.dart # Business logic & report filtering
└── screens/                  # (Integrated in main.dart for prototype speed)
```

---

## ✍️ Credits

Developed with ❤️ and extreme precision by **Luna Agent** 🫡  
*Designed exclusively for **Boss Her**.*

---
`System Status: Optimal` | `Efficiency: 100%` | `Result: Delivered`
