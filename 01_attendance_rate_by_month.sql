-- ============================================================================
-- Query 01: Monthly Attendance Rate, Rolling Average & MoM Change
-- Purpose: Track overall organizational attendance momentum, identify seasonal dips,
--          compute 3-month rolling smoothing, and overlay AI anomaly counts.
-- Metric definition: Attendance Rate = (SUM(present_days) + 0.5 * SUM(half_days_unpaid)) / SUM(scheduled_days)
-- ============================================================================

WITH monthly_metrics AS (
    SELECT 
        d.year,
        d.month_number,
        d.month_name,
        d.year_month,
        COUNT(DISTINCT a.employee_id) AS active_employees,
        SUM(a.scheduled_days) AS total_scheduled_days,
        SUM(a.present_days) AS total_present_days,
        SUM(a.wfh_days) AS total_wfh_days,
        SUM(a.half_days_unpaid) AS total_half_days_unpaid,
        SUM(a.paid_leave_days) AS total_paid_leave_days,
        SUM(a.unpaid_absence_days) AS total_unpaid_absence_days,
        SUM(a.late_arrivals) AS total_late_arrivals,
        ROUND(AVG(a.avg_hours_worked), 2) AS avg_hours_worked,
        ROUND(
            (SUM(a.present_days) + 0.5 * SUM(a.half_days_unpaid))::NUMERIC / 
            NULLIF(SUM(a.scheduled_days), 0) * 100, 
            2
        ) AS attendance_rate_pct,
        ROUND(
            SUM(a.late_arrivals)::NUMERIC / 
            NULLIF(SUM(a.present_days), 0) * 100, 
            2
        ) AS late_arrival_rate_pct
    FROM fact_attendance_monthly a
    JOIN dim_date d ON a.date_key = d.date_key
    GROUP BY d.year, d.month_number, d.month_name, d.year_month
),
monthly_anomalies AS (
    SELECT 
        TO_CHAR(period, 'YYYY-MM') AS year_month,
        COUNT(*) AS ai_anomaly_count,
        ROUND(AVG(anomaly_score), 3) AS avg_anomaly_score
    FROM fact_anomaly
    WHERE source_dataset = 'attendance_monthly_features'
    GROUP BY TO_CHAR(period, 'YYYY-MM')
)
SELECT 
    m.year_month,
    m.month_name,
    m.year,
    m.active_employees,
    m.total_scheduled_days,
    m.total_present_days,
    m.total_wfh_days,
    m.attendance_rate_pct,
    m.total_late_arrivals,
    m.late_arrival_rate_pct,
    m.total_paid_leave_days,
    m.total_unpaid_absence_days,
    COALESCE(a.ai_anomaly_count, 0) AS ai_flagged_anomalies,
    COALESCE(a.avg_anomaly_score, 0.0) AS avg_anomaly_score,
    -- 3-Month Rolling Average Attendance Rate
    ROUND(
        AVG(m.attendance_rate_pct) OVER(
            ORDER BY m.year_month 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS rolling_3m_attendance_rate_pct,
    -- Month-over-Month (MoM) Attendance Rate Delta
    ROUND(
        m.attendance_rate_pct - LAG(m.attendance_rate_pct, 1) OVER(ORDER BY m.year_month), 
        2
    ) AS mom_attendance_rate_change_pct
FROM monthly_metrics m
LEFT JOIN monthly_anomalies a ON m.year_month = a.year_month
ORDER BY m.year_month ASC;
