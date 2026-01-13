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
-- Q3: Typical USDT transaction sizes (retail vs institutional)
-- Question: Are USDT transfers mostly small (retail) or large (institutional)?
-- Approach:
-- 1) Convert transfer values from on-chain units into whole USDT.
-- 2) Bucket transactions into size ranges (e.g., <$1k, $1k–$100k, etc.).
-- 3) Compute both the count and share of total transactions per bucket.

SELECT 
CASE WHEN value/1e6 < 1000 THEN '<$1k' 
WHEN value/1e6 < 100000 THEN '$1k–$100k' 
WHEN value/1e6 < 1000000 THEN '$100k–$1M' 
ELSE '>$1M' END AS size_bucket, 
COUNT(*) AS tx_count, COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS pct_of_txs 
FROM erc20_ethereum.evt_Transfer 
WHERE contract_address = 0xdac17f958d2ee523a2206206994597c13d831ec7 
GROUP BY 1 ORDER BY tx_count DESC
