# Financial-Service-Analytics
Tools: Power BI, SQL

## Overview

An end-to-end data engineering and analytics project transforming raw, uncleaned banking data into reporting-ready datasets and an interactive Power BI dashboard.

This project demonstrates a complete data analytics workflow:
- Relational data cleaning and validation
- Schema design and data transformation
- Entity aggregation and metric engineering
- Dashboard visualization and data modeling

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
| Customer & Account Overview | Interpretable baseline model |


---

## Evaluation Strategy

Because stroke outcomes are highly imbalanced, model evaluation focused on metrics beyond accuracy:

- **PR-AUC (Average Precision)** — primary optimization metric
- Recall
- Precision
- F1-score
- ROC-AUC
- Confusion matrices

Threshold optimization was performed to evaluate tradeoffs between detecting high-risk patients and limiting false positives.

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
