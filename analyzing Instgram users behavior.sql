
                                                                                                                                                                                                                                                                                                                                                                                                                             to will WON*/
select users.username, 
       photos.id, 
       photos.image_url,
       count(*) AS Total_likes
from likes 
join photos ON photos.id = likes.photo_id
join users ON users.id = likes.user_id
group by photos.id
order by Total_likes DESC
LIMIT 1;

------------------------------------------------------------------------------------------------------------------------------

/*5.Our Investors want to know- HOw many times does the average user post?(total number of photos/total number of users*/
Select round((select count(*) from photos)/(SELECT COUNT(*) FROM users),2);

-------------------------------------------------------------------------------------------------------------------------------------

/*6.user ranking by posting higher to lower*/
select u.username, 
       COUNT(p.image_url)
from users u
JOIN photos p ON u.id = p.user_id
group by username
order by count(p.image_url) desc ;

------------------------------------------------------------------------------------------------------------------------------
/* 7.TOTAL post by users (longer version of SELECT COUNT(*) FROM photos)*/
SELECT SUM(user_posts.total_posts_per_user)
FROM (SELECT users.username,COUNT(photos.image_url) AS total_posts_per_user 
       FROM users
       JOIN photos ON users.id = photos.user_id
       GROUP BY users.id) AS user_posts;
-----------------------------------------------------------------------------------------------------------------------------------------
/*8.  Total numbers of users who have posted at least one time*/

select count(distinct(users.id)) AS total_number_posts_per_user
from users 
join photos ON users.id = photos.user_id;

---------------------------------------------------------------------------------------------------------------------------------------------

/*9. A brand wants to know which hashtags to use in a post- What are the top 5 most commonly used hashtags?*/
Select tag_name, COUNT(*) as TOTAL
from photo_tags
inner join tags ON tags.id = photo_tags.tag_id
group by tag_id
order by TOTAL desc
LIMIT 5;

--OR
SELECT tag_name, COUNT(tag_name) AS total
FROM tags
JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY total DESC;

---------------------------------------------------------------------------------------------------------------------------------------------
/*10. We have a small problem with bots on our site.. Find users who have liked every single photo on the site*/

select users.id, username,COUNT(users.id) as total_like_by_user
from users 
join likes ON users.id=likes.user_id
group by users.id
having total_like_by_user = (select count(*) from photos);
--OR
select username, count(*)  as number_of_likes
from users
inner join likes ON likes.user_id = users.id
group by likes.user_id
having number_of_likes =(select count(*) from photos);
---------------------------------------------------------------------------------------------------------------------------------------------
/*11. Find a user never comments on a photo*/
select username,comment_text
from users
left join comments ON users.id = comments.user_id
group by users.id
having comment_text IS NULL;

SELECT COUNT(*) FROM
(SELECT username,comment_text
	FROM users
	LEFT JOIN comments ON users.id = comments.user_id
	GROUP BY users.id
	HAVING comment_text IS NULL) AS total_number_of_users_without_comments;

/* OR*/
SELECT 
    COUNT(*) AS total_number_of_users_without_comments
FROM
    (SELECT 
        u.username, c.comment_text
    FROM
       users u
    LEFT JOIN comments c ON u.id = c.user_id
    GROUP BY u.id , c.comment_text
    HAVING comment_text IS NULL) AS users
----------------------------------------------------------------------------------------------------------------------------------------------
/* 12. average number of photos per user (total number pf photos/total number of users)*/
SELECT 
    (SELECT 
            COUNT(*)
        FROM
            photos) / (SELECT 
            COUNT(*)
        FROM
            users) AS Avg_photo_per_user;

SELECT 
    id, photo_id, comments.comment_text, user_id, COUNT(*)
FROM
    comments
GROUP BY photo_id;


/*MEGA CHALLENGES*/
/*12. Are we overrrun with bots and celebrity accounts?
Find the percentage of our users who have either never comments on a photo or have liked on every photo*/

SELECT tableA.total_A AS 'Number Of Users who never commented',
		(tableA.total_A/(SELECT COUNT(*) FROM users))*100 AS '%',
		tableB.total_B AS 'Number of Users who likes every photos',
		(tableB.total_B/(SELECT COUNT(*) FROM users))*100 AS '%'
FROM
	(
		SELECT COUNT(*) AS total_A FROM
			(SELECT username,comment_text
				FROM users
				LEFT JOIN comments ON users.id = comments.user_id
				GROUP BY users.id
				HAVING comment_text IS NULL) AS total_number_of_users_without_comments
	) AS tableA
	JOIN
	(
		SELECT COUNT(*) AS total_B FROM
			(SELECT users.id,username, COUNT(users.id) As total_likes_by_user
				FROM users
				JOIN likes ON users.id = likes.user_id
				GROUP BY users.id
				HAVING total_likes_by_user = (SELECT COUNT(*) FROM photos)) AS total_number_users_likes_every_photos
	)AS tableB;
    
/*13. Find users who have ever commented on a photo*/
SELECT username, comment_text
from users
left JOIN comments ON users.id = comments.user_id
GROUP BY users.id
HAVING comment_text IS NOT NULL;


/*14. The number of photos posted by most active users*/

SELECT 
	u.username AS 'Username',
    COUNT(p.image_url) AS 'Number of Posts'
FROM
  users u
        JOIN
  photos p ON u.id = p.user_id
GROUP BY u.id
ORDER BY 2 DESC
LIMIT 5;


/*15. The most popular tag names by likes*/

SELECT 
    t.tag_name AS 'Tag Name',
    COUNT(l.photo_id) AS 'Number of Likes'
FROM
    photo_tags pt
        JOIN
   likes l ON l.photo_id = pt.photo_id
        JOIN
    tags t ON pt.tag_id = t.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;



/* The average time on the platform */

SELECT 
    ROUND(AVG(DATEDIFF(CURRENT_TIMESTAMP, created_at)/360), 2) as Total_Years_on_Platform
FROM
   users;
   
   
   ---------------------------------------------------------------------------------------------------------------------------------------------
  
