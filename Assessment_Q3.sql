USE adashi_staging;
SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(sa.created_on) AS last_transaction_date,
    DATEDIFF(CURRENT_DATE(), MAX(sa.created_on)) AS inactivity_days
FROM
    plans_plan p
        JOIN
    savings_savingsaccount sa ON p.id = sa.plan_id
        JOIN
    users_customuser cu ON p.owner_id = cu.id
WHERE
    cu.is_active = 1
GROUP BY p.id , p.owner_id
HAVING inactivity_days > 365;