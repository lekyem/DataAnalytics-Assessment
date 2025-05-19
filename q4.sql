select
  user.id,
  concat(user.first_name, ' ', user.last_name) as name,
  PERIOD_DIFF(
    DATE_FORMAT(CURDATE(), '%Y%m'),
    DATE_FORMAT(user.date_joined, '%Y%m')
  ) as tenure_months,
  savings.total_transactions,
  round(
    (
      savings.total_transactions / PERIOD_DIFF(
        DATE_FORMAT(CURDATE(), '%Y%m'),
        DATE_FORMAT(user.date_joined, '%Y%m')
      ) * 12 * savings.avg_profit_per_transaction
    ),
    2
  ) as estimated_clv
from
  users_customuser as user
  join (
    select
      distinct(owner_id),
      count(*) as total_transactions,
      avg(confirmed_amount * 0.001) as avg_profit_per_transaction
    from
      savings_savingsaccount
    where
      transaction_status = 'success'
    group by
      owner_id
  ) as savings on user.id = savings.owner_id
group by
  user.id,
  name,
  tenure_months,
  savings.total_transactions
ORDER BY
  user.id;