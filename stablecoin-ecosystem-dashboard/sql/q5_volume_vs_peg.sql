-- =====================================================
-- Business Question:
-- Is USDT transaction volume growing at a rate that
-- supports its use as a scalable payment rail?
--
-- Description:
-- Aggregates weekly USDT transfer volume on Ethereum
-- and converts on-chain values to USD using weekly
-- average prices.
--
-- Data:
-- erc20_ethereum.evt_Transfer
-- prices.usd
-- =====================================================

-- Q5: Weekly USDT volume vs peg stability
-- Question: Is usage driven by stable, ongoing demand or by crypto market stress events?
-- Approach:
-- 1) Aggregate USDT transfers per week in token units.
-- 2) Compute the weekly average USDT price in USD.
-- 3) Convert weekly token volume to USD and compare it.

WITH raw_transfers AS (
  SELECT
    date_trunc('week', t.evt_block_time) AS week,
    t.value / 1e6 AS amount_usdt
  FROM erc20_ethereum.evt_Transfer AS t
  WHERE t.contract_address = 0xdac17f958d2ee523a2206206994597c13d831ec7
    AND t.evt_block_time >= now() - interval '2' year
),
weekly_price AS (
  SELECT
    date_trunc('week', p.minute) AS week,
    AVG(p.price) AS avg_weekly_price
  FROM prices.usd AS p
  WHERE p.blockchain = 'ethereum'
    AND p.symbol = 'USDT'
    AND p.minute >= now() - interval '2' year
  GROUP BY 1
),
weekly_volume AS (
  SELECT
    r.week,
    SUM(r.amount_usdt) AS total_usdt
  FROM raw_transfers AS r
  GROUP BY r.week
)

SELECT
  v.week,
  v.total_usdt * wp.avg_weekly_price AS weekly_volume_usd,
  wp.avg_weekly_price,
  (wp.avg_weekly_price - 1.0) AS price_deviation_from_peg
FROM weekly_volume AS v
LEFT JOIN weekly_price AS wp
  ON v.week = wp.week
ORDER BY v.week;
