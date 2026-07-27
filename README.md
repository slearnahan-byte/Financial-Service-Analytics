# Financial-Service-Analytics
Tools: Power BI, SQL

## Overview

An end-to-end data engineering and analytics project transforming raw, uncleaned banking data into reporting-ready datasets and an interactive Power BI dashboard.

This project demonstrates a complete data analytics workflow:
- Relational data cleaning and validation
- Schema design and data transformation
- Entity aggregation and metric engineering
- Dashboard visualization and data modeling

## Key Insights
- **Total Portfolio:** 1.1K all-time total customers holding 1.65K all-time accounts, with an average of 1.92 accounts per customer.
  - 770 active customers holding 1.33K accounts.
  - Uniform distribution across account type.
  - 
- **Customer Demographics:** The average customer age is 46.35 years, with the largest concentration of customers falling in the 50–64 age group, followed by 35–49.
  
- **Balances:** The average customer portfolio balance (all accounts) stands at $94.01K, while the average individual account balance is $49.08K.

- **Adoption Rate:** An account adoption rate of 0.78 (against a target benchmark of 0.85).

- **Time Trends:** The number of new customers was greatest in 2018 but showed a steady decline through 2022. The number of new accounts regardless of type was stable from 2018 through 2022.
  - In 2018 and 2019, the largest account acquisitions occurred in Q3 and Q4, while in 2020 the largest account acquisition occurred in Q1 & Q3, and Q1 & Q2, respectively.

The focus is on enforcing data integrity, resolving data quality issues, and constructing analytical summaries for financial risk and customer activity.
---

## Project Workflow

### 01 — Data Cleaning & Validation
- Inspected table structures and data types across raw banking entities (customers, accounts, loans, transactions, addresses)
- Enforced structural integrity by defining primary keys across clean target tables.
- Identified and extracted duplicate records using SQL window functions (COUNT(*) OVER(PARTITION BY ...)) via dedicated investigation views


### 02 — Data Transformation & Standardization
- Standardized inconsistent date formats into standard ISO-8601 strings (YYYY-MM-DD) and removed timestamp noise.
- Cleaned string artifacts, fixed typos, and handled prefix/suffix corruption across 300+ transaction descriptions using pattern matching
- Engineered composite business keys (CustomerDisplayName) with defensive fallback logic (CASE / NULLIF) for missing name fields.
- Flagged and nullified chronologically invalid records (e.g., loan estimated end dates preceding start dates).
- Dynamically calculated customer age using date comparisons

### 03 — Aggregation & Summary Engineering
- Built aggregated summary datasets (accounts_summary, customer_summary) to track customer-level metrics.
- Calculated total accounts, combined account balances, and initial opening dates per customer.
- Applied COALESCE logic with LEFT JOIN operations to preserve complete visibility across all customer profiles, including those with zero balances.

### 04 — Dashboard & Visual Analytics
Designed and implemented an interactive Power BI dashboard (Finance Fraud & Loan Dashboard.pbix) for financial monitoring:

| View | Purpose |
|---|---|
| Customer & Account Overview | Visualizing dynamic customer demographics, account counts, age groups, and portfolio balances |


---
## Evaluation Strategy

Data validation focused on verifying transformation accuracy and data pipeline stability:

- Summary Verification — audited aggregated metrics and dashboard measures against base tables.
---

## Repository Structure

```text
Financial-Service-Analytics/
|
├── scripts/
│   ├── clean_customers.sql
│   ├── clean_accounts.sql
│   ├── clean_loans.sql
│   ├── clean_transactions.sql
│   ├── clean_addresses.sql
│   ├── account_summary.sql
│   └── customers_summary.sql
|
├── data/
├── Finance Fraud & Loan Dashboard.pbix
└── README.md
```
