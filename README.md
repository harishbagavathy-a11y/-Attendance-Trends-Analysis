# PulseIQ Analytics — Task 4: Attendance & Leave Analytics

> **Separated File Structure**: All charts, filters, takeaways, summary SQL queries, time-series decomposition models, and style guides are modularized into dedicated directories.

---

## 📌 Executive Overview

Attendance is the primary operational signal of workforce engagement and operational health. HR and business unit leaders rely on attendance trends to plan staffing, preempt burnout, manage leave liabilities, and detect systemic disengagement.

This project delivers:
1. **Production SQL Summary Queries**: Full coverage across monthly rates, department rankings, weekday distributions, leave type mix, late arrivals, and AI anomaly samples.
2. **Time-Series Analysis (`statsmodels` & `pandas`)**: Additive seasonal decomposition, 3-month trailing moving averages, and month-over-month (MoM) delta tracking.
3. **AI/ML Anomaly Integration**: Direct incorporation of the 221 attendance anomaly instances flagged by the AI/ML data science team (`attendance_monthly_features`), cross-tabulated with root-cause classifications (`PATTERN_SHIFT`, `NO_ATTENDANCE`, `LONG_UNPAID_ABSENCE`, `FREQUENT_LATE`).
4. **Attendance & Leave Interactive Dashboard (`dashboard_preview.html`)**: Complete responsive interface featuring KPI scorecards, interactive filter controls, dual-axis trendlines with anomaly scatter points, department horizontal rankings, and weekday load distributions.
5. **Executive Insight Note (`docs/insight_note.md`)**: A concise, 1-page strategic memorandum detailing three core findings, root-cause interpretations, actionable HR interventions, analytical limitations, and the deep **"Think for Yourself"** December attendance drop analysis.

---

## 📁 Directory & File Index

### 📊 Individual Chart Files (`charts/`)
1. [`charts/01_monthly_attendance_trend.json`](charts/01_monthly_attendance_trend.json) — 18-month attendance rate, 3-month rolling average, MoM delta, and AI anomaly markers.
2. [`charts/02_department_attendance_ranking.json`](charts/02_department_attendance_ranking.json) — Attendance rate (95.00% to 90.82%) and lateness rate (3.17% to 8.34%) across 11 departments.
3. [`charts/03_weekday_leave_pattern.json`](charts/03_weekday_leave_pattern.json) — Weekday distribution of 3,441 leave requests and 6,546 active working days (Monday–Friday).
4. [`charts/04_leave_type_breakdown.json`](charts/04_leave_type_breakdown.json) — Leave consumption and approval rates across EL, CL, SL, ML, BL, and LOP.
5. [`charts/05_late_arrivals_trend.json`](charts/05_late_arrivals_trend.json) — Monthly late arrivals volume (avg 538/month) and department lateness concentrations.
6. [`charts/06_ai_anomaly_distribution.json`](charts/06_ai_anomaly_distribution.json) — AI/ML sample anomaly breakdown by reason code and department distribution.
7. [`charts/07_seasonal_decomposition.json`](charts/07_seasonal_decomposition.json) — Statsmodels additive decomposition components (Observed, Trend, Seasonal, Residual).
8. [`charts/08_kpi_summary_cards.json`](charts/08_kpi_summary_cards.json) — Headline KPI metrics (94.07% Attendance, 9,689 Lates, 7,508 Approved Leaves, 221 AI Flags).

### 🎛️ Individual Filter Files (`filters/`)
1. [`filters/department_filter.json`](filters/department_filter.json) — Multi-select filter across all 11 business units.
2. [`filters/date_range_filter.json`](filters/date_range_filter.json) — Temporal window filter (2025-04 to 2026-09) with fiscal presets.
3. [`filters/leave_type_filter.json`](filters/leave_type_filter.json) — Multi-select statutory and company leave code filter.
4. [`filters/anomaly_toggle_filter.json`](filters/anomaly_toggle_filter.json) — AI anomaly scatter overlay toggle and threshold controls.

### 📝 Production SQL Summary Queries (`sql/`)
1. [`sql/01_attendance_rate_by_month.sql`](sql/01_attendance_rate_by_month.sql) — Monthly attendance rate, scheduled/present days, 3M rolling average, MoM delta, and anomaly count.
2. [`sql/02_attendance_by_department.sql`](sql/02_attendance_by_department.sql) — Department attendance ranking, scheduled vs present, lateness rate, and WFH share.
3. [`sql/03_leave_and_attendance_by_weekday.sql`](sql/03_leave_and_attendance_by_weekday.sql) — Weekday leave initiation count and working-day leave volume.
4. [`sql/04_leave_days_by_type.sql`](sql/04_leave_days_by_type.sql) — Requests and days by leave type (EL, CL, SL, ML, BL, LOP) and approval status.
5. [`sql/05_late_arrivals_analysis.sql`](sql/05_late_arrivals_analysis.sql) — Lateness frequency and rates by month and department.
6. [`sql/06_ai_anomaly_summary.sql`](sql/06_ai_anomaly_summary.sql) — AI anomaly reason codes, scores, and attendance cross-tabulation.

