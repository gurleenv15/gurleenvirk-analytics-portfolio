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

-- Q1: Weekly USDT transfer volume (USD) on Ethereum, last 2 years
-- Question: Is USDT usage growing enough to justify integrating it as a payment rail?
-- Approach:
-- 1) Aggregate raw USDT transfers per week in token units.
-- 2) Join to weekly average USDT price in USD.
-- 3) Convert weekly token volume into USD volume.

WITH raw_transfers AS (
SELECT
date_trunc('week', t.evt_block_time) AS week, -- bucket each transfer into its week
t.value / 1e6 AS amount_usdt -- convert from 6-decimal on-chain units to whole USDT
FROM erc20_ethereum.evt_Transfer AS t
WHERE t.contract_address = 0xdac17f958d2ee523a2206206994597c13d831ec7 -- canonical USDT
contract on Ethereum
AND t.evt_block_time >= now() - interval '2' year -- restrict to last 2 years for recency
),

weekly_price AS (
SELECT
date_trunc('week', p.minute) AS week, -- align price data to the same weekly buckets
AVG(p.price) AS avg_weekly_price -- use weekly average price as a simple peg proxy
FROM prices.usd AS p
WHERE p.blockchain = 'ethereum'
AND p.symbol = 'USDT'
AND p.minute >= now() - interval '2' year
GROUP BY 1
)

SELECT
r.week,
-- multiply token volume by average weekly price to get total USD volume per week
SUM(r.amount_usdt * wp.avg_weekly_price) AS weekly_volume_usd
FROM raw_transfers AS r
LEFT JOIN weekly_price AS wp
ON r.week = wp.week -- join on the same weekly bucket
GROUP BY r.week
ORDER BY r.week
