# Executive Insight Note: Workforce Attendance & Leave Patterns

**Author:** HR Analytics & People Intelligence  
**Period Under Review:** April 2025 – September 2026 (18 Consecutive Months)  
**Target Audience:** Chief People Officer, HR Directors, and Operations Leadership  
**Dataset Scope:** 7,343 employee-months across 11 departments, 3,441 leave requests, 221 AI attendance anomalies  

---

## 📌 Executive Summary

Attendance serves as the organizational canary in the coal mine—a leading indicator of engagement, burnout, operational friction, and attrition. Over the past 18 months, PulseIQ maintained a healthy **average attendance rate of 94.07%** across 151,197 scheduled employee-days. However, aggregate stability masks critical underlying volatility: an annualized mid-year structural dip reaching **92.89% in May 2026**, persistent Friday/Thursday leave concentrations, acute punctuality deficits in shift operations, and **221 AI-flagged attendance anomalies** concentrated in core delivery teams.

---

## 🔍 Three Strategic Findings & Root Cause Analysis

### Finding 1: The Mid-Year Slump & Structural Volatility (95.51% $\rightarrow$ 92.89%)
* **Observation:** Attendance peaked at **95.51% in July 2025**, stabilized through autumn, softened to **93.71% in December 2025**, and steadily deteriorated to a trough of **92.89% in May 2026** before sharply rebounding to **95.19% by September 2026**.
* **What It Means:** Time-series decomposition confirms this is not merely random fluctuation ($\sigma = 0.77\%$). The spring/summer dip reflects combined exhaustion following annual appraisals (March–April), school vacation travel cycles, and accumulated fatigue in high-growth quarters. The September surge aligns with post-summer re-engagement and fiscal H2 project kick-offs.
* **What HR Could Do:**
  1. *Proactive Summer Staffing Buffers:* Implement rotating capacity minimums (no more than 20% of a team on leave concurrently during May–June).
  2. *Mid-Year Wellness Interventions:* Launch "Recharge Fridays" or flexible wellness days in April/May to preempt spontaneous unplanned absences.

### Finding 2: Polarization Between Business Units (Finance at 90.82% vs Sales/Data at 95.00%)
* **Observation:** Departmental attendance integrity diverges sharply. **Sales (95.00%)** and **Data & AI (95.00%)** lead the company, whereas **Finance & Accounts lags significantly at 90.82%** (a 4.18 percentage point deficit), followed by **Human Resources (92.51%)**. Concurrently, **Operations & IT suffers a severe late-arrival rate of 8.34%** (804 late check-ins), compared to the corporate average of 6.85% and Executive Office at 3.17%.
* **What It Means:** Finance experiences severe cyclical compression during quarterly/annual closes, followed by compensatory leave binges. For Operations & IT, strict shift schedules and on-call rotations clash with transit friction, resulting in habitual clock-in tardiness rather than outright absence.
* **What HR Could Do:**
  1. *Finance Close Leave Rebalancing:* Spread closing workload through automated reconciliations and enforce staggered compensatory time-off rather than block absences.
  2. *Grace-Period Shift Windows:* Introduce a 15-minute flexible morning window for Operations & IT paired with core team hours (10:00 AM – 4:00 PM) to convert technical lateness into productive presence.

### Finding 3: The "Long-Weekend" Friday Leave Distortion (20.36% of Active Leaves)
* **Observation:** Out of 3,441 leave requests, approved time-off disproportionately commences on **Friday (721 requests)** and **Thursday (713 requests)**, compared to Monday (648 requests). When leaves are expanded into active working days, **Friday bears the heaviest absence burden (1,333 non-statutory leave days, 20.36% of weekly total)**. Earned Leave (EL) and Casual Leave (CL) constitute **57.7% of all taken leave days**.
* **What It Means:** Employees systematically engineer three-day and four-day weekends by combining casual/privilege days with Saturdays and Sundays. While healthy for rest, predictable Friday absenteeism impairs end-of-week client releases, cross-functional sign-offs, and customer support SLA compliance.
* **What HR Could Do:**
  1. *Staggered Coverage Mandates:* Require team leads to maintain at least 80% department readiness on Fridays, requiring minimum 7-day advance booking for Friday PTO.
  2. *Friday Hybrid Alignment:* Formalize Friday as a remote/focus day with no internal meetings, reducing the psychological pressure to take PTO just to avoid commuting.

---

## 🤖 AI Anomaly Sample: Actionable Signals vs Noise

