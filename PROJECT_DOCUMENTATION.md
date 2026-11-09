# PERSONAL BUDGET PLANNER
### Complete College Project Report & Viva Reference Guide

---

## 1. ABSTRACT
In modern society, financial management has become a critical skill for students, working professionals, and families. Without disciplined tracking, individuals often overspend and fail to meet long-term savings goals. The **Personal Budget Planner** is a cross-platform web application developed using Google's **Flutter** framework and **Dart** programming language. The system provides an interactive and intuitive interface for tracking incomes, recording categorised expenses, setting monthly budget ceilings, monitoring savings targets, and visualizing financial trends through charts. All user records are persistently stored locally using browser **SharedPreferences**, ensuring zero data leakage, high privacy, and offline operational ability.

---

## 2. INTRODUCTION
Personal financial tracking is the systematic recording of monetary inflows and outflows. Traditional manual bookkeeping or spreadsheet tools are tedious and prone to abandonment. The Personal Budget Planner is engineered to deliver a seamless, responsive, and aesthetically pleasing financial dashboard accessible on any modern web browser or mobile viewport.

---

## 3. PROBLEM STATEMENT
Most existing personal finance solutions:
1. Require intrusive user account registrations, phone numbers, or cloud credentials.
2. Incur recurring subscription costs for advanced analytics and chart visualisations.
3. Feature cluttered user interfaces with steep learning curves.
4. Pose privacy risks by sending sensitive personal financial figures to remote third-party servers.

---

## 4. OBJECTIVES
- To design a zero-friction, privacy-friendly personal budget management system.
- To implement complete **CRUD (Create, Read, Update, Delete)** operations for incomes and expenses.
- To introduce dynamic budget ceiling controls with automated alerts upon threshold breaches.
- To produce graphical data visualisations (Bar Charts, Line Charts, and Pie Charts) for quick insight.
- To implement goal-based savings tracking with progress milestones.
- To support responsive light and dark Material 3 user interfaces.

---

## 5. EXISTING SYSTEM VS. PROPOSED SYSTEM

| Parameter | Existing Systems (e.g., Excel / Apps) | Proposed System (Personal Budget Planner) |
|---|---|---|
| **Privacy** | Stored on third-party clouds or unencrypted files | 100% Client-side local storage (**SharedPreferences**) |
| **User Experience** | Complex formulas or ad-heavy mobile apps | Clean Material 3 UI with instant responsiveness |
| **Visualisation** | Static graphs requiring manual generation | Real-time interactive charts (**fl_chart**) |
| **Accessibility** | Desktop-dependent or OS-locked | Universal web access via Flutter Web |
| **Cost** | Often freemium with paywalls | 100% Free and Open Source |

---

## 6. SYSTEM MODULES

1. **Dashboard Module**: Consolidates financial state (Income, Expense, Net Balance, Monthly Savings) and displays recent transaction logs.
2. **Income Management Module**: Accepts amount, source category, dates, and notes for earnings.
3. **Expense Management Module**: Tracks multi-category expenditures (Food, Shopping, Education, Travel, Health, Bills, etc.) with real-time balance reduction.
4. **Budget Management Module**: Monthly budget limit allocator with visual progress gauges and warning flags (>80% and >100%).
5. **Transaction Ledger Module**: Searchable list with query filtering, multi-category chips, and swipe-to-delete gestures.
6. **Analytics & Reports Module**:
   - Monthly Income vs. Expense comparison (Bar Chart).
   - Net savings growth curve (Line Chart).
   - Category distribution (Pie Chart).
7. **Savings Goals Module**: Target-driven funds accumulator with dedicated progress meters and direct deposit actions.
8. **Settings & Customization Module**: Instant Dark/Light mode switcher, Indian Rupee currency standard, and local database wipe.

---

## 7. SYSTEM ARCHITECTURE

