SELECT
  frequency_category,
  SUM(customer_count) AS total_customers,
  AVG(avg_transactions_per_month) AS average_of_averages
FROM
  (
    SELECT
      CASE
        WHEN AVG(transaction_count) >= 10 THEN "High Frequency"
        WHEN AVG(transaction_count) >= 3 THEN "Medium Frequency"
        ELSE "Low Frequency"
      END AS frequency_category,
      COUNT(DISTINCT user.id) AS customer_count,
      ROUND(AVG(transaction_count), 1) AS avg_transactions_per_month
    FROM
      users_customuser AS user
      JOIN (
        SELECT
          owner_id,
          DATE_FORMAT(transaction_date, '%Y-%m') AS yearmonth,
          COUNT(*) AS transaction_count
        FROM
          savings_savingsaccount
        GROUP BY
          yearmonth,
          owner_id
      ) AS saving ON user.id = saving.owner_id
    GROUP BY
      saving.yearmonth
  ) AS monthly_data
GROUP BY
  frequency_category
ORDER BY
  frequency_category;