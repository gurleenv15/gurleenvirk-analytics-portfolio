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

-- Q2: Weekly active USDT wallets (senders + receivers), last 2 years
--Question: Is the user base expanding, or is a small group driving all volume?
-- Approach:
-- 1) Collect all addresses that either send or receive USDT each week.
-- 2) Count distinct wallets per week to measure weekly active wallets.

WITH usdt_addresses AS (
  -- All senders
  SELECT
    date_trunc('week', t.evt_block_time) AS week,
    t."from" AS wallet
  FROM erc20_ethereum.evt_Transfer AS t
  WHERE t.contract_address = 0xdac17f958d2ee523a2206206994597c13d831ec7
    AND t.evt_block_time >= now() - interval '2' year

  UNION ALL

  -- All receivers
  SELECT
    date_trunc('week', t.evt_block_time) AS week,
    t."to" AS wallet
  FROM erc20_ethereum.evt_Transfer AS t
  WHERE t.contract_address = 0xdac17f958d2ee523a2206206994597c13d831ec7
    AND t.evt_block_time >= now() - interval '2' year
)

SELECT
  week,
  COUNT(DISTINCT wallet) AS active_wallets
FROM usdt_addresses
GROUP BY week
ORDER BY week;
