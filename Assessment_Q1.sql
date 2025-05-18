USE adashi_staging;
WITH Savings AS (
    SELECT 
        pp.owner_id,
        COUNT(DISTINCT pp.id) AS savings_count, 
        SUM(sa.confirmed_amount) AS savings_deposits
    FROM plans_plan pp
    JOIN savings_savingsaccount sa ON pp.id = sa.plan_id
    WHERE pp.is_regular_savings = 1 
      AND sa.confirmed_amount > 0 
    GROUP BY pp.owner_id
),
Investments AS (
    SELECT 
        pp.owner_id,
        COUNT(DISTINCT pp.id) AS investment_count,
        SUM(sa.confirmed_amount) AS investment_deposits
    FROM plans_plan pp
    JOIN savings_savingsaccount sa ON pp.id = sa.plan_id
    WHERE pp.is_a_fund = 1 
      AND sa.confirmed_amount > 0 
    GROUP BY pp.owner_id
)
SELECT
    u.id AS owner_id,
    concat(first_name, ' ', last_name) as full_name,
    sp.savings_count,
    ip.investment_count,
    (sp.savings_deposits + ip.investment_deposits) / 100 AS total_deposits 
FROM users_customuser u
JOIN Savings sp ON u.id = sp.owner_id
JOIN Investments ip ON u.id = ip.owner_id
ORDER BY total_deposits DESC;