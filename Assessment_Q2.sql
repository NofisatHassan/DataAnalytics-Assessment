WITH customer_tx_summary AS (
    SELECT
        s.owner_id,
        MIN(s.created_on) AS first_tx,
        MAX(s.created_on) AS last_tx,
        COUNT(*) AS total_transactions
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),
with_months AS (
    SELECT
        c.owner_id,
        GREATEST(
            PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM c.last_tx), EXTRACT(YEAR_MONTH FROM c.first_tx)) + 1,
            1
        ) AS active_months,
        c.total_transactions
    FROM customer_tx_summary c
),
categorized AS (
    SELECT
        w.owner_id,
        w.total_transactions,
        w.active_months,
        ROUND(w.total_transactions * 1.0 / w.active_months, 1) AS avg_tx_per_month,
        CASE
            WHEN w.total_transactions * 1.0 / w.active_months >= 10 THEN 'High Frequency'
            WHEN w.total_transactions * 1.0 / w.active_months >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM with_months w
)

SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
FROM categorized
GROUP BY frequency_category
ORDER BY
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;