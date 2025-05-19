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
