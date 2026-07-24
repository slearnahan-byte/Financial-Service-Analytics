/*
CREATED BY: Sophia Learnahan
CREATION DATE: 07/22/2026
DESCRIPTION: Investigate duplicate TransactionID and clean/transform transaction data.

TRANSFORMATIONS:
	- Enforce structural integrity (define TransactionID as Primary Key)
	- De-duplicate source records using DISTINCT
	- Create Date column in as YYYY-MM-DD using t.TransactionDate
	- Repair 300+ prefix typos (including leading numbers like 9raction) and strip trailing letter anomalies
*/

PRAGMA table_info(transactions);
 
DROP VIEW IF EXISTS duplicate_transactionID;
DROP VIEW IF EXISTS description_errors;
DROP TABLE IF EXISTS clean_transactions;

-- Check for duplicates
CREATE VIEW duplicate_transactionID AS
	WITH numbered_transactions AS (
		SELECT *,
			COUNT(*) OVER(PARTITION BY TransactionID) AS IdCount -- count entries for each unique TransactionID
		FROM transactions
	)
	SELECT *
	FROM numbered_transactions
	WHERE IDCount > 1 --extract duplicates
;

-- Investigate duplicates - duplicated across all columns?
SELECT * FROM duplicate_transactionID;

CREATE VIEW description_errors AS
	SELECT 
		TransactionID,
		Description
	FROM transactions
		WHERE Description NOT LIKE 'Transaction%'
;

SELECT * FROM description_errors;

-- Create empty table
CREATE TABLE clean_transactions (
    TransactionID INT PRIMARY KEY,
    AccountOriginID INT,
	AccountDestinationID INT,
	TransactionTypeID INT,
	Amount REAL,
	TransactionDate TEXT,
	TransactionDateTime TEXT,
	BranchID INT,
	Description TEXT
);

INSERT INTO clean_transactions
		SELECT DISTINCT 
			TransactionID,
			AccountOriginID,
			AccountDestinationID,
			TransactionTypeID,
			Amount,
			DATE(TransactionDate) AS TransactionDate,
			-- DateTime used to calculate time between transactions
			DATETIME(SUBSTR(TransactionDate, -7)) AS TransactionDateTime,
			BranchID,
			CASE
				-- comment 
				WHEN Description GLOB '*[0-9][0-9][0-9][0-9][0-9]*' 
					THEN 'Transaction '
						|| RTRIM(SUBSTR(Description, -5), 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
				WHEN Description GLOB '*[0-9][0-9][0-9][0-9]*' 
					THEN 'Transaction '
						|| RTRIM(SUBSTR(Description, -4), 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
				WHEN Description GLOB '*[0-9][0-9][0-9]*' 
					THEN 'Transaction '
						|| RTRIM(SUBSTR(Description, -3), 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
				WHEN Description GLOB '*[0-9][0-9]' 
					THEN 'Transaction '
						|| RTRIM(SUBSTR(Description, -2), 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
				WHEN Description GLOB '*[0-9]' 
					THEN 'Transaction '
						|| RTRIM(SUBSTR(Description, -1), 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
				
				ELSE NULL
			END AS Description
		FROM transactions
;

SELECT * FROM clean_transactions
	LIMIT 15;

				
					
	
	
