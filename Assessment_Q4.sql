WITH transaction_stats AS (
    SELECT
        s.owner_id,
        COUNT(*) AS total_transactions,
        SUM(s.confirmed_amount) / 100.0 AS total_value_naira,
        AVG(s.confirmed_amount) / 100.0 AS avg_transaction_value
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),
tenure AS (
    SELECT
        u.id AS customer_id,
        COALESCE(u.name, CONCAT(u.first_name, ' ', u.last_name)) AS name,
        GREATEST(
            PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM CURRENT_DATE), EXTRACT(YEAR_MONTH FROM u.date_joined)),
            1
        ) AS tenure_months
    FROM users_customuser u
),
clv_calc AS (
    SELECT
        tn.customer_id,
        tn.name,
        tn.tenure_months,
        tx.total_transactions,
        ROUND(
            (tx.total_transactions * 1.0 / tn.tenure_months) * 12 * (tx.avg_transaction_value * 0.001),
            2
        ) AS estimated_clv
    FROM tenure tn
    JOIN transaction_stats tx ON tx.owner_id = tn.customer_id
)

SELECT
    customer_id,
    name,
    tenure_months,
    total_transactions,
    estimated_clv
FROM clv_calc
ORDER BY estimated_clv DESC;