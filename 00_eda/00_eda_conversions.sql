SELECT * FROM  `abtest_raw.conversions`
LIMIT 5;

--checkig nulls
--no nulls in experiment or variation
SELECT COUNT(*) as experiment_id_nulls FROM `abtest_raw.conversions`
WHERE experiment_id is NULL;

SELECT COUNT(*) as variation_id_nulls FROM `abtest_raw.conversions`
WHERE variation_id is NULL;

--checking if we have data from another experiment
--only one experiment
SELECT DISTINCT experiment_id FROM `abtest_raw.conversions`;

--variation distribution
--~50/50
SELECT COUNT(*) AS cnt FROM `abtest_raw.conversions`
GROUP BY variation_id;


SELECT variation_id,
       COUNT(DISTINCT visitor_id) as visitors, 
       COUNT(DISTINCT session_id) as sessions,
       COUNT(DISTINCT timestamp)  as timestamp_,
       COUNT(DISTINCT user_account_id) as account_id,
       COUNT(*) AS total_rows
FROM `abtest_raw.conversions`
GROUP BY variation_id;

--checking duplicates 
--!! we have duplicates
SELECT visitor_id,
       session_id,
       timestamp,
       event_type,
       event_name,
       COUNT(*) as cnt
FROM `abtest_raw.conversions`
GROUP BY 1,2,3,4,5
HAVING cnt > 1;

--are there same users or session in both variations
--not found
SELECT visitor_id, 
       COUNT(DISTINCT variation_id) as variations
FROM `abtest_raw.conversions`
GROUP BY visitor_id
HAVING variations > 1;

SELECT session_id, 
       COUNT(DISTINCT variation_id) as variations
FROM `abtest_raw.conversions`
GROUP BY session_id
HAVING variations > 1;


--how many sessions, timestamps and user_account_id visitor can have
--visitors can have multiple user_account_id !!! sessions and timestamps
SELECT visitor_id,
       COUNT(DISTINCT session_id) as sessions_cnt,
       COUNT(DISTINCT timestamp) as timestamp_cnt,
       COUNT(DISTINCT user_account_id) as user_account_id
FROM `abtest_raw.conversions`
GROUP BY visitor_id
ORDER BY 2 DESC,3 DESC,4 DESC;

--how many sessions, visitors and timestamps user_accountId can have
--user_account_id can have multiple visitor_id, session_id and timestamps
SELECT user_account_id,
       COUNT(DISTINCT session_id) as sessions_cnt,
       COUNT(DISTINCT timestamp) as timestamp_cnt,
       COUNT(DISTINCT visitor_id) as visitor_id
FROM `abtest_raw.conversions`
GROUP BY user_account_id
ORDER BY 2 DESC,3 DESC,4 DESC;

--checking timerange
SELECT MIN(timestamp) as min_timestamp,
       MAX(timestamp) as max_timestamp
FROM `abtest_raw.conversions`;


--group data for visualization (go to Looker stuido)
--https://lookerstudio.google.com/u/1/reporting/fe30b51d-2496-4a8f-b9a9-cb2790d1ab90/page/tEnnC/edit
-- majority if visitors had timestamp at the same date as creatuon date
-- some visotrs have timestamp earlier than creation date
SELECT DATE(timestamp) as desicion_date,
       date,
       variation_id,
       COUNT(DISTINCT visitor_id) as visitors,
       COUNT(DISTINCT session_id) as session,
       COUNT(*) AS records_cnt
FROM `abtest_raw.conversions`
GROUP BY DATE(timestamp),
          date,
         variation_id;

--how many rows do we have with mismatching tamestap vs creation date
SELECT
  COUNT(*) AS total_rows,
  SUM(CASE WHEN DATE(timestamp) > date THEN 1 ELSE 0 END) AS after_creation,
  SUM(CASE WHEN DATE(timestamp) = date THEN 1 ELSE 0 END) AS same_day,
  SUM(CASE WHEN DATE(timestamp) < date THEN 1 ELSE 0 END) AS before_creation
FROM `abtest_raw.conversions`;

--
SELECT * 
FROM `abtest_raw.conversions`
WHERE DATE(timestamp) <> date;

--what event do we have
SELECT event_type,
       event_name,
       COUNT(*) as records_cnt
FROM `abtest_raw.conversions`
GROUP BY event_type,
         event_name;         

--how many event names a visotor can have
SELECT visitor_id,
       event_name,
       COUNT(*)
FROM `abtest_raw.conversions`
GROUP BY visitor_id,
         event_name
ORDER BY 3 DESC;   

--how many first purchase event visotr can have
SELECT visitor_id,
       event_name,
       COUNT(*)
FROM `abtest_raw.conversions`
WHERE event_name = "firstPurchase"
GROUP BY visitor_id,
         event_name
ORDER BY 3 DESC; 

---how many first purchases user_acccount_id can have
SELECT user_account_id,
       event_name,
       COUNT(*)
FROM `abtest_raw.conversions`
WHERE event_name = "firstPurchase"
GROUP BY user_account_id,
         event_name
ORDER BY 3 DESC; 







         


