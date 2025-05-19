select
  savings.plan_id,
  plan.owner_id,
  case
    when is_regular_savings = 1 then "Savings"
    when is_a_fund = 1 then "Investment"
  end as type,
  savings.last_transaction_date,
  savings.inactivity_days
from
  plans_plan as plan
  join (
    select
      distinct(owner_id),
      plan_id,
      max(transaction_date) as last_transaction_date,
      datediff(
        DATE_SUB(CURDATE(), INTERVAL 365 DAY),
        max(transaction_date)
      ) as inactivity_days
    from
      savings_savingsaccount -- from plans_plan
    where
      transaction_date <= DATE_SUB(CURDATE(), INTERVAL 365 DAY) -- where is_active = 1
    group by
      owner_id,
      plan_id -- order by owner_id desc
  ) as savings on plan.id = savings.plan_id
where
  (
    plan.is_regular_savings != 0
    or plan.is_a_fund != 0
  )
order by
  savings.last_transaction_date