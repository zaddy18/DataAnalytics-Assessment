USE adashi_staging;
WITH customer_transactions AS (
    SELECT 
      distinct  cu.id AS customer_id,
        concat(first_name, ' ', last_name) as full_name,
        cu.created_on AS signup_date,
        TIMESTAMPDIFF(MONTH, cu.created_on, CURRENT_DATE()) AS tenure,
        COUNT(sa.id) AS total_transactions,
        SUM(sa.confirmed_amount) AS total_amount
    FROM 
        users_customuser cu
    JOIN 
        plans_plan p ON cu.id = p.owner_id
    JOIN 
        savings_savingsaccount sa ON p.id = sa.plan_id
    WHERE 
        sa.confirmed_amount > 0
    GROUP BY 
        cu.id, cu.name, cu.created_on
    HAVING 
        TIMESTAMPDIFF(MONTH, cu.created_on, CURRENT_DATE()) > 0
)
SELECT 
    customer_id,
    full_name,
    tenure,
    total_transactions,
    ROUND(
        (total_transactions / tenure) * 12 * 
        (((total_amount/100)* 0.001) / (total_transactions)), 
        2
    ) AS estimated_clv
FROM 
    customer_transactions
ORDER BY 
    estimated_clv DESC;