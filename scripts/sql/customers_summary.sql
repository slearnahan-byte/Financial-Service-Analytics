/*
CREATED BY: Sophia Learnahan
CREATION DATE: 07/22/2026
DESCRIPTION: 
*/

DROP TABLE IF EXISTS customer_summary;

CREATE TABLE customer_summary AS 
	SELECT 
		c.CustomerID
		, c.CustomerDisplayName
		, c.Age
		, c.CustomerTypeID
		
		, COALESCE(SUM(a.NumberOfAccounts), 0) AS TotalAccounts
		, COALESCE(SUM(a.TotalBalance), 0) AS BalanceAcrossAccounts
		, c.AddressID
		, MIN(acc.OpeningDate) AS FirstOpeningDate
		
		FROM clean_customers c
			LEFT JOIN accounts_summary a
			ON c.CustomerID = a.CustomerID
			LEFT JOIN clean_accounts 'acc'
			ON c.CustomerID = acc.CustomerID
			
		GROUP BY 
			c.CustomerID
			
;
		