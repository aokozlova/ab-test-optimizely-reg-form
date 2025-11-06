SELECT * FROM  `abtest_raw.desicions`
LIMIT 5;

--checkig nulls
--no nulls in experiment or variation
SELECT COUNT(*) as experiment_id_nulls FROM `abtest_raw.desicions`
WHERE experiment_id is NULL;

SELECT COUNT(*) as variation_id_nulls FROM `abtest_raw.desicions`
WHERE variation_id is NULL;

--checking if we have data from another experiment
--only one experiment
SELECT DISTINCT experiment_id FROM `abtest_raw.desicions`;

--variation distribution
--~50/50
SELECT COUNT(*) AS cnt FROM `abtest_raw.desicions`
GROUP BY variation_id;

--visitors have multiple sessions and timestamps
SELECT variation_id,
       COUNT(DISTINCT visitor_id) as visitors, 
       COUNT(DISTINCT session_id) as sessions,
       COUNT(DISTINCT timestamp)  as timestamp_,
       COUNT(*) AS total_rows
FROM `abtest_raw.desicions`
GROUP BY variation_id;

--checking duplicates 
--!! we have duplicates
SELECT visitor_id,
       session_id,
       timestamp,
       COUNT(*) as cnt
FROM `abtest_raw.desicions`
GROUP BY 1,2,3
HAVING cnt > 1;

--are there same users or session in both variations
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

--how many sessions and users agents visitor can have
--visitors can have multiple user_agents, sessions and timestamps
SELECT visitor_id,
       COUNT(DISTINCT user_agent) as user_agent_cnt,
       COUNT(DISTINCT session_id) as sessions_cnt,
       COUNT(DISTINCT timestamp) as timestamp_cnt
FROM `abtest_raw.desicions`
GROUP BY visitor_id
ORDER BY 2 DESC,3 DESC,4 DESC;

--checking timerange
SELECT MIN(timestamp) as min_timestamp,
       MAX(timestamp) as max_timestamp
FROM `abtest_raw.desicions`;


--group data for visualization (go to Looker stuido)
--https://lookerstudio.google.com/u/1/reporting/fe30b51d-2496-4a8f-b9a9-cb2790d1ab90/page/tEnnC/edit
-- majority of visitors had timestamp at the same date as creatuon date
-- some visotrs have timestamp earlier than creation date
SELECT DATE(timestamp) as desicion_date,
       date,
       variation_id,
       COUNT(DISTINCT visitor_id) as visitors,
       COUNT(DISTINCT session_id) as session
FROM `abtest_raw.desicions`
GROUP BY DATE(timestamp),
          date,
         variation_id;

--how many rows do we have with mismatching tamestap vs creation date
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

--how many unique user agent we have?
SELECT COUNT(DISTINCT user_agent) as user_agent_cnt
FROM `abtest_raw.desicions`;

--what are the most popular user agens?
SELECT user_agent, 
       COUNT(*) AS  records_cnt
FROM `abtest_raw.desicions`
GROUP BY user_agent
ORDER BY 2 desc;



--do the most popular user agents have the 50/50 distribution by variations?
SELECT user_agent, 
       variation_id,
       COUNT(*) as records_cnt
FROM `abtest_raw.desicions`
GROUP BY user_agent, variation_id
ORDER BY records_cnt desc
Limit 10;

/*each user can visit our page from multiple user agents. I want you to allocate each user to the user agent with the highest total number of occurrences (rows in the decisions table)

Example:
Sara visited from user_agent_x and user_agent_y. User_agent_x AMONG ALL PLAYERS (not just for Sara) has 100 conversions,  User_agent_y has 50. Sara should be attributed to user_agent_x.
*/




         


