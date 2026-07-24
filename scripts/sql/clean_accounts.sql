/*
CREATED BY: Sophia Learnahan
CREATION DATE: 07/22/2026
DESCRIPTION: Investigate duplicate accountIDS and clean/transform account data.
TRANSFORMATIONS:
	- Enforce structural integrity (define AccountID as Primary Key)
	- De-duplicate source records using DISTINCT
	- Standardize inconsistent date formats to (YYYY-MM-DD)
*/

PRAGMA table_info(accounts);

DROP VIEW IF EXISTS duplicate_accountID;
DROP TABLE IF EXISTS clean_accounts;

-- Check for duplicates
CREATE VIEW duplicate_accountID AS
	WITH 
		numbered_accounts AS (
		SELECT 
			*
			, COUNT(*) OVER(PARTITION BY accountID) AS IdCount
		FROM accounts
	)
	SELECT 
		*
	FROM 
		numbered_accounts
	WHERE 
		IdCount > 1
;

-- Investigate duplicates - duplicated across all columns?
SELECT 
	* 
FROM 
	duplicate_accountID;

-- Create empty table
CREATE TABLE clean_accounts (
	AccountID INT PRIMARY KEY
	, CustomerID INT
	, AccountTypeID INT
	, AccountStatusID INT
	, Balance REAL
	, OpeningDate TEXT
);

-- Apply cleaning/transformations
INSERT INTO clean_accounts
	SELECT DISTINCT
		AccountID
		, CustomerID
		, AccountTypeID
		, AccountStatusID
		-- Two decimals for conventional money formate
		, Balance
		-- Convert to YYYY-MM--DD 
		-- Time components are meaningless data noise with mostly 00:00:00.000000
		, DATE(OpeningDate) AS OpeningDate
	FROM accounts
;

-- Verify results
SELECT 
	* 
FROM 
	clean_accounts
LIMIT 
	15
;


		


