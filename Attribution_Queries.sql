Calculate Distinct Campaigns

SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits;

Calculate Distinct Sources

SELECT COUNT(DISTINCT utm_source)
FROM page_visits;

Show which source is used for each campaign

SELECT utm_campaign, utm_source
FROM page_visits
GROUP BY utm_campaign, utm_source;

Show which pages are on the CTS website

SELECT DISTINCT page_name
FROM page_visits;

How many first touches is each campaign responsible for

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         COUNT(utm_campaign)
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY utm_campaign;

How many last touches?

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id)
SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         COUNT(utm_campaign)
  FROM last_touch AS lt
  JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY COUNT(utm_campaign) DESC;

How many visitors make a purchase?

SELECT page_name, COUNT(*)
FROM page_visits
WHERE page_name = '4 - purchase';

How many last touches on the purchase page is each campaign responsible for?

WITH last_touch AS (
    SELECT user_id, page_name,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id)
SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         COUNT(utm_campaign)
  FROM last_touch AS lt
  JOIN page_visits AS pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY COUNT(utm_campaign) DESC;


