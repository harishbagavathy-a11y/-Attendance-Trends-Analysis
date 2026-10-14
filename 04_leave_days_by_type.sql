-- ============================================================================
-- Query 04: Leave Days and Requests by Leave Type and Approval Status
-- Purpose: Quantify consumption across statutory and discretionary leave categories
--          (EL, CL, SL, ML, BL, LOP), evaluating approval rates and utilization.
-- ============================================================================

SELECT 
    t.leave_type_code,
    t.leave_type_name,
    t.pay_type,
    t.annual_quota_days,
    COUNT(l.leave_request_id) AS total_requests_applied,
    SUM(l.days) AS total_days_applied,
    COUNT(CASE WHEN l.status = 'Approved' THEN 1 END) AS approved_requests,
    SUM(CASE WHEN l.status = 'Approved' THEN l.days ELSE 0 END) AS approved_days,
    COUNT(CASE WHEN l.status = 'Rejected' THEN 1 END) AS rejected_requests,
    SUM(CASE WHEN l.status = 'Rejected' THEN l.days ELSE 0 END) AS rejected_days,
    COUNT(CASE WHEN l.status = 'Pending' THEN 1 END) AS pending_requests,
    SUM(CASE WHEN l.status = 'Pending' THEN l.days ELSE 0 END) AS pending_days,
    COUNT(CASE WHEN l.status = 'Cancelled' THEN 1 END) AS cancelled_requests,
    SUM(CASE WHEN l.status = 'Cancelled' THEN l.days ELSE 0 END) AS cancelled_days,
    -- Approval Rate (%)
    ROUND(
        COUNT(CASE WHEN l.status = 'Approved' THEN 1 END)::NUMERIC / 
        NULLIF(COUNT(l.leave_request_id), 0) * 100, 
        1
    ) AS request_approval_rate_pct,
    -- Share of Total Approved Days (%)
    ROUND(
        SUM(CASE WHEN l.status = 'Approved' THEN l.days ELSE 0 END)::NUMERIC / 
        SUM(SUM(CASE WHEN l.status = 'Approved' THEN l.days ELSE 0 END)) OVER() * 100, 
        2
    ) AS share_of_approved_days_pct
FROM fact_leave l
JOIN dim_leave_type t ON l.leave_type_code = t.leave_type_code
GROUP BY t.leave_type_code, t.leave_type_name, t.pay_type, t.annual_quota_days
ORDER BY approved_days DESC;
