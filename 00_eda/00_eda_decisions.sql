SELECT * FROM  `abtest_raw.desicions`
LIMIT 5;


--checking nulls
--no nulls
SELECT COUNT(*) AS total_cnt,
      SUM(CASE WHEN experiment_id IS NULL THEN 1 ELSE 0 END) as experiment_nulls,
      SUM(CASE WHEN variation_id IS NULL THEN 1 ELSE 0 END) as variation_nulls,
      SUM(CASE WHEN visitor_id IS NULL THEN 1 ELSE 0 END) as visitor_nulls,
      SUM(CASE WHEN session_id IS NULL THEN 1 ELSE 0 END) as session_nulls,
      SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) as date_value_nulls,
      SUM(CASE WHEN timestamp IS NULL THEN 1 ELSE 0 END) as timestamp_nulls,
      SUM(CASE WHEN user_agent IS NULL THEN 1 ELSE 0 END) as user_agent_nulls
FROM `abtest_raw.desicions`;




--checking if we have data from another experiment
--we have one experiment id
SELECT DISTINCT experiment_id FROM `abtest_raw.desicions`;


--variation distribution
--~50/50
SELECT COUNT(*) AS record_cnt FROM `abtest_raw.desicions`
GROUP BY variation_id;


--visitors have multiple sessions and timestamps
SELECT variation_id,
      COUNT(DISTINCT visitor_id) as visitors,
      COUNT(DISTINCT session_id) as sessions,
      COUNT(DISTINCT timestamp)  as timestamp_,
      COUNT(*) AS record_cnt
FROM `abtest_raw.desicions`
GROUP BY variation_id;


--checking duplicates by visitor, session, timestamp
--!! We have 4 duplicates
SELECT visitor_id,
      session_id,
      timestamp,
      COUNT(*) as cnt
FROM `abtest_raw.desicions`
GROUP BY 1,2,3
HAVING cnt > 1;


--are there the same users or sessions in both variations
--not found
SELECT visitor_id,
      COUNT(DISTINCT variation_id) as variations
FROM `abtest_raw.desicions`
GROUP BY visitor_id
HAVING variations > 1;


SELECT session_id,
      COUNT(DISTINCT variation_id) as variations
FROM `abtest_raw.desicions`
GROUP BY session_id
HAVING variations > 1;


--how many sessions and user agents a visitor can have
--visitors can have multiple user_agents, sessions and timestamps
SELECT visitor_id,
      COUNT(DISTINCT user_agent) as user_agent_cnt,
      COUNT(DISTINCT session_id) as sessions_cnt,
      COUNT(DISTINCT timestamp) as timestamp_cnt
FROM `abtest_raw.desicions`
GROUP BY visitor_id
ORDER BY 2 DESC,3 DESC,4 DESC;


--checking timerange
--timestamp 26-10-2022 - 21-12-2022
--date 10-11-2022 - 13-11-2022
SELECT MIN(timestamp) as min_timestamp,
      MAX(timestamp) as max_timestamp,
      MIN(date) as min_date,
      MAX(DATE) as max_date
FROM `abtest_raw.desicions`;




--group data for visualisation (go to Looker studio)
--https://lookerstudio.google.com/u/1/reporting/fe30b51d-2496-4a8f-b9a9-cb2790d1ab90/page/tEnnC/edit
-- The majority of visitors had a timestamp on the same date as the creation date
-- Some visitors have a timestamp earlier than the creation date
SELECT DATE(timestamp) as desicion_date,
      date,
      variation_id,
      COUNT(DISTINCT visitor_id) as visitors,
      COUNT(DISTINCT session_id) as session
FROM `abtest_raw.desicions`
GROUP BY DATE(timestamp),
         date,
        variation_id;


--How many rows do we have with mismatching timestamp vs creation date
--in total 531 before and 4 after creation date
SELECT
 COUNT(*) AS total_rows,
 SUM(CASE WHEN DATE(timestamp) > date THEN 1 ELSE 0 END) AS after_creation,
 SUM(CASE WHEN DATE(timestamp) = date THEN 1 ELSE 0 END) AS same_day,
 SUM(CASE WHEN DATE(timestamp) < date THEN 1 ELSE 0 END) AS before_creation
FROM `abtest_raw.desicions`;


--
SELECT *
FROM `abtest_raw.desicions`
WHERE DATE(timestamp) <> date;


--How many unique user agents do we have?
--3023
SELECT COUNT(DISTINCT user_agent) as user_agent_cnt
FROM `abtest_raw.desicions`;


--What are the most popular user agents?
--We will be able to extract the platform device type and iOS
SELECT user_agent,
      COUNT(*) AS  records_cnt
FROM `abtest_raw.desicions`
GROUP BY user_agent
ORDER BY 2 desc
LIMIT 10;






--Do the most popular user agents have a 50/50 distribution by variations?
--yes
SELECT user_agent,
      variation_id,
      COUNT(*) as records_cnt
FROM `abtest_raw.desicions`
GROUP BY user_agent, variation_id
ORDER BY records_cnt desc
Limit 10;


/*Each user can visit our page from multiple user agents. I want you to allocate each user to the user agent with the highest total number of occurrences (rows in the decisions table)

Example:
Sara visited from user_agent_x and user_agent_y. User_agent_x AMONG ALL PLAYERS (not just for Sara) has 100 conversions,  User_agent_y has 50. Sara should be attributed to user_agent_x.
*/