```
+--------------------------------------------------------------+
|                    PRESENTATION LAYER                        |
|   Dashboard | Transactions | Budget | Reports | Goals | Sets |
+--------------------------------------------------------------+
                               ▲
                               │ (State notifications / Listeners)
                               ▼
+--------------------------------------------------------------+
|                    STATE MANAGEMENT (PROVIDER)               |
|                      AppProvider (ChangeNotifier)            |
+--------------------------------------------------------------+
                               ▲
                               │ (CRUD Calls & Serialization)
                               ▼
+--------------------------------------------------------------+
|                    DATA PERSISTENCE LAYER                    |
|                        StorageService                        |
|                 SharedPreferences (Browser LocalStorage)     |
+--------------------------------------------------------------+
```

---

## 8. TECHNOLOGIES USED
- **Framework**: Flutter Web 3.44+
- **Language**: Dart 3.12+
- **State Pattern**: Provider (`ChangeNotifierProvider`, `Consumer`)
- **Persistence**: `shared_preferences`
- **Charting**: `fl_chart`
- **Typography & Icons**: `google_fonts` (Poppins), `MaterialIcons`
- **Localization**: `intl` (NumberFormat for `₹` Indian Rupee currency formatting)

---

## 9. TESTING & VERIFICATION

| Test Case ID | Test Description | Expected Result | Status |
|---|---|---|---|
| **TC01** | Add new Income (₹50,000) | Balance increases by ₹50,000; transaction logged | **PASS** |
| **TC02** | Add new Expense (₹12,000) | Balance decreases; category chart updates | **PASS** |
| **TC03** | Exceed Monthly Budget | Progress bar turns red; over-budget status displayed | **PASS** |
| **TC04** | Page Reload / Refresh | All transactions & budgets remain intact from storage | **PASS** |
| **TC05** | Filter Transactions by Category | Only matching category transactions displayed | **PASS** |
| **TC06** | Dark Mode Toggle | UI updates palette without resetting form state | **PASS** |

---

## 10. CONCLUSION & FUTURE ENHANCEMENTS

### Conclusion
The Personal Budget Planner successfully addresses the limitations of modern budget trackers by combining robust privacy, zero-setup onboarding, responsive design, and intuitive graphical visualisations into a single Flutter Web application.

### Future Enhancements
1. **Cloud Sync & Multi-Device Pairing**: Optional Firebase / Supabase backend synchronization.
2. **Receipt Scanning & OCR**: Automated expense entry via camera image processing.
3. **Export to PDF/Excel**: Downloadable monthly financial statement generation.
4. **SMS / UPI Transaction Parsing**: Automated expense capture from banking SMS on Android devices.

---

## 11. COLLEGE VIVA QUESTIONS & ANSWERS

**Q1: Why did you choose Flutter for this project instead of React or Angular?**  
*A:* Flutter provides a single unified codebase in Dart that compiles to high-performance JavaScript/WebAssembly for Web, while also capable of compiling natively to Android and iOS with zero UI rewrite.

**Q2: How does the application store data without a SQL database backend?**  
*A:* We use the `shared_preferences` plugin, which on Flutter Web utilizes the browser's persistent `window.localStorage` key-value store. Transactions and models are serialized to and from JSON strings.

**Q3: Explain the role of Provider in your application.**  
*A:* `AppProvider` extends `ChangeNotifier`. Whenever data is updated (e.g. adding an expense), `notifyListeners()` is triggered, causing only the relevant `Consumer` widgets across the UI to rebuild efficiently.

**Q4: How is over-budgeting detected and handled?**  
*A:* The provider computes total expenses for the selected month against the configured `BudgetModel.monthlyBudget`. When `expenses / monthlyBudget > 1.0`, the system renders warning alerts and switches the progress bar color to red.

**Q5: What library powers your chart visualisations?**  
*A:* `fl_chart`, an open-source Flutter charting library capable of rendering responsive Bar, Line, and Pie charts directly onto the canvas.
