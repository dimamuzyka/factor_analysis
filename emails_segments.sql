WITH banner_show AS (
    SELECT 
        dt, 
        session_id, 
        exchange_session_id
    FROM yc_hive.masterdata_exchange.exchange_check
    WHERE banner_id = 10808
), 
click_banner AS (
    SELECT 
        el.created_at, 
        el.exchange_session_id, 
        el.session_id
    FROM yc_hive.masterdata_exchange.exchange_landing el
    JOIN banner_show bs 
        ON el.exchange_session_id = bs.exchange_session_id
), 
users AS (
    SELECT
        session_id,
        COUNT(DISTINCT created_at) AS total_clicks,
        COUNT(DISTINCT DATE(created_at)) AS active_date,
        MIN(DATE(created_at)) AS first_click,
        MAX(DATE(created_at)) AS last_click,
        DATE_DIFF('day', MIN(DATE(created_at)), MAX(DATE(created_at))) + 1 AS total_active_days
    FROM click_banner
    GROUP BY session_id
), 
customers AS (
    SELECT DISTINCT ea.customer_id
    FROM users 
    JOIN yc_hive.masterdata_exchange.exchange_accept_v4 ea 
        ON users.session_id = ea.session_id
    WHERE total_clicks >= 4
        AND active_date >= 4
        AND ea.customer_id <> 30338103
) 
SELECT COUNT(DISTINCT email)
FROM customers c 
JOIN yc_hive.masterdata_general.customer_v2 cv 
    ON c.customer_id = cv.id
WHERE SPLIT_PART(email, '@', 2) IN (
    'mail.ru', 'gmail.com', 'rambler.ru', 'bk.ru', 'list.ru', 
    'inbox.ru', 'yandex.ru', 'ya.ru', 'internet.ru', 'xmail.ru'
);
