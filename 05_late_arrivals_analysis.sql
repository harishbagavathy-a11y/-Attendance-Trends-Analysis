-- ============================================================================
-- Query 05: Late Arrivals Analysis by Month and Department
-- Purpose: Monitor punctuality, identify acute spikes (March 2026 / October 2025),
--          and spotlight departments with excessive lateness (Operations & IT).
-- ============================================================================

WITH monthly_lateness AS (
    SELECT 
        d.year_month,
        SUM(a.present_days) AS total_present_days,
        SUM(a.late_arrivals) AS total_late_arrivals,
        ROUND(
            SUM(a.late_arrivals)::NUMERIC / 
            NULLIF(SUM(a.present_days), 0) * 100, 
            2
        ) AS late_arrival_rate_pct
    FROM fact_attendance_monthly a
    JOIN dim_date d ON a.date_key = d.date_key
    GROUP BY d.year_month
),
dept_lateness AS (
    SELECT 
        dep.department_id,
        dep.department_name,
        SUM(a.present_days) AS dept_present_days,
        SUM(a.late_arrivals) AS dept_late_arrivals,
        ROUND(
            SUM(a.late_arrivals)::NUMERIC / 
            NULLIF(SUM(a.present_days), 0) * 100, 
            2
        ) AS dept_late_rate_pct
    FROM fact_attendance_monthly a
    JOIN dim_department dep ON a.department_id = dep.department_id
    GROUP BY dep.department_id, dep.department_name
)
-- Display Department Lateness Ranking
SELECT 
    department_id,
    department_name,
    dept_present_days,
    dept_late_arrivals,
    dept_late_rate_pct,
    DENSE_RANK() OVER(ORDER BY dept_late_rate_pct DESC) AS lateness_rank
FROM dept_lateness
ORDER BY dept_late_rate_pct DESC;
