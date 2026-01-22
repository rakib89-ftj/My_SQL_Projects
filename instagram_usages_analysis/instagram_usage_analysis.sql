DROP TABLE IF EXISTS instagram_usage_lifestyle;
CREATE TABLE instagram_usage_lifestyle (
    user_id INTEGER,
    app_name TEXT,
    age INTEGER,
    gender TEXT,
    country TEXT,
    urban_rural TEXT,
    income_level TEXT,
    employment_status TEXT,
    education_level TEXT,
    relationship_status TEXT,
    has_children TEXT,

    exercise_hours_per_week REAL,
    sleep_hours_per_night REAL,
    diet_quality TEXT,
    smoking TEXT,
    alcohol_frequency TEXT,

    perceived_stress_score INTEGER,
    self_reported_happiness INTEGER,

    body_mass_index REAL,
    blood_pressure_systolic INTEGER,
    blood_pressure_diastolic INTEGER,
    daily_steps_count INTEGER,

    weekly_work_hours REAL,
    hobbies_count INTEGER,
    social_events_per_month INTEGER,
    books_read_per_year INTEGER,
    volunteer_hours_per_month REAL,
    travel_frequency_per_year INTEGER,

    daily_active_minutes_instagram REAL,
    sessions_per_day INTEGER,
    posts_created_per_week INTEGER,
    reels_watched_per_day INTEGER,
    stories_viewed_per_day INTEGER,
    likes_given_per_day INTEGER,
    comments_written_per_day INTEGER,
    dms_sent_per_week INTEGER,
    dms_received_per_week INTEGER,

    ads_viewed_per_day INTEGER,
    ads_clicked_per_day INTEGER,

    time_on_feed_per_day INTEGER,
    time_on_explore_per_day INTEGER,
    time_on_messages_per_day INTEGER,
    time_on_reels_per_day INTEGER,

    followers_count INTEGER,
    following_count INTEGER,

    uses_premium_features TEXT,
    notification_response_rate REAL,

    account_creation_year INTEGER,
    last_login_date TEXT,
    average_session_length_minutes REAL,

    content_type_preference TEXT,
    preferred_content_theme TEXT,
    privacy_setting_level TEXT,

    two_factor_auth_enabled TEXT,
    biometric_login_used TEXT,
    linked_accounts_count INTEGER,

    subscription_status TEXT,
    user_engagement_score REAL
);

select * from instagram_usage_lifestyle;

--Find the total number of users in the dataset.
SELECT
	count(*) as total_users
from instagram_usage_lifestyle;

--List all unique countries where users are from.
SELECT
	DISTINCT country
FROM instagram_usage_lifestyle;

--Count how many users are from Urban vs Rural areas.
SELECT * FROM instagram_usage_lifestyle
SELECT
	urban_rural,
	count(*)
from instagram_usage_lifestyle
GROUP by urban_rural;

--Retrieve users whose age is greater than 40.
select * from instagram_usage_lifestyle
SELECT * 
FROM instagram_usage_lifestyle 
WHERE age > 40;

--Find users who have Free subscription status.
SELECT *
FROM instagram_usage_lifestyle
where subscription_status = 'Free'

--Show users who enabled two-factor authentication
select *
from instagram_usage_lifestyle
where two_factor_auth_enabled='Yes';

--List users who spend more than 60 minutes daily on Instagram.
SELECT *
FROM instagram_usage_lifestyle
WHERE daily_active_minutes_instagram > 60;

--Calculate the average age of Instagram users by country
SELECT
	country,
	avg(age) as avg_age
FROM instagram_usage_lifestyle
GROUP by country;

--Find the average engagement score by gender.
select
	gender,
	avg(user_engagement_score) as avg_engagement
from instagram_usage_lifestyle
group by gender;

--Count users by education level
SELECT
	education_level,
	count(*)
FROM instagram_usage_lifestyle
GROUP by education_level;

--Find the top 10 countries with the highest number of Instagram users.
SELECT
	country,
	count(*) as user_count
from instagram_usage_lifestyle
GROUP by country
ORDER by user_count
LIMIT 10;

--Calculate average daily Instagram active minutes by income level
SELECT
	income_level,
	avg(daily_active_minutes_instagram) as avg_minutes
from instagram_usage_lifestyle
GROUP by income_level;

--Count how many users have children grouped by relationship status
SELECT
	relationship_status,
	count(*)
FROM instagram_usage_lifestyle
WHERE has_children ='Yes'
GROUP by relationship_status;

--Find countries where the average engagement score is greater than 6
SELECT
	country,
	avg(user_engagement_score) as avg_engage
from instagram_usage_lifestyle
GROUP by country
HAVING avg(user_engagement_score) > 2;

-- Classify users as Low / Medium / High engagement using `CASE`
SELECT
	user_id,
	case
		WHEN user_engagement_score < 4 THEN 'Low'
		WHEN user_engagement_score BETWEEN 4 and 7 THEN 'Medium'
		ELSE 'High'
	end as engagement_level
from instagram_usage_lifestyle;

--Find users who log in more frequently than the average sessions per day.
SELECT *
FROM instagram_usage_lifestyle
WHERE sessions_per_day >
	(select avg(sessions_per_day) from instagram_usage_lifestyle);

--Identify users who spend more time on Reels than on Feed
SELECT * 
FROM instagram_usage_lifestyle
WHERE reels_watched_per_day > time_on_feed_per_day;

--Find users with high stress score (>7) but high Instagram usage
select *
from instagram_usage_lifestyle
WHERE perceived_stress_score >7 and daily_active_minutes_instagram>90;

--Determine correlation direction between `daily_steps_count` and engagement score
SELECT
	corr(daily_steps_count, user_engagement_score)
from instagram_usage_lifestyle;

--Find the top 5 countries with the highest average followers per user
SELECT
	country,
	avg(followers_count) as avg_followers
from instagram_usage_lifestyle
GROUP by country
order by avg_followers DESC
LIMIT 5;

--Analyze how sleep hours affect average engagement score
SELECT
	sleep_hours_per_night, 
	avg(user_engagement_score) as avg_engagement
from instagram_usage_lifestyle
GROUP by sleep_hours_per_night

--Compute average likes, comments, and DMs per day by age group
SELECT
case
	when age < 18 THEN 'Teen'
	WHEN age  BETWEEN 18 and 30 then 'Young Adult'
	WHEN age BETWEEN 31 and 50 then 'Adult'
	ELSE 'Senior'
END as age_group,
avg(likes_given_per_day) as avg_likes,
avg(comments_written_per_day) as avg_comments
from instagram_usage_lifestyle
GROUP by age_group;

--Rank users within each country based on engagement score
SELECT
	user_id,
	country,
	user_engagement_score,
	rank() over(partition by country ORDER by user_engagement_score DESC) as country_rank
from instagram_usage_lifestyle

--Find the top 1% most engaged users using window functions
SELECT *
from (
select *,
	ntile(100) OVER(order by user_engagement_score desc) as percentile
FROM instagram_usage_lifestyle
) t
WHERE percentile =1

--Compare engagement of users with and without premium features
select
	uses_premium_features,
	avg(user_engagement_score)
from instagram_usage_lifestyle
group by uses_premium_features