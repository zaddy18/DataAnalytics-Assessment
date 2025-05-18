# DataAnalytics-Assessment

## Approach & Challenges

### **Question 1: High-Value Customers with Multiple Products**

**Approach**  
To identify customers with both savings and investment products, I broke down the problem into different parts using Common Table Expressions (CTEs):

#### Savings CTE

First, I created a "Savings" CTE that:

- Joins the plans table with the savings account table.
- Filters for only regular savings plans (using `is_regular_savings = 1`) with deposits higher than `0`.
- Counts how many savings plans each customer has.
- Sums up their total savings deposits.
- Groups everything by customer ID.

#### Investments CTE

Next, I created an "Investments" CTE that follows the same pattern but:

- Filters for investment funds instead (using `is_a_fund = 1`) to follow the question directive.
- Counts investment plans and sums investment deposits.

#### Main Query

In the main query, I:

- Joined the user table with both CTEs using the owner ID.
- Combined first and last names to create a full name.
- Calculated total deposits by adding savings and investment deposits.
- Converted from kobo to the main currency by dividing by 100.
- Sorted by total deposits to show highest-value customers first (`DESC`).

The `INNER JOINs` ensure we only get customers who have both product types, which meets the cross-selling opportunity criteria.

**Challenges**  
- I initially counted transactions instead of plans. Fixed with `COUNT(DISTINCT pp.id)`.
- Currency conversion - The amounts were stored in kobo, so I needed to divide by 100 to get the Naira currency.

---

### **Question 2: Transaction Frequency Analysis**
**Approach**  
- First, counted how many transactions each customer makes per month.
- Then, calculated the average monthly transactions for each customer.
- Grouped customers into three categories using the `CASE` function.
- Finally, I count how many customers are in each category and their average transaction frequency.


**Challenges**  
- The main challenge was correctly grouping by month and year. I needed to use `EXTRACT` to get these components from the transaction dates. 
- Another challenge was ensuring the categories were ordered correctly in the final output, which I solved using a `CASE` statement in the `ORDER BY` clause.

---

### **Question 3: Account Inactivity Alert**
**Approach**  
- I joined three tables to get all the information needed: plans, savings accounts, and users.
- I used a CASE statement to label each plan as either "Savings" or "Investment" for clarity.
- For each plan, I found the most recent transaction date using `MAX()`.
- I calculated how many days have passed since that last transaction.
- I filtered to only show active user accounts.
- Finally, I used `HAVING` to show only plans with no activity for more than 365 days.

**Challenge**  
- The challenge was ensuring that i only included active accounts, which i addressed by adding a filter for `cu.is_active = 1` from the `users_customuser` table.

---

### **Question 4: Customer Lifetime Value (CLV) Estimation**
**Approach**  
I used a Common Table Expression (CTE) to first gather all the customer transaction data and calculate the metrics like tenure and transaction counts. In the CTE, I:

- Joined the users, plans, and savings account tables.
- Calculated the tenure in months for each customer.
- Counted their total transactions and summed the transaction amounts.
- Filtered out customers with zero tenure months.

Then in the main query, I applied the CLV formula using the data from the CTE:

- Monthly transaction rate = total_transactions / tenure_months.
- Annual transaction rate = monthly rate * 12.
- Average profit per transaction = 0.1% of average transaction value in Naira.
- CLV = annual transaction rate * average profit per transaction.

**Challenge**  
- My main challenge was correctly implementing the CLV formula while handling division errors. By using a CTE, I was able to make the query more readable. The CTE approach also allowed me to filter out customers with zero tenure months (new customers) before attempting the CLV calculation, preventing errors. Converting from kobo to Naira (dividing by 100) and calculating the profit margin (0.1% or 0.001) which was considered.
