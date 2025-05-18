## Data Analytics SQL Assessment

This repository contains solutions to four SQL challenges focused on customer behavior and transaction analysis. Each solution includes a single SQL file and is explained below with an overview of the approach and any challenges encountered.


### Question 1: High-Value Customers with Multiple Products

Objective:
Identify customers who have both a funded savings plan and a funded investment plan, and sort them by total deposits.

Approach:
I used the plans_plan table to filter for customers with:

 • At least one is_regular_savings = 1 plan
 
 • At least one is_a_fund = 1 plan

Total deposits were calculated using confirmed_amount from the savings_savingsaccount table, converted from kobo to naira. I joined these with the users_customuser table and filtered out customers with NULL names.

Challenge:
Originally, I attempted to filter using is_regular_savings in the wrong table, and also had to confirm where confirmed_amount was located.


### Question 2: Transaction Frequency Analysis

Objective:
Categorize customers into “High”, “Medium”, or “Low Frequency” based on average number of transactions per month.

Approach:
Each row in savings_savingsaccount was treated as a transaction. I used:

 • MIN(created_on) and MAX(created_on) to determine activity span
 
 • PERIOD_DIFF() to calculate months of activity
 
 • Average transactions per month = total_transactions / active_months

Categories were then assigned using a CASE statement.

Challenge:
Initially used a non-existent created_at field. Fixed it by switching to the actual created_on field after schema inspection.


### Question 3: Account Inactivity Alert

Objective:
Find accounts (savings or investments) with no inflow transactions in the last 365 days.

Approach:
For:

 • Savings, I used savings_savingsaccount and grouped by account to find the latest created_on
 
 • Investments, I filtered plans_plan where is_a_fund = 1

Accounts with no transactions within the last 365 days were selected using a HAVING clause, and results were labeled as “Savings” or “Investment” with a UNION ALL.

Challenge:
Originally assumed a shared inflow source but separated logic after identifying independent sources for savings and investment.


### Question 4: Customer Lifetime Value (CLV) Estimation

Objective:
Estimate CLV for each customer using transaction volume and account tenure.

Approach:
I calculated:

 • tenure_months using PERIOD_DIFF() on date_joined
 
 • Total and average transaction values from savings_savingsaccount
 
 • CLV using the formula:
 
(total_transactions / tenure_months) * 12 * (avg_transaction_value * 0.001)

Names were handled using COALESCE(name, CONCAT(first_name, ' ', last_name)) for completeness.

Challenge:
An error occurred from referencing a missing alias in an unnecessary join. The logic was simplified and corrected to use only needed fields.
