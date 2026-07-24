/*
CREATED BY: Sophia Learnahan
CREATION DATE: 07/22/2026
DESCRIPTION: 

TRANSFORMATIONS:
	- 
*/

PRAGMA table_info(addresses);

DROP VIEW IF EXISTS	duplicate_addresses;
DROP VIEW IF EXISTS clean_addresses;


-- Check for duplicates
CREATE VIEW duplicate_addresses AS
	WITH 
		numbered_addressID AS (
		SELECT 
			*
			, COUNT(*) OVER(PARTITION BY AddressID) AS IdCount -- count entries for each unique TransactionID
		FROM addresses
	)
	SELECT 
		*
	FROM 
		numbered_addressID
	WHERE 
		IDCount > 1 --extract duplicates
;

-- Investigate duplicates - duplicated across all columns?
SELECT 
	* 
FROM 
	duplicate_addresses;

CREATE VIEW clean_addresses AS
	SELECT 
		AddressID
		, Street
		, City
		-- all entries appear to be from the U.S.
		, 'United States' AS Country
	FROM addresses
;
