/*
CREATED BY: Sophia Learnahan
CREATION DATE: 07/22/2026
DESCRIPTION: Investigate duplicate CustomerIDS and clean/transform customer profile data.

TRANSFORMATIONS:
	- Enforce structural integrity (define CustomerID as Primary Key)
	- De-duplicate source records using DISTINCT
	- Standardize letter casing (UPPER) for FirstName LastName
	- Generate composite business key (CustomerDisplayName) with fallback defaults
	- Standardize inconsistent date formats to ISO-8601 (YYYY-MM-DD)
*/

PRAGMA table_info(customers);
 
DROP VIEW IF EXISTS duplicate_customerID;
DROP TABLE IF EXISTS clean_customers;

-- Check for duplicates
CREATE VIEW duplicate_customerID AS
	WITH 
		numbered_customers AS (
		SELECT 
			*
			, COUNT(*) OVER(PARTITION BY CustomerID) AS IdCount --count entries for each unique CustomerID
		FROM customers
	)
	SELECT 
		*
	FROM 
		numbered_customers
	WHERE 
		IDCount > 1 --extract duplicates
;

-- Investigate duplicates - duplicated across all columns?
SELECT 
	* 
FROM 
	duplicate_customerID;

-- Create empty table
CREATE TABLE clean_customers (
    CustomerID INT PRIMARY KEY
    , FirstName TEXT
    , LastName TEXT
    , CustomerDisplayName TEXT
    , DateOfBirth TEXT
	, Age INT
    , AddressID INT
    , CustomerTypeID INT
);

-- Apply cleaning/transformations
INSERT INTO clean_customers
	SELECT DISTINCT -- uniqueness combination of all columns
		CustomerID
		, TRIM(UPPER(FirstName)) AS FirstName
		, TRIM(UPPER(LastName)) AS LastName
		-- Customer Display Name with null fallbacks
		, CASE
		
			-- First and Last Name Null
			WHEN 
				NULLIF(FirstName, '') IS NULL AND NULLIF(LastName, '') IS NULL
			THEN '#N/A, #N/A (ID: ' || CustomerID || ')'
			
			-- First Name Null
			WHEN  
				NULLIF(FirstName, '') IS NULL AND NULLIF(LastName, '') IS NOT NULL
			THEN TRIM(UPPER(LastName ))|| ', #N/A (ID: ' || CustomerID || ')'
			
			-- Last Name NULL
			WHEN 
				NULLIF(FirstName, '') IS NOT NULL AND NULLIF(LastName, '') IS NULL
			THEN '#N/A, ' || TRIM(UPPER(FirstName)) || ' (ID: ' || CustomerID || ')'
			
			-- Neither Null
			ELSE TRIM(UPPER(LastName)) || ', ' || TRIM(UPPER(FirstName)) || ' (ID: ' || CustomerID || ')'
		END AS CustomerDisplayName
		-- Format Birthday 
		, CASE
		
			-- Data entry errors
			WHEN 
				DateOfBirth LIKE '__/__/____' OR DateOfBirth LIKE '__.__.____'
			THEN SUBSTR(DateOfBirth, 7,4) || '-' || SUBSTR(DateOfBirth, 1, 2) || '-' || SUBSTR(DateOfBirth, 4, 2)
			
			WHEN 
				DateOfBirth LIKE '____/__/__' OR DateOfBirth LIKE '____.__.__'
			THEN SUBSTR(DateOfBirth, 1,4) || '-' || SUBSTR(DateOfBirth, 6, 2) || '-' || SUBSTR(DateOfBirth, 9, 2)
			
			-- Null
			WHEN 
				DateOfBirth = 'NaT' 
			THEN NULL
			
			-- Strip date 
			ELSE DATE(DateOfBirth)
		END AS DateOfBirth
		
		, STRFTIME('%Y', 'now')- STRFTIME('%Y', DateOfBirth) -- calculate the difference in years
        - (STRFTIME('%m'-'%d', 'now') < STRFTIME('%m'-'%d', DateOfBirth)) 
		AS Age -- if birthday hasnt occured -1
		
		, AddressID
		, CustomerTypeID
	FROM customers
;

-- Verify results
SELECT 
	* 
FROM 
	clean_customers
LIMIT 
	15
;
		
		
		
