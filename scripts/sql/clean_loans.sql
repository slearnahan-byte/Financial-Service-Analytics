/*
CREATED BY: Sophia Learnahan
CREATION DATE: 07/22/2026
DESCRIPTION: Investigate duplicate loanIDS and clean/transform loan data.
TRANSFORMATIONS:
	- Enforce structural integrity (define LoanID as Primary Key)
	- De-duplicate source records using DISTINCT
	- Standardize finanancial balances to 2 decimal places 
	- Standardize inconsistent date formats to (YYYY-MM-DD)
	- Flag and nullify chronologically invalid dates (where EstimatedEndDate is before StartDate)
*/

PRAGMA table_info(loans);

DROP VIEW IF EXISTS duplicate_loanID;
DROP VIEW IF EXISTS error_est_end_date;
DROP TABLE IF EXISTS clean_loans;

-- Check for duplicates
CREATE VIEW duplicate_loanID AS 
	WITH 
		numbered_loans AS (
		SELECT 
			*
			, COUNT(*) OVER(PARTITION BY LoanID) AS IdCount 
		FROM loans
	)
	SELECT 
		* 
	FROM 
		numbered_loans
	WHERE 
		IdCount > 1
;

-- Investigate duplicate - duplicated across all columns?
SELECT 
	* 
FROM 
	duplicate_loanID;

-- Check for data entry errors where EstimatedEndDate is before StartDate
CREATE VIEW error_est_end_date AS
	SELECT 
		*
	FROM 
		loans
	WHERE 
		DATE(EstimatedEndDAte) < Date(StartDate)
;

SELECT 
	* 
FROM 
	error_est_end_date;

CREATE TABLE clean_loans (
	LoanID INT PRIMARY KEY
	, AccountID INT
	, LoanStatusID INT
	, PrincipalAmount REAL
	, InterestRate REAL
	, StartDate TEXT
	, EstimatedEndDate TEXT
);

INSERT INTO clean_loans
	SELECT DISTINCT
		LoanID
		, AccountID
		, LoanStatusID
		, PrincipalAmount
		, InterestRate
		, DATE(StartDate) AS StartDate
		, CASE 
		
			WHEN 
				DATE(EstimatedEndDAte) < Date(StartDate) 
			THEN NULL 
			
			ELSE DATE(EstimatedEndDate)
		END AS EstimatedEndDate
	FROM loans
;

-- Verify results
SELECT 
	* 
FROM 
	clean_loans
LIMIT 15
;
	
