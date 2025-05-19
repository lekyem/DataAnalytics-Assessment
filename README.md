# DataAnalytics-Assessment
**QUESTION 1**
To identify customers who have engaged in both regular savings and investment plans, I developed a query that aggregates plan ownership and confirmed deposits at the customer level. The objective was to pinpoint customers based on the types of plans they own and their total confirmed deposit amounts, which is valuable for segmentation and identifying high-value clients.

**Approach:**
I began by joining the plans_plan and savings_savingsaccount tables to retrieve all plans associated with successful, non-zero transactions. The subquery filters for plans where either is_regular_savings or is_a_fund is marked as true (non-zero), which indicates that the plan qualifies as either a savings or investment plan.
Within that subquery, I grouped transactions by plan_id and owner_id, and summed the confirmed_amount where transaction_status = 'success', ensuring that only funded plans were considered.
This result was then joined with the users_customuser table to connect the plan data to individual customers. For each customer, the query returns:
The count of savings plans (is_regular_savings)
The count of investment plans (is_a_fund)
The total confirmed deposit amount
The customer's full name using CONCAT
The final output is grouped by customer and sorted in descending order of total_deposits to highlight top contributors.

**Challenges Faced:**
A key challenge in this task was the lack of clarity on whether the query should focus on active or inactive plans. Since the question did not specify, I chose to include all plans with successful transaction records, regardless of whether they are currently active or closed. This ensured no valuable customer data was overlooked.
Additionally, care was taken to avoid double-counting in cases where a plan might qualify as both a savings and an investment product. I used SUM aggregation instead of COUNT to maintain data integrity and accurately reflect the customer’s engagement.
This method provided a comprehensive view of customer participation across both product types and supports further analysis such as customer profiling, loyalty segmentation, and cross-sell opportunity identification.

**QUESTION 2**
To answer the frequency analysis question, I developed a query to calculate the average number of transactions per customer per month and segment customers based on their transaction activity. The core objective was to categorize customers into High, Medium, or Low frequency users and return the total number of customers in each group along with their average monthly transaction volume.
Given that the question did not specify a particular time frame or definition of frequency, one of the key challenges was determining an appropriate analysis period. To address this, I grouped transactions by customer and month, using the DATE_FORMAT(transaction_date, '%Y-%m') function to normalize the dates into monthly buckets.
The query first calculates the monthly transaction count for each customer and groups it by user and month. Then, it determines the average number of transactions per month for each customer across all available months. Based on this average, customers are assigned a frequency category using a CASE statement. The final output aggregates the data to show the total number of customers in each category and the average of their average monthly transactions.
This approach allowed me to provide a structured view of customer engagement through transaction behavior, which can be extremely valuable for segmentation, targeted campaigns, and understanding usage patterns.

**QUESTION 3**
To identify inactive plans—those with no transactions in the last 365 days—I developed a query that analyzes transaction history across both savings and investment plans. The goal was to detect dormant customer accounts that may require reactivation efforts or targeted engagement strategies.

**Approach:**
I started by creating a subquery from the savings_savingsaccount table to calculate, for each customer and plan:
The last transaction date (MAX(transaction_date))
The number of inactivity days, calculated as the difference between the cutoff date (current date minus 365 days) and the last transaction date.
This subquery filtered for transactions that occurred on or before 365 days ago, ensuring that only potentially dormant plans were evaluated.
I then joined this data with the plans_plan table to retrieve plan details and used a CASE statement to classify each plan as either a Savings or Investment type based on the flags is_regular_savings and is_a_fund.
Finally, the results were ordered by last_transaction_date, making it easier to prioritize the most outdated plans.

**Challenges Faced:**
One notable challenge was the absence of an “active” status flag in the question requirements. While it referenced inactivity, it did not specify whether only active plans should be considered. To be comprehensive, I focused on transaction behavior as the basis for inactivity, rather than relying on a potentially ambiguous status flag.
Additionally, I had to ensure that the classification of plans into savings or investment types was handled properly. Since a plan could technically have both flags set, I used a CASE structure to assign a category based on which flag is active, although this could be enhanced further with prioritization logic or dual-tagging if needed.
This query provides actionable insights into dormant customer plans, which can inform re-engagement campaigns or risk monitoring for customer churn.

**QUESTION 4**
To estimate Customer Lifetime Value (CLV), I developed a query that combines transaction data and customer tenure to produce an annualized profitability estimate for each user. This metric provides insight into how much revenue a customer is expected to generate over their engagement with the platform and can be valuable for segmentation, retention strategies, and resource allocation.

**Approach:**
I began by calculating the customer tenure in months using the PERIOD_DIFF function, which measures the difference between the current date and the date_joined field from the users_customuser table.
Next, in a subquery, I analyzed the savings_savingsaccount table to:
Count the total number of successful transactions per customer.
Estimate the average profit per transaction, assuming a fixed profit margin of 0.1% on each confirmed_amount.
Using these values, I calculated the estimated CLV with the following logic:
(Total Transactions / Tenure in Months) × 12 × Avg Profit per Transaction
This formula annualizes the customer’s transaction behavior to estimate their yearly contribution to revenue.
The query returns:
User ID and full name
Tenure in months
Total number of successful transactions
Estimated annual CLV (rounded to 2 decimal places)
The results are sorted by user ID to keep the output organized.

**Challenges Faced:**
A key challenge in this task was the lack of a predefined profit margin or CLV formula. To proceed, I made a reasonable business assumption of 0.1% profit per confirmed transaction amount. This allowed me to simulate a simple yet practical profit model.
Another ambiguity was how to define “lifetime”—whether it should be projected across multiple years or calculated annually. I opted for an annualized CLV to standardize comparisons and ensure that newer customers weren't penalized for shorter engagement periods.
Overall, this approach provides a solid baseline for estimating CLV, which can later be refined with more detailed cost and revenue inputs if available.
