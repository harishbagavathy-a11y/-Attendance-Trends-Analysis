# Time-Series Analysis Methodology & Technical Documentation

**Target Frameworks:** `statsmodels.tsa.seasonal` (time-series decomposition), `pandas` (rolling windows, resampling, MoM differencing)  
**Reporting Horizon:** April 2025 to September 2026 (18 Monthly Intervals)  

---

## 1. Mathematical Foundations & Metrics

### 1.1 Attendance Rate ($\text{AR}_t$)
In accordance with metric definition **M13** from the enterprise metric dictionary:
$$\text{AR}_t = \frac{\sum \text{Present Days}_t + 0.5 \times \sum \text{Half Days Unpaid}_t}{\sum \text{Scheduled Working Days}_t}$$
* *Scheduled Working Days:* Standard working days in month $t$ excluding public holidays and weekends.
* *Half Day Weighting:* 0.5 coefficient captures half-day unexcused absences.

### 1.2 Late Arrival Rate ($\text{LAR}_t$)
In accordance with metric definition **M14**:
$$\text{LAR}_t = \frac{\sum \text{Late Arrivals}_t}{\sum \text{Present Days}_t}$$

### 1.3 3-Month Rolling Average ($\text{MA}_3(t)$)
To filter short-term monthly noise and expose secular direction, a 3-month trailing moving average is calculated via `pandas`:
$$\text{MA}_3(t) = \frac{1}{k} \sum_{i=0}^{k-1} \text{AR}_{t-i} \quad \text{where } k = \min(t, 3)$$
```python
monthly["rolling_3m_attendance_pct"] = (
    monthly["attendance_rate_pct"].rolling(window=3, min_periods=1).mean()
)
```

### 1.4 Month-over-Month Change ($\Delta \text{MoM}_t$)
First-order discrete difference:
$$\Delta \text{MoM}_t = \text{AR}_t - \text{AR}_{t-1}$$

---

## 2. Time-Series Decomposition via `statsmodels`

### 2.1 Model Specification
We utilize an **additive decomposition model**:
$$Y_t = T_t + S_t + R_t$$
where:
* $Y_t$: Observed monthly attendance rate at month $t$.
* $T_t$: Underlying macro trend component (moving average / linear trend).
* $S_t$: Periodic seasonal component reflecting recurring annual/semi-annual workforce cycles.
* $R_t$: Residual component (random noise, idiosyncratic shocks, and planted data errors).

### 2.2 Handling Sample Horizon (18 Periods)
Classical annual decomposition with $m = 12$ requires at least $2m = 24$ complete observations to prevent endpoint degrees-of-freedom collapse in symmetric moving filters. Because our reporting horizon is 18 months:
1. We specify $m = 6$ (half-year corporate performance and appraisal cycles), yielding 3 complete seasonal cycles across the 18 months.
2. We enable `extrapolate_trend="freq"` to preserve boundary estimates for the opening (Apr–May 2025) and closing (Aug–Sep 2026) periods.
```python
from statsmodels.tsa.seasonal import seasonal_decompose

decomp = seasonal_decompose(
    series,
    model="additive",
    period=6,
    extrapolate_trend="freq"
)
```

### 2.3 Decomposition Outputs Summary

| Month | Observed ($Y_t$) | Trend ($T_t$) | Seasonal ($S_t$) | Residual ($R_t$) | Interpretation |
|---|---|---|---|---|---|
| **2025-04** | 94.58% | 94.75% | +0.22% | -0.39% | Stable spring baseline |
| **2025-07** | 95.51% | 94.88% | +0.65% | -0.02% | Peak summer discipline |
| **2025-10** | 93.88% | 94.21% | -0.15% | -0.18% | Festival season dip |
| **2025-12** | 93.71% | 93.84% | -0.28% | +0.15% | Year-end holiday softness |
| **2026-05** | 92.89% | 93.42% | -0.58% | +0.05% | Trough annual low |
| **2026-09** | 95.19% | 94.30% | +0.65% | +0.24% | Rebound momentum |

* **Key Takeaway:** The underlying trend exhibited a moderate downward drift of **-1.46%** between July 2025 (94.88%) and May 2026 (93.42%), before turning upward in Q3 2026.

---

## 3. AI/ML Sample Anomaly Overlay Integration

### 3.1 Model Architecture Context
The AI/ML data science team trained an unsupervised isolation forest and sequence anomaly detector (`model_version = v1.2`) on monthly attendance feature vectors. 

### 3.2 Reason Codes & Weighting
The 221 attendance anomaly instances break down into 4 clear classifications:
* **`PATTERN_SHIFT` (56.6%, 125 records):** Triggers when an employee's attendance rate falls $> 2.5\sigma$ below their historical 6-month trailing mean.
* **`NO_ATTENDANCE` (22.6%, 50 records):** Zero presence logged for an entire month without approved long-term leave.
* **`LONG_UNPAID_ABSENCE` (19.5%, 43 records):** High accumulation of Loss of Pay (LOP) days.
* **`FREQUENT_LATE` (1.4%, 3 records):** Chronic morning tardiness exceeding $> 10$ occurrences in a single period.

### 3.3 Overlay Mapping
On the monthly trends chart, AI anomaly volume is plotted on the secondary y-axis to visualize the correlation between aggregate attendance dips and anomaly volume surges (notably in May–July 2026).
