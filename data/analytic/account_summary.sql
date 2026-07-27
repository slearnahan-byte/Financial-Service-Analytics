/*
CREATED BY: Sophia Learnahan
CREATION DATE: 07/22/2026
DESCRIPTION: 
*/

DROP TABLE IF EXISTS accounts_summary;

CREATE TABLE accounts_summary AS
	SELECT
		a.CustomerID
		, a.AccountTypeID
		, a.AccountStatusID
		, COUNT(a.AccountID) AS NumberOfAccounts
		, SUM(a.balance) AS TotalBalance
	FROM clean_accounts a
	GROUP BY 
		a.CustomerID
		, a.AccountTypeID
		, a.AccountStatusID
;
