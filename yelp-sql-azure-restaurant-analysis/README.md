# Restaurant Location & Concept Analysis (Yelp Data, SQL, Azure)

## Overview
This project simulates a real-world analytics and data engineering case:
using large-scale Yelp data to inform where and what type of restaurant to open.

The analysis spans the full pipeline—from semi-structured data ingestion to
business-facing SQL insights—using Azure SQL Server as the backend.

## Business Question
Where should a new restaurant open, and what concept would maximize
competitive differentiation and customer demand?

## Approach
- Explored and documented large Yelp JSON datasets (businesses, reviews, users)
- Transformed semi-structured data into a normalized relational schema
- Built and populated an Azure SQL database with appropriate keys and constraints
- Designed SQL queries to support strategic decisions around:
  - market saturation
  - customer preferences
  - rating dynamics
  - geographic opportunity gaps

## Key Insights
- High-rated restaurants cluster unevenly across neighborhoods,
  revealing underserved areas with strong demand signals
- Certain cuisines show strong ratings but low density in target regions
- Customer sentiment and review volume jointly explain perceived success

## Tools
SQL, Azure SQL Database, Python (JSON ingestion), Pandas, Data Modeling

## Repo Guide
- `sql/` – schema, transformations, and business queries
- `notebook/` – exploratory data analysis and ingestion logic
