with banner_show as (
select dt, session_id, exchange_session_id
from yc_hive.masterdata_exchange.exchange_check
where banner_id = 10808 ),
click_banner as
(select created_at, el.exchange_session_id, el.session_id
from yc_hive.masterdata_exchange.exchange_landing el
join banner_show bs on el.exchange_session_id = bs.exchange_session_id),
users as (
select
    session_id,
    count(distinct created_at) as total_clicks,
    count(distinct date(created_at)) as active_date,
    min(date(created_at)) as first_click,
    max(date(created_at)) as last_click,
    date_diff('day', min(date(created_at)), max(date(created_at)))+1  as total_active_days
from click_banner
group by 1
),
customers as (
select distinct ea.customer_id
from users join yc_hive.masterdata_exchange.exchange_accept_v4 ea on users.session_id = ea.session_id
where total_clicks >= 4
and active_date >= 4
and ea.customer_id <> 30338103
)
select count(distinct email)
from customers c join yc_hive.masterdata_general.customer_v2 cv on c.customer_id = cv.id
where SPLIT_PART(email, '@', 2) IN ('mail.ru','gmail.com','rambler.ru','bk.ru', 'list.ru','inbox.ru', 'yandex.ru','ya.ru','internet.ru','xmail.ru')

