--checking connections between files


--https://docs.google.com/spreadsheets/d/1Fv-p-zoKGj14KocZ89XW1ZW9ILDExvTPcauaqVzhnbc/edit?gid=1963857872#gid=1963857872

--in the decisions table there are all users in the test
--in the conversions and account_details table there are only converting users

--visitor id from conversions but not in decisions
--found 1241 visitors id
SELECT COUNT(DISTINCT visitor_id)
FROM `abtest_raw.conversions`
WHERE visitor_id NOT IN
(SELECT DISTINCT visitor_id FROM `abtest_raw.desicions`);

SELECT *
FROM `abtest_raw.conversions`
WHERE visitor_id NOT IN
(SELECT DISTINCT visitor_id FROM `abtest_raw.desicions`);

--account id from account details that are not in conversions
--not found
SELECT COUNT(DISTINCT account_id)
FROM `abtest_raw.account_details`
WHERE account_id NOT IN
(SELECT DISTINCT user_account_id FROM `abtest_raw.conversions`);


