SELECT
    s.id AS plan_id,
    s.owner_id,
    'Savings' AS type,
    MAX(s.created_on) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, MAX(s.created_on)) AS inactivity_days
FROM savings_savingsaccount s
GROUP BY s.id, s.owner_id
HAVING MAX(s.created_on) < CURRENT_DATE - INTERVAL 365 DAY

UNION ALL

-- Inactive Investment Plans
SELECT
    p.id AS plan_id,
    p.owner_id,
    'Investment' AS type,
    MAX(p.created_on) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE, MAX(p.created_on)) AS inactivity_days
FROM plans_plan p
WHERE p.is_a_fund = 1
GROUP BY p.id, p.owner_id
HAVING MAX(p.created_on) < CURRENT_DATE - INTERVAL 365 DAY

ORDER BY inactivity_days DESC;