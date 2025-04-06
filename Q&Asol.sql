-- We want to reward our users who have been around the longest. Find the 5 oldest users.
USE INSTAGRAM_CLONE;
SELECT username, created_at
FROM users
ORDER BY created_at ASC
LIMIT 5;

-- What day of the week do most users register on? We need to figure out when to schedule an ad campgain
SELECT DAYNAME(created_at) AS registration_day,
    count(*) AS num
FROM users
GROUP BY registration_day
ORDER BY num DESC;

SELECT DAYNAME(created_at) AS registration_day, COUNT(*) AS num
FROM users
GROUP BY registration_day
HAVING count(*) = (
                    SELECT COUNT(*) AS reg_num
                    FROM users
                    GROUP BY DAYNAME(created_at)
                    ORDER BY reg_num DESC
                    LIMIT 1
                    );

-- Challenge - 3
-- We want to target our inactive users with an email campaign. Find the users who have never posted a photo.
SELECT u.username, p.image_url
FROM users u
LEFT JOIN photos p
ON u.id = p.user_id
WHERE p.created_at IS NULL;

-- We are running a new contest to see who can get the most likes on  SINGLE PHOTO. Who won?
SELECT p.id, p.image_url, COUNT(*) AS total_likes
FROM photos p
INNER JOIN likes l
    ON p.id = l.photo_id
GROUP BY p.id
ORDER BY total_likes DESC
LIMIT 1;

-- Our Investors want to know - How many times does the average user post?
SELECT user_id, AVG(created_at), COUNT(*) as no_posts
FROM photos
GROUP BY user_id;

SELECT 
        ROUND(((SELECT COUNT(*) FROM photos)/(SELECT COUNT(*) FROM users)), 1) AS avg_post;
        

--  A brand wants to know which hastags to use in a post. What are the top 5 most commonly used hashtags?
SELECT t.tag_name, COUNT(*) AS count_flag
FROM photo_tags p
JOIN tags t 
    ON p.tag_id = t.id
GROUP BY t.tag_name
ORDER BY count_flag DESC
LIMIT 5;

-- We have a small problem with bots on our site. Find Users who have liked every single photo on the site.
SELECT u.username, 
        COUNT(*) AS num_likes
FROM users u
INNER JOIN likes l
    ON u.id = l.user_id
GROUP BY l.user_id
HAVING num_likes = (
                    SELECT COUNT(*) FROM photos
                    );    