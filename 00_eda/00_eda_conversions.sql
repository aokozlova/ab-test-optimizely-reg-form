SELECT * FROM  `abtest_raw.conversions`
LIMIT 5;


--checking nulls
--we have nulls in user_account_id
SELECT COUNT(*) AS total_cnt,
     SUM(CASE WHEN experiment_id IS NULL THEN 1 ELSE 0 END) as experiment_nulls,
     SUM(CASE WHEN variation_id IS NULL THEN 1 ELSE 0 END) as variation_nulls,
     SUM(CASE WHEN visitor_id IS NULL THEN 1 ELSE 0 END) as visitor_nulls,
     SUM(CASE WHEN session_id IS NULL THEN 1 ELSE 0 END) as session_nulls,
     SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) as date_value_nulls,
     SUM(CASE WHEN timestamp IS NULL THEN 1 ELSE 0 END) as timestamp_nulls,
     SUM(CASE WHEN event_type IS NULL THEN 1 ELSE 0 END) as event_type_nulls,
     SUM(CASE WHEN event_name IS NULL THEN 1 ELSE 0 END) as event_name_nulls,
     SUM(CASE WHEN user_account_id IS NULL THEN 1 ELSE 0 END) as account_id_nulls
FROM `abtest_raw.conversions`;


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
--!! we have 5 duplicates with view-activated event
SELECT visitor_id,
      session_id,
      timestamp,
      event_type,
      event_name,
      COUNT(*) as cnt
FROM `abtest_raw.conversions`
GROUP BY 1,2,3,4,5
HAVING cnt > 1;


--are there the same users or sessions in both variations
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




--how many sessions, timestamps, and user_account_id a visitor can have
--visitors can have multiple user_account_id !!! sessions and timestamps
SELECT visitor_id,
      COUNT(DISTINCT session_id) as sessions_cnt,
      COUNT(DISTINCT timestamp) as timestamp_cnt,
      COUNT(DISTINCT user_account_id) as user_account_id,
      COUNT(DISTINCT event_name) as event_name
FROM `abtest_raw.conversions`
GROUP BY visitor_id
ORDER BY 2 DESC,3 DESC,4 DESC;


--how many sessions, visitors, and timestamps user_accountId can have
--user_account_id can have multiple visitor_id, session_id and timestamps
SELECT user_account_id,
      COUNT(DISTINCT session_id) as sessions_cnt,
      COUNT(DISTINCT timestamp) as timestamp_cnt,
      COUNT(DISTINCT visitor_id) as visitor_id,
      COUNT(DISTINCT event_name) as event_name
FROM `abtest_raw.conversions`
GROUP BY user_account_id
ORDER BY 2 DESC,3 DESC,4 DESC;


--checking timerange
--Time range of timestamp is 2022-10-26 - 2022-12-22
--Time range of date is 10-11-2022 - 13-11-2022
SELECT MIN(timestamp) as min_timestamp,
      MAX(timestamp) as max_timestamp,
      MIN(date) as min_date,
      MAX(date) as max_date
FROM `abtest_raw.conversions`;




--group data for visualisation (go to Looker studio)
--https://lookerstudio.google.com/u/1/reporting/fe30b51d-2496-4a8f-b9a9-cb2790d1ab90/page/tEnnC/edit
-- the majority of visitors had a timestamp on the same date as the creation date
-- Some visitors have a timestamp earlier than the creation date
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


--how many rows do we have with mismatching timestamp vs creation date
--4 records after
--194 before
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


--what events do we have
SELECT event_type,
      event_name,
      COUNT(*) as records_cnt
FROM `abtest_raw.conversions`
GROUP BY event_type,
        event_name
ORDER BY 3 DESC;        




--how many records of the first purchase event visitor can have
--up to 3
SELECT visitor_id,
      event_name,
      COUNT(*)
FROM `abtest_raw.conversions`
WHERE event_name = "firstPurchase"
GROUP BY visitor_id,
        event_name
ORDER BY 3 DESC;


---how many records about first purchases, user_account_id can have
--up to 3
SELECT user_account_id,
      event_name,
      COUNT(*)
FROM `abtest_raw.conversions`
WHERE event_name = "firstPurchase"
GROUP BY user_account_id,
        event_name
ORDER BY 3 DESC;
