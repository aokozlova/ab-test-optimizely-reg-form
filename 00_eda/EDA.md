# Exploratory Data Analysis (EDA)

## Decisions Table
In the decisions table, there are all users in the test.

| Row | experiment_id | variation_id | visitor_id | session_id | date | timestamp | user_agent |
|-----|----------------|---------------|-------------|-------------|------|------------|-------------|
| 1 | 25970160348 | 25974540423 | ibWBP... | QbMN9... | 2022-11-10 | 2022-11-10 06:41:23.784000 UTC | Mozilla/5.0 (Android 10;... |
| 2 | 25970160348 | 25974540423 | dS5ua... | kGq+V... | 2022-11-10 | 2022-11-10 04:57:46.402000 UTC | Mozilla/5.0 (Android 10;... |
| 3 | 25970160348 | 25974540423 | aKaSS... | BdLmr... | 2022-11-10 | 2022-11-10 06:39:19.630000 UTC | Mozilla/5.0 (Android 10;... |
| 4 | 25970160348 | 25974540423 | DBon8... | XuXqk... | 2022-11-13 | 2022-11-13 05:03:29.911000 UTC | Mozilla/5.0 (Android 11;... |
| 5 | 25970160348 | 25974540423 | LRAPC... | 7Fe5r... | 2022-11-10 | 2022-11-10 18:39:21.380000 UTC | Mozilla/5.0 (Android 11;... |


- No null values.
- Only one experiment is present in the dataset.
- Record count distribution is approximately **50/50** between variations.
- Visitors can have multiple sessions and timestamps.

| Row | variation_id | visitors | sessions | timestamp_ | record_cnt |
|-----|---------------|-----------|-----------|-------------|-------------|
| 1 | 25974540423 | 7,642 | 8,495 | 10,863 | 10,865 |
| 2 | 25991400310 | 7,721 | 8,590 | 10,987 | 10,994 |

- Found **4 duplicate rows** by `(visitor_id, session_id, timestamp)`.
- No users appear in both variations.
- A single visitor can have up to:
  - 3 user agents  
  - 21 sessions  
  - 23 timestamps
- **Timestamp range:** 2022-10-26 → 2022-12-22  
- **Date range:** 2022-11-10 → 2022-11-13
  > ADD visualisation
- Total **535 mismatched timestamp/date** pairs.

| Row | total_rows | after_creation | same_day | before_creation |
|-----|-------------|----------------|-----------|-----------------|
| 1 | 21,859 | 4 | 21,324 | 531 |

- We will extract **OS** and **device type** from `user_agent`.
- Since each user may have multiple user agents, each visitor will be assigned to the **user agent with the highest overall count** (based on all users, not just the individual).

> **Example:**  
> Sara visited using `user_agent_x` and `user_agent_y`.  
> Across all users, `user_agent_x` has 100 conversions, while `user_agent_y` has 50.  
> Sara will be attributed to `user_agent_x`.

---

## Conversions Table

in the conversions and account_details table there are only converting users

| Row | experiment_id | variation_id | visitor_id | session_id | user_account_id | date | timestamp | event_type | event_name |
|-----|----------------|---------------|-------------|-------------|-----------------|------|------------|-------------|-------------|
| 1 | 25970160348 | 25991400310 | w5tLi... | 9+ans... | KHnNk... | 2022-11-10 | 2022-11-10 15:01:26.664000 UTC | other | firstPurchase |
| 2 | 25970160348 | 25991400310 | 1jbb5... | GznWn... | nuGfu... | 2022-11-10 | 2022-11-10 01:09:40.427000 UTC | other | firstPurchase |
| 3 | 25970160348 | 25991400310 | pmgw+... | ECNza... | sJ1H6... | 2022-11-10 | 2022-11-10 23:18:25.247000 UTC | other | firstPurchase |
| 4 | 25970160348 | 25991400310 | GXl4f... | xgY1c... | SwdM9... | 2022-11-10 | 2022-11-10 06:37:38.080000 UTC | other | firstPurchase |


- Contains nulls in `account_id`.
- Data for only one experiment.
- Record count distribution is approximately **50/50** between variations.
- **5 duplicate rows** found with `view_activated` event.
- No overlapping users between variations.
- A single visitor can have up to:
  - 22 sessions  
  - 31 timestamps  
  - 20 user accounts  
  - 4 distinct events
- An account_id can have:
  - 20 sessions  
  - 96 timestamps  
  - 3 visitor_ids  
  - 3 distinct events
- **Timestamp range:** 2022-10-26 → 2022-12-22  
- **Date range:** 2022-11-10 → 2022-11-13
- **Timestamp/date mismatches:** 5 after, 194 before.

| Row | total_rows | after_creation | same_day | before_creation |
|-----|-------------|----------------|-----------|-----------------|
| 1 | 41,368 | 5 | 41,169 | 194 |

> ADD visualisation

### Event Types

| Row | event_type | event_name | records_cnt |
|-----|-------------|-------------|--------------|
| 1 | view_activated | 25145940571_register_page_and_confirm | 21,756 |
| 2 | other | purchase | 9,986 |
| 3 | other | signUp | 8,410 |
| 4 | other | firstPurchase | 1,216 |

- A visitor can have up to **3 `firstPurchase`** events.

---

## Account Details Table

in the conversions and account_details table there are only converting users

| Row | account_id | sign_up_timestamp | first_purchase_timestamp | sign_up_method | first_purchase_value |
|-----|-------------|------------------|---------------------------|----------------|----------------------|
| 1 | BMDte... | 2022-04-29 07:40:09.819000 UTC | 2022-05-02 16:39:43.727000 UTC | facebook | null |
| 2 | +p63O... | 2022-05-08 21:14:03.719000 UTC | 2022-05-13 13:13:53.573000 UTC | facebook | null |
| 3 | s1Fk7... | 2022-05-10 12:00:35.370000 UTC | 2022-11-12 00:28:27.888000 UTC | facebook | null |
| 4 | hsN6V... | 2022-05-13 03:19:24.597000 UTC | 2022-07-19 21:26:37.024000 UTC | facebook | null |

- Nulls present in `first_purchase` and `first_purchase_value`.

| Row | total_cnt | account_nulls | su_nulls | fp_nulls | su_method_nulls | fp_value_nulls |
|-----|------------|----------------|-----------|-----------|------------------|----------------|
| 1 | 8,723 | 0 | 0 | 6,592 | 0 | 6,817 |

- 225 records where `fp_value` is null but `fp_timestamp` is not.  
- 0 records where `fp_value` is not null but `fp_timestamp` is null.

### Distribution by Sign-Up Method

| Row | sign_up_method | record_cnt |
|-----|----------------|-------------|
| 1 | facebook | 2,043 |
| 2 | google | 3,097 |
| 3 | manual | 3,583 |

Each account has **only one record**.

## Connection Between Tables

- **1,241** `visitor_id` values from **Conversions** are not present in **Decisions**.  
- **0** `account_id` values are missing from `conversions.user_account_id`.
