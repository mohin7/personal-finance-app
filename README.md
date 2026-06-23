# TakaTrack — Personal Finance for Bangladesh

A production-ready Flutter app for tracking personal finances, built specifically for Bangladeshi users. Manage daily expenses, income, bank accounts, savings instruments (DPS, FDR, Sanchayapatra), investments, and monthly budgets — all stored locally on device with no account required.

## Features

- **Dashboard** — Net worth overview, asset breakdown, financial health score
- **Expense Tracker** — Daily expenses with category filtering and date grouping
- **Income Tracker** — Multiple income sources with monthly summaries
- **Cash Management** — Multi-account cash tracking (Cash in Hand, Wallet, Emergency Fund)
- **Bank Accounts** — Balance tracking across multiple bank accounts
- **DPS Management** — Monthly installment savings with maturity projection and progress tracking
- **FDR Management** — Fixed deposit tracking with live interest calculation
- **Sanchayapatra** — All 3 schemes (Family 11.52%, Pensioner 11.76%, 3-Month 11.28%) with profit calculation
- **Investment Portfolio** — Stocks, mutual funds, real estate — with ROI and P&L display
- **Budget Planner** — Monthly category budgets with over-budget alerts
- **Reports & Analytics** — Monthly income vs expense charts, category-wise pie chart
- **Dark Mode** — Full light/dark theme support

## Tech Stack

- **Flutter** — latest stable
- **Riverpod 2.x** — state management (no code generation)
- **Isar 3.x** — local database (runs fully offline)
- **GoRouter 14.x** — navigation
- **fl_chart** — charts and graphs
- **flutter_animate** — animations
- **Clean Architecture** — Repository pattern, feature-based folder structure

## Getting Started

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

> **Note:** Isar requires a native target. Run on iOS, Android, or macOS — not Chrome.

## Project Structure

```
lib/
├── core/          # Theme, router, constants, utilities
├── data/          # Isar models, repositories
├── features/      # One folder per module (expenses, income, banks, dps, ...)
└── shared/        # Reusable widgets, providers
```

## License

MIT