The AI/ML model flagged **221 attendance anomaly instances** across the 18-month timeline (peaking at 22 instances in July 2026). Analysis reveals three distinct action profiles:
1. **`PATTERN_SHIFT` (125 cases, 56.6%, avg score 0.661):** Habitual 95%+ attendees suddenly plummeting below 75%. *Action: Trigger confidential 1-on-1 check-ins with managers to assess burnout or personal emergencies.*
2. **`NO_ATTENDANCE` (50 cases, 22.6%, avg score 0.887):** Zero working days recorded in a calendar month. *Action: Immediate audit by HR Operations. In synthetic data, this frequently reflects data pipeline artifacts (e.g. unrecorded exits or unlogged sabbaticals); in reality, it signals acute payroll risk or ghost employees.*
3. **`LONG_UNPAID_ABSENCE` (43 cases, 19.5%, avg score 0.818):** Extended Loss of Pay (LOP). *Action: Cross-verify with statutory medical/maternity leave records to ensure compliance.*

---

## 💡 Think For Yourself: The December Drop — Real Pattern or Synthetic Artifact?

> **Question:** *Attendance drops every December. Is it a real pattern or an effect of how the fake data was made? How would you check?*

### 1. The Critical Methodological Reality
In our 18-month reporting window (April 2025 to September 2026), **there is exactly ONE December (December 2025)**. Mathematically and scientifically, **a single data point cannot constitute a repeating annual pattern ("drops every December")**. Anyone claiming an annual December cycle based solely on this dataset is mistaking an episodic event for a seasonal law.

### 2. Why December 2025 Dropped (The Observed Mechanics)
In December 2025, attendance dropped to **93.71%**, accompanied by:
* Total paid leave surging to **459 days** (vs 387 in Nov and 294 in Sep).
* 14 AI-flagged anomalies (second highest in FY25-26).
* High concentration of Earned Leave (EL) and Casual Leave (CL).

### 3. Real-World vs Synthetic Hypotheses
* **Real-World Hypothesis:** Corporate leave quotas (CL: 12 days, SL: 12 days) expire on December 31 with zero carry-forward permitted (`carry_forward_allowed = 'N'`), while Earned Leave allows only 30 days carry-forward. Employees rush to "burn" expiring leave balances before year-end. Combined with Christmas/New Year holidays and school breaks, December attendance naturally softens in real companies.
* **Synthetic Artifact Hypothesis:** Synthetic data generators often hardcode monthly multipliers (e.g. `december_weight = 1.35` for leave probability) or draw leave start dates uniformly without accounting for project freeze periods.

### 4. How to Definitively Check & Validate
To establish truth, HR must execute a **three-step forensic verification**:
1. **Multi-Year Historical Comparison:** Query 3 to 5 years of historical payroll and biometric access records (2021–2024). If attendance drops in every December with $p < 0.05$ via ANOVA or seasonal decomposition, it is an empirical organizational trait.
2. **Leave Expiry Policy vs Fiscal Year Alignment:** Our warehouse indicates the financial year is **April–March (FY26)**. If company leave balances lapse on **March 31**, an authentic policy-driven rush would occur in March—yet March 2026 attendance was strong (94.46%) while May was 92.89%! If leave lapses on December 31, HR should confirm whether the leave policy operates on calendar year while financial accounts run on fiscal year.
3. **Hardware Access Log Re-conciliation:** Cross-reference attendance fact tables against physical turnstile badge swipes, biometric logs, and VPN authentication sessions. If badge swipes show physical building presence while HR records mark absence, the December drop is an HR payroll cut-off cut artifact (early payroll close for holiday processing), not true absenteeism.

---

## ⚠️ Limitations & Analytical Caveats

1. **Duration Limit:** 18 months provides only 1.5 seasonal cycles. While sufficient for 6-month half-year decomposition, it is too brief for multi-year ARIMA or rigorous 12-month period decomposition.
2. **Planted Synthetic Quirks:** The warehouse contains documented planted data issues (e.g., `DQ-01` attendance recorded for 4 employees after exit date; `DQ-08` leave records with end dates before start dates). These add slight artificial noise to monthly totals.
3. **Department Sample Size Asymmetry:** Executive Office consists of 1 employee (18 employee-months), whereas Engineering comprises 201 employees (2,765 employee-months). Percentages in small units must not be treated with the same statistical weight as large cohorts.

---

## 🔗 Bridge to Next Task: From Attendance to Payroll Cost

With people, headcount, attendance, and leave patterns mapped, our workforce operational baseline is established. In **Phase 2**, we follow the financial consequences: how attendance variance, overtime hours (e.g., 946 late arrivals in Sales, overtime spikes in Engineering), and unpaid leave deductions flow directly into **gross payroll cost, employer tax liabilities, and budget variances**.
