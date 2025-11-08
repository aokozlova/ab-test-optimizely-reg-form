SELECT * FROM `abtest_raw.account_details`
LIMIT 5;

--checking nulls
--nulls in first purchase, first purchase value
SELECT COUNT(*) AS total_cnt,
       SUM(CASE WHEN account_id IS NULL THEN 1 ELSE 0 END) as account_nulls,
       SUM(CASE WHEN sign_up_timestamp IS NULL THEN 1 ELSE 0 END) as su_nulls,
       SUM(CASE WHEN first_purchase_timestamp IS NULL THEN 1 ELSE 0 END) as fp_nulls,
       SUM(CASE WHEN sign_up_method IS NULL THEN 1 ELSE 0 END) as su_method_nulls,
       SUM(CASE WHEN first_purchase_value IS NULL THEN 1 ELSE 0 END) as fp_value_nulls
FROM `abtest_raw.account_details`;

--how many accounts with first purchase timestamp dont have first purchase value and the opposite
--we have 225 records when value is null but fp timestamp is not
-- 0 recores when value is not null but fp timestamp is null
SELECT SUM(CASE WHEN first_purchase_timestamp IS NOT NULL 
           AND first_purchase_value is NULL
           THEN 1 else 0 END) AS null_value,
           SUM(CASE WHEN first_purchase_timestamp IS NULL 
           AND first_purchase_value is NOT NULL
           THEN 1 else 0 END) AS null_fp_timestamp,
FROM `abtest_raw.account_details`;

--whats the disctobytion by su method
SELECT sign_up_method,
       COUNT(*) as record_cnt
FROM `abtest_raw.account_details`
GROUP BY sign_up_method;

--checking duplicates
--no duplicates by account id, su_timestamp, first_purchase_timestamp, su_method
SELECT account_id,
       sign_up_timestamp,
       first_purchase_timestamp,
       sign_up_method,
       COUNT(*) AS record_cnt
FROM `abtest_raw.account_details`
GROUP BY account_id,
       sign_up_timestamp,
       first_purchase_timestamp,
       sign_up_method
HAVING record_cnt > 1;

--how many accounts they have there
SELECT COUNT(DISTINCT account_id)
FROM `abtest_raw.account_details`;

--how many records account can have
--each account has only one record
SELECT account_id,
       COUNT(*) as record_cnt
FROM `abtest_raw.account_details`
GROUP BY account_id
ORDER BY record_cnt DESC









