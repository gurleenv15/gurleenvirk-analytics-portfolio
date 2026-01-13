# Stablecoin Ecosystem Dashboard (USDT)

## Dashboard
🔗 https://dune.com/gvirk2/mini-project-2-g7

## Business Context
A growth analyst at a payments processor is evaluating whether USDT can be integrated as a scalable and reliable payment rail.

## Key Questions
1. Is USDT transaction volume growing at a meaningful rate?
2. Is adoption broad-based or driven by a small number of wallets?
3. Are transfers primarily retail-sized or institutional?
4. Is growth driven by new users or returning users?
5. Is volume growth associated with peg instability?

## Data
- Blockchain: Ethereum
- Stablecoin: USDT (Tether)
- Tables: erc20_ethereum.evt_Transfer, prices.usd
- Time horizon: 2023–2025
- Scale: Millions of on-chain transactions

## Methods
- SQL-based aggregation and window functions
- Weekly cohort analysis (new vs returning wallets)
- Transaction size bucketing
- Peg stability analysis using weekly average price

## Key Findings
- Transaction volume and active wallets are both increasing structurally.
- The majority of transfers are under $1k, consistent with everyday payments and remittances.
- Returning wallets dominate activity, but new wallets show strong repeat usage.
- Volume growth occurred without peg instability, indicating payment-driven demand.

## Deliverables
- SQL queries (`/sql`)
- Interactive Dune dashboard
- Visualizations (`/visuals`)
- Executive insights and recommendations (`/docs`)



