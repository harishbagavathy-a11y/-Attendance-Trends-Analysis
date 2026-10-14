-- ============================================================================
-- Query 03: Leave Patterns by Weekday (Monday through Friday)
-- Purpose: Uncover weekly seasonality in leave requests and working-day leave volume,
--          testing for weekend-bridging behavior (Friday/Monday spikes).
-- ============================================================================

WITH leave_starts AS (
    SELECT 
        TO_CHAR(start_date, 'Day') AS weekday_name,
        EXTRACT(ISODOW FROM start_date) AS iso_weekday,
        COUNT(*) AS leave_requests_started,
        SUM(days) AS total_leave_days_scheduled
    FROM fact_leave
    WHERE status = 'Approved'
    GROUP BY TO_CHAR(start_date, 'Day'), EXTRACT(ISODOW FROM start_date)
),
leave_applied AS (
    SELECT 
        TO_CHAR(applied_on, 'Day') AS weekday_name,
        EXTRACT(ISODOW FROM applied_on) AS iso_weekday,
        COUNT(*) AS leave_requests_submitted
    FROM fact_leave
    GROUP BY TO_CHAR(applied_on, 'Day'), EXTRACT(ISODOW FROM applied_on)
)
SELECT 
    CASE s.iso_weekday
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        ELSE 'Weekend'
    END AS day_of_week,
    s.leave_requests_started,
    ROUND(
        s.leave_requests_started::NUMERIC / 
        SUM(s.leave_requests_started) OVER() * 100, 
        2
    ) AS pct_of_started_leaves,
    s.total_leave_days_scheduled,
    a.leave_requests_submitted,
    ROUND(
        a.leave_requests_submitted::NUMERIC / 
        SUM(a.leave_requests_submitted) OVER() * 100, 
        2
    ) AS pct_of_submitted_leaves
FROM leave_starts s
JOIN leave_applied a ON s.iso_weekday = a.iso_weekday
WHERE s.iso_weekday BETWEEN 1 AND 5
ORDER BY s.iso_weekday ASC;
