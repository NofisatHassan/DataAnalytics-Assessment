WITH savings_plans AS (
    SELECT owner_id, COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = 1
    GROUP BY owner_id
),
investment_plans AS (
    SELECT owner_id, COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1
    GROUP BY owner_id
),
deposits AS (
    SELECT owner_id, SUM(confirmed_amount) / 100.0 AS total_deposits
    FROM savings_savingsaccount
    GROUP BY owner_id
)

SELECT
    u.id AS owner_id,
    COALESCE(u.name, CONCAT(u.first_name, ' ', u.last_name)) AS name,
    s.savings_count,
    i.investment_count,
    ROUND(d.total_deposits, 2) AS total_deposits
FROM users_customuser u
JOIN savings_plans s ON u.id = s.owner_id
JOIN investment_plans i ON u.id = i.owner_id
JOIN deposits d ON u.id = d.owner_id
ORDER BY total_deposits DESC;