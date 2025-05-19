select
  distinct(user.id) as owner_id,
  concat(user.first_name, ' ', user.last_name) as name,
  sum(plan.is_regular_savings) as savings_count,
  sum(is_a_fund) as investment_count,
  sum(plan.confirmed_amount) as total_deposits
from
  users_customuser user
  join (
    select
      distinct(p.owner_id) as owner_id,
      p.id,
      p.is_regular_savings,
      p.is_a_fund,
      s.confirmed_amount
    from
      plans_plan as p
      join (
        select
          distinct(plan_id),
          owner_id,
          sum(confirmed_amount) as confirmed_amount
        from
          savings_savingsaccount
        where
          confirmed_amount != 0
          and transaction_status = 'success'
        group by
          plan_id,
          owner_id
      ) as s on p.id = s.plan_id
    where
      (
        p.is_regular_savings != 0
        or p.is_a_fund != 0
      )
  ) as plan on user.id = plan.owner_id
group by
  owner_id
order by
  total_deposits desc