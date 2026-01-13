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
-- Q4: USDT New vs Returning Wallet Analysis (2023–2025)
-- Question: Are we seeing new users adopt USDT over time, or is growth mainly from returning
wallets?
-- Approach:
-- 1) For each wallet, find the first week it ever used USDT (across all history).
-- 2) For each week from 2023 onward, list all active wallets.
-- 3) Label each weekly wallet as 'New' if it is active in its first week, otherwise 'Returning'.

WITH wallet_first_usage AS (
    -- Find the absolute first time each wallet used USDT (scans all history to correctly identify 'Returning' wallets)
    SELECT 
        address,
        MIN(DATE_TRUNC('week', evt_block_time)) AS first_week
    FROM (
        SELECT "from" AS address, evt_block_time
        FROM erc20_ethereum.evt_Transfer
        WHERE contract_address = 0xdac17f958d2ee523a2206206994597c13d831ec7
        
        UNION ALL
        
        SELECT "to" AS address, evt_block_time
        FROM erc20_ethereum.evt_Transfer
        WHERE contract_address = 0xdac17f958d2ee523a2206206994597c13d831ec7
    ) all_addresses
    WHERE address != 0x0000000000000000000000000000000000000000 -- Exclude zero address
    GROUP BY address
),

weekly_activity AS (
    -- Get all wallet activity by week, specifically starting from 2023-01-01
    SELECT DISTINCT
        DATE_TRUNC('week', evt_block_time) AS week,
        address
    FROM (
        SELECT "from" AS address, evt_block_time
        FROM erc20_ethereum.evt_Transfer
        WHERE contract_address = 0xdac17f958d2ee523a2206206994597c13d831ec7
          -- *** MODIFIED START DATE FILTER (2023-01-01) ***
          AND evt_block_time >= DATE '2023-01-01'
        
        UNION
        
        SELECT "to" AS address, evt_block_time
        FROM erc20_ethereum.evt_Transfer
        WHERE contract_address = 0xdac17f958d2ee523a2206206994597c13d831ec7
          -- *** MODIFIED START DATE FILTER (2023-01-01) ***
          AND evt_block_time >= DATE '2023-01-01'
    ) all_addresses
    WHERE address != 0x0000000000000000000000000000000000000000
)

SELECT 
    wa.week,
    CASE 
        WHEN wa.week = wfu.first_week THEN 'New Wallet'
        ELSE 'Returning Wallet'
    END AS wallet_type,
    COUNT(DISTINCT wa.address) AS wallet_count
FROM weekly_activity wa
INNER JOIN wallet_first_usage wfu 
    ON wa.address = wfu.address
GROUP BY 1, 2
ORDER BY 1 ASC, 2

