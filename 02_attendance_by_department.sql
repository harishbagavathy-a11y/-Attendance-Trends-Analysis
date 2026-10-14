-- ============================================================================
-- Query 02: Department Attendance Ranking & Lateness Rate
-- Purpose: Contrast department-level attendance integrity across all 11 business units,
--          identifying highest and lowest attendance performers and late arrival patterns.
-- ============================================================================

SELECT 
    d.department_id,
    d.department_name,
    d.cost_center,
    COUNT(DISTINCT a.employee_id) AS active_headcount,
    COUNT(a.attendance_fact_id) AS total_employee_months,
    SUM(a.scheduled_days) AS total_scheduled_days,
    SUM(a.present_days) AS total_present_days,
    SUM(a.wfh_days) AS total_wfh_days,
    SUM(a.paid_leave_days) AS total_paid_leave_days,
    SUM(a.unpaid_absence_days) AS total_unpaid_absence_days,
    SUM(a.late_arrivals) AS total_late_arrivals,
    -- Attendance Rate (%)
    ROUND(
        (SUM(a.present_days) + 0.5 * SUM(a.half_days_unpaid))::NUMERIC / 
        NULLIF(SUM(a.scheduled_days), 0) * 100, 
        2
    ) AS attendance_rate_pct,
    -- Late Arrival Rate (%)
    ROUND(
        SUM(a.late_arrivals)::NUMERIC / 
        NULLIF(SUM(a.present_days), 0) * 100, 
        2
    ) AS late_arrival_rate_pct,
    -- WFH Utilization Rate (%)
    ROUND(
        SUM(a.wfh_days)::NUMERIC / 
        NULLIF(SUM(a.present_days), 0) * 100, 
        2
    ) AS wfh_share_pct,
    -- Average Hours Worked per Day
    ROUND(AVG(a.avg_hours_worked), 2) AS avg_hours_worked,
    -- Relative Rank
    DENSE_RANK() OVER(
        ORDER BY (SUM(a.present_days) + 0.5 * SUM(a.half_days_unpaid))::NUMERIC / NULLIF(SUM(a.scheduled_days), 0) DESC
    ) AS attendance_rank
FROM fact_attendance_monthly a
JOIN dim_department d ON a.department_id = d.department_id
GROUP BY d.department_id, d.department_name, d.cost_center
ORDER BY attendance_rate_pct DESC;
