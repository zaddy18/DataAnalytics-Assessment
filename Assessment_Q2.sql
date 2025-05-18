USE adashi_staging;
WITH monthly_transactions AS (
    SELECT 
        cu.id AS customer_id,
        EXTRACT(YEAR FROM sa.created_on) AS year,
        EXTRACT(MONTH FROM sa.created_on) AS month,
        COUNT(sa.id) AS transaction_count AS transaction_count
    FROM 
        users_customuser cu
    JOIN 
        plans_plan p ON cu.id = p.owner_id
    JOIN 
        savings_savingsaccount sa ON p.id = sa.plan_id
    GROUP BY 
        cu.id, EXTRACT(YEAR FROM sa.created_on), EXTRACT(MONTH FROM sa.created_on)
),
customer_frequency AS (
    SELECT 
        customer_id,
        AVG(transaction_count) AS avg_transactions_per_month,
        CASE 
            WHEN AVG(transaction_count) >= 10 THEN 'High Frequency'
            WHEN AVG(transaction_count) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM 
        monthly_transactions
    GROUP BY 
        customer_id
)
SELECT 
    frequency_category,
    COUNT(customer_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM 
    customer_frequency
GROUP BY 
    frequency_category;