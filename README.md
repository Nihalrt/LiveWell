# LiveWell Navigator

**Cost-of-Living & Savings Coach**

An ongoing Flutter mobile app that helps you evaluate whether your budget aligns with the cost of living in your chosen city, then provides AI-powered tips to maximize your savings, pay less taxes, and live an amazing life.

---

## Table of Contents
1. [Features](#features)
2. [Screenshots](#screenshots)
3. [Tech Stack](#tech-stack)
4. [Getting Started](#getting-started)
5. [Usage](#usage)
6. [Build & Distribution](#build--distribution)
7. [Roadmap](#roadmap)
8. [Contributing](#contributing)
9. [License](#license)

---

## Features
- **Profile Input**  
  - Desired location (city, province/state)  
  - Monthly salary  
  - Detailed expense breakdown (housing, utilities, food, transport, insurance, other)  
  - Household size & age bracket

- **Results Page**  
  - Feasibility status (Feasible / Marginal / Not Feasible) with color-coded badge  
  - Interactive pie chart of expense categories (powered by `fl_chart`)  
  - Gradient-styled cards for salary vs. expenses and feasibility summary

- **AI-Powered Recommendations**  
  - Integrated with Google Gemini (Generative Language API)  
  - Sends your profile & budget breakdown to Gemini  
  - Displays 5 actionable, personalized tips in a horizontally scrollable gradient card carousel

---

## Tech Stack
- **Flutter & Dart** for cross-platform mobile development  
- **fl_chart** for pie charts and data visualization  
- **patch_package** to patch dependencies at build-time  
- **flutter_dotenv** for environment variable management  
- **Google Generative Language API (Gemini)** for AI recommendations

---

## Getting Started
1. **Clone the repo**  
   ```bash
   git clone https://github.com/<your-username>/live_well.git
   cd live_well
   ```
2. **Create a `.env` file** in the project root:  
   ```env
   GOOGLE_API_KEY=YOUR_GEMINI_API_KEY
   ```
3. **Install dependencies**  
   ```bash
   flutter pub get
   ```
4. **Run the app** on an emulator or connected device:  
   ```bash
   flutter run
   ```

---

##  Usage
1. Enter your desired **location**, **salary**, **expense categories**, **household size**, and **age bracket**.  
2. Tap **Check Feasibility**.  
3. Review your **budget report**: feasibility badge, pie chart, and summary cards.  
4. Scroll through **AI tips** for personalized savings and tax strategies.

---

## Build & Distribution
Generate a self-contained APK:  
```bash
flutter clean
flutter build apk --release
```  
APK located at `build/app/outputs/flutter-apk/app-release.apk`.  
Attach this APK to a GitHub Release and link it for easy downloads:

```markdown
[![Download APK](https://img.shields.io/badge/Download-APK-brightgreen)](https://github.com/Nihalrt/live_well/releases/latest/download/app-release.apk)
```

---

## Screenshots
<img width="259" alt="Screenshot 2025-05-20 172442" src="https://github.com/user-attachments/assets/76928880-a8bb-47e7-a650-cfa5391f7d31" />
<img width="263" alt="Screenshot 2025-05-20 172521" src="https://github.com/user-attachments/assets/a514da90-2401-4df0-918b-a6e2a333ac70" />

---

## Roadmap
- Receipt scanning & OCR for auto-expense capture  
- Tax optimization strategies (e.g. TFSA/RRSP guidance for Canadian users)  
- What‑If sliders to adjust salary/expenses live  
- Persisted profiles & history  
- Dark mode & theming  
- Multi-currency & localization support  
- Monthly spending comparison charts  
- Push notifications & reminders  
- Data export (PDF/CSV) and social sharing  
---

## Contributing
This project is **ongoing** and welcomes contributions! Feel free to:
- Open issues for bugs or feature requests  
- Submit PRs for new features or UI improvements  
- Improve documentation or add tests

---
