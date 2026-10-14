-- ============================================================================
-- Query 06: AI/ML Anomaly Sample Summary & Department Cross-Tabulation
-- Purpose: Join the AI team's sample anomaly predictions (attendance_monthly_features)
--          with employee dimensions, departments, and actual monthly attendance metrics.
-- ============================================================================

SELECT 
    anom.reason_code,
    anom.reason_text,
    COUNT(anom.result_id) AS flagged_anomaly_count,
    ROUND(AVG(anom.anomaly_score), 4) AS avg_anomaly_score,
    MIN(anom.anomaly_score) AS min_anomaly_score,
    MAX(anom.anomaly_score) AS max_anomaly_score,
    ROUND(
        COUNT(anom.result_id)::NUMERIC / 
        SUM(COUNT(anom.result_id)) OVER() * 100, 
        2
    ) AS pct_share_of_anomalies,
    COUNT(DISTINCT anom.employee_id) AS distinct_flagged_employees,
    ROUND(AVG(att.attendance_rate) * 100, 2) AS avg_actual_attendance_rate_pct,
    ROUND(AVG(att.present_days), 1) AS avg_actual_present_days,
    ROUND(AVG(att.unpaid_absence_days), 1) AS avg_actual_unpaid_absence_days
FROM fact_anomaly anom
LEFT JOIN fact_attendance_monthly att 
    ON anom.employee_id = att.employee_id 
   AND TO_CHAR(anom.period, 'YYYY-MM') = TO_CHAR(att.period_end_date, 'YYYY-MM')
WHERE anom.source_dataset = 'attendance_monthly_features'
GROUP BY anom.reason_code, anom.reason_text
ORDER BY flagged_anomaly_count DESC;