### 📌 Verified Takeaways (`takeaways/`)
1. [`takeaways/chart_takeaways.md`](takeaways/chart_takeaways.md) — Executive takeaway sentences table.
2. [`takeaways/chart_takeaways.json`](takeaways/chart_takeaways.json) — Machine-readable takeaways for UI binding.

### 📚 Documentation & Research Notes (`docs/`)
1. [`docs/insight_note.md`](docs/insight_note.md) — 1-Page Strategic Insight Note with 3 findings, interpretations, HR actions, limitations, and the December Drop analysis.
2. [`docs/time_series_methodology.md`](docs/time_series_methodology.md) — Technical documentation on `statsmodels` additive decomposition, `pandas` rolling windows, and anomaly scoring.
3. [`docs/style_guide.md`](docs/style_guide.md) — Okabe-Ito color-blind safe palette, visual hierarchy, and number formatting rules.

### 💻 Scripts & Dashboards
1. [`scripts/time_series_analysis.py`](scripts/time_series_analysis.py) — End-to-end Python pipeline running statsmodels decomposition, pandas calculations, and asset generation.
2. [`dashboard_preview.html`](dashboard_preview.html) — Interactive visual preview with responsive charts, filters, and KPI cards.

---

## 💡 The "Think For Yourself" Analysis: The December Attendance Drop

> **Question:** *Attendance drops every December. Is it a real pattern or an effect of how the fake data was made? How would you check?*

### 1. The Methodological Truth
The reporting horizon spans **18 months (April 2025 – September 2026)**, containing **only ONE December (December 2025)**. Statistically, **a single occurrence cannot prove a repeating seasonal law ("every December")**. Extrapolating an annual rule from a single observation is an unverified assumption.

### 2. Hypotheses
* **Real-World Hypothesis:** Company leave policies enforce a "use-it-or-lose-it" rule on December 31 for Casual and Sick leaves (`carry_forward_allowed = 'N'`), with Earned Leave capped at 30 days. Employees rush to exhaust unused leave quotas before expiry, coinciding with Christmas and school holidays.
* **Synthetic Artifact Hypothesis:** Synthetic data generators typically apply a static monthly probability multiplier (e.g. `month_leave_factor = 1.35`) or generate uniform leave requests across the calendar year without factoring in quarterly project release freezes.

### 3. How HR Would Definitively Check:
1. **Multi-Year Historical Audit:** Query 3 to 5 years of historical records (2021–2024). Perform an ANOVA test or STL seasonal decomposition across multiple Decembers to verify whether the December drop is statistically significant ($p < 0.05$).
2. **Leave Policy vs Fiscal Calendar Audit:** In this enterprise, the financial year runs from **April to March (FY26)**. If leave expiry aligns with the fiscal year (March 31), an authentic year-end rush would peak in March—yet March 2026 attendance was strong (94.46%) while May was 92.89%! Confirm whether HR policies operate on a calendar-year leave cycle while Finance operates on a fiscal-year cycle.
3. **Biometric & VPN Access Cross-Validation:** Cross-reference attendance fact tables against physical turnstile badge swipes and SSO/VPN server authentication logs. If employees logged into corporate networks on days marked absent in payroll, the drop is an HR payroll cut-off artifact (early payroll close for holiday processing), not authentic absence.

---

## 🚀 How to Run & Verify

### Run the Time-Series Pipeline:
```bash
python scripts/time_series_analysis.py
```

### Execute SQL Queries in PostgreSQL Warehouse:
```bash
docker exec -i pulseiq_postgres psql -U postgres -d pulseiq_dw < sql/01_attendance_rate_by_month.sql
```

### View Interactive Dashboard:
Open [`dashboard_preview.html`](dashboard_preview.html) in any modern web browser or preview via VS Code Live Server.

---

## 🔗 Connection to Next Task (Phase 2: Following the Money)

With active headcount (Task 3) and attendance integrity (Task 4) mapped, Phase 1 (People & Operations) is complete. In **Phase 2**, we follow the money—tracking how attendance variance, overtime hours (e.g. 946 late check-ins in Sales, overtime spikes in Engineering), and Loss of Pay (LOP) deductions flow directly into **gross payroll expense, employer statutory contributions (PF/ESI), and monthly budget variances**.
