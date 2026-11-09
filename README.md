# Personal Budget Planner 💰📊

A modern, responsive, and feature-rich **Personal Budget Planner** web application built using **Flutter & Dart**. Designed for students and individuals to efficiently track incomes, manage categorised expenses, maintain monthly budgets, track savings goals, and visualise financial health through interactive charts.

---

## 🚀 Live Demo & Repository
- **Live Application**: [https://surya-nandini0105.github.io/Personal-Budget-Planner/](https://surya-nandini0105.github.io/Personal-Budget-Planner/)
- **GitHub Repository**: [https://github.com/Surya-Nandini0105/Personal-Budget-Planner](https://github.com/Surya-Nandini0105/Personal-Budget-Planner)
- **Platform**: Web (Responsive across Desktop, Tablet, and Mobile).
- **Currency**: Indian Rupee (`₹`).

---

## ✨ Features

### 1. 📊 Financial Dashboard
- **Total Income**, **Total Expenses**, and **Available Balance** calculation.
- **Monthly Savings** overview.
- **Recent Transactions** preview with quick navigation.
- One-tap quick actions: **Add Income** and **Add Expense**.

### 2. 💵 Income Management
- Add, edit, and delete income records.
- Predefined categories: *Salary, Freelance, Business, Investment, Rental, Gift, Refund, Others*.
- Categorised color badges and custom icons.

### 3. 💳 Expense Management
- Categorised expenses: *Food, Shopping, Education, Travel, Health, Bills, Entertainment, Others*.
- Full editing and deletion support with swipe gestures.
- Custom date selection and transaction notes.

### 4. 🎯 Budget Management
- Set monthly budget limits.
- Real-time expense tracking against budget.
- Visual progress bar with color-coded warnings (Green < 80%, Orange > 80%, Red for Over-budget).
- Remaining budget calculation and month-to-month history navigation.

### 5. 📜 Transaction History & Filtering
- Chronological list of all financial records.
- Real-time search by title, amount, or category.
- Filter chips: All, Income, Expense, or Category-specific filters.
- Dismissible swipe-to-delete with confirmation modal.

### 6. 📈 Interactive Analytics & Reports
- **Bar Charts**: Month-by-month Income vs. Expenses comparison.
- **Line Charts**: Monthly savings trend line throughout the year.
- **Pie Charts**: Category-wise expense breakdown with percentage distribution.
- Annual financial summary and savings rate calculation.

### 7. 🏆 Savings Goals
- Create custom savings targets (e.g., Emergency Fund, Laptop, Vacation).
- Real-time progress bars with completion percentages.
- Quick deposit/contribution dialog to add funds towards goals.
- Celebration badge upon completing savings goals.

### 8. ⚙️ Settings & Customization
- **Dark Mode / Light Mode** instant theme toggle.
- Default Indian Rupee (`₹`) configuration.
- Local data statistics and total count.
- **Reset All Data** option with safe confirmation dialog.

---

## 🛠️ Technology Stack

| Component | Technology / Library |
|-----------|----------------------|
| Framework | **Flutter 3.44+** |
| Language | **Dart 3.12+** |
| State Management | **Provider 6.1.5** |
| Local Persistence | **SharedPreferences** |
| Data Visualisation | **fl_chart 0.70.2** |
| Typography | **Google Fonts (Poppins)** |
| Formatting | **Intl (en_IN Currency & Dates)** |
| Unique Identifiers | **UUID** |

---

## 📂 Project Structure

```
lib/
├── main.dart                      # App entry point & provider bootstrapping
├── models/
│   ├── transaction_model.dart     # Transaction data model (Income/Expense)
│   ├── budget_model.dart          # Monthly budget limits model
│   └── savings_goal_model.dart    # Target & saved amount goals model
├── providers/
│   └── app_provider.dart          # Global state management & computations
├── services/
│   └── storage_service.dart       # SharedPreferences persistence layer
├── utils/
│   ├── app_theme.dart             # Material 3 light and dark theme styling
│   └── constants.dart             # Categories, icons, palette & storage keys
└── screens/
    ├── home_screen.dart           # IndexedStack navigation shell
    ├── dashboard_screen.dart      # Summary cards & recent activity
    ├── transaction_history_screen.dart # Search, filters, swipe-to-delete
    ├── add_transaction_screen.dart     # Dynamic form for income & expense
    ├── budget_screen.dart         # Monthly budget tracking & progress
    ├── reports_screen.dart        # FL Chart analytics & category pie chart
    ├── savings_goals_screen.dart  # Goals tracker with deposit feature
    └── settings_screen.dart       # Theme switch & storage reset
```

---

## 🏃 Getting Started (Local Setup)

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
- Google Chrome or any modern web browser.

### Run Application
1. Clone or open the project directory:
   ```bash
   cd "personal budget planner"
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run the web application:
   ```bash
   flutter run -d chrome
   ```
   *Or with a standalone local web-server:*
   ```bash
   flutter run -d web-server --web-port 8080
   ```

---

## 📦 Production Web Build

To create the production release build for hosting:
```bash
flutter build web --release
```
The compiled static assets will be located in `build/web/`.
