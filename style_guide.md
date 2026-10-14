# PulseIQ Analytics — Attendance & Leave Design System & Style Guide

Consistent visual standards ensure data clarity, cognitive ease, and universal accessibility.

---

## 🎨 1. Okabe-Ito Color-Blind Safe Palette

All charts and UI elements must strictly adhere to the Okabe-Ito accessible color system:

| Role / Concept | Hex Code | Swatch / Name | Superset Usage |
|---|---|---|---|
| **Primary Trend (Present / Attendance)** | `#0072B2` | Blue | Line trend, primary attendance bars |
| **Secondary Trend (3M Rolling)** | `#009E73` | Bluish Green | Smoothed 3-month moving average |
| **Warning / Late Arrivals** | `#E69F00` | Orange | Late arrival counts & lateness rate |
| **Alert / AI Anomalies / Unpaid** | `#D55E00` | Vermilion | AI flagged anomaly scatter points, LOP |
| **Leave (Approved Privilege / Casual)** | `#56B4E9` | Sky Blue | Leave bar segments (EL, CL) |
| **Special Leave (Maternity / Medical)** | `#CC79A7` | Reddish Purple | Statutory Maternity & Sick leaves |
| **Neutral / Scheduled Days** | `#6c757d` | Slate Gray | Background scheduled capacity |
| **Canvas Background** | `#F8F9FA` | Off-White | Dashboard card and page background |
| **Card Surface** | `#FFFFFF` | Pure White | Elevated metric cards |
| **Dark Text** | `#212529` | Charcoal | Primary labels, headers, numbers |

---

## 📐 2. Typography & Metric Formatting

* **Font Stack:** `-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif`
* **KPI Card Format:** Large bold value (`32px`, font-weight `700`), uppercase tracked label (`12px`, letter-spacing `0.05em`), contextual subtext (`13px`, `#6c757d`).
* **Percentage Rounding:** Exactly 2 decimal places for rates (e.g. `94.07%`), 1 decimal place for approval rates (e.g. `89.1%`).
* **Integer Formatting:** Thousands separated by commas (e.g. `141,643 days`, `9,689 lates`).

---

## 🎛️ 3. Information Hierarchy

1. **Header & Context:** Title, subtitle, temporal breadcrumb (`Apr 2025 – Sep 2026`), and interactive filter bar.
2. **KPI Scorecards:** 4 core headline cards (Attendance Rate, Total Lates, Approved Leaves, AI Anomalies).
3. **Primary Time-Series View:** Full-width dual-axis line chart with rolling average and AI anomaly scatter marks.
4. **Diagnostic Grids (2x2):**
   - Department Attendance & Lateness Ranking
   - Weekday Leave Distribution (Monday–Friday)
   - Leave Type Breakdown (EL, CL, SL, ML, BL, LOP)
   - Time-Series Decomposition Components (Observed, Trend, Seasonal, Residual)
5. **Executive Takeaways:** Dedicated takeaway callout boxes beneath each visualization.
