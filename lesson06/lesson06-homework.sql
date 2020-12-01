-- filename : lesson06-homework.sql  
-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”
-- Работаем с БД vk и тестовыми данными, которые вы сгенерировали ранее:

/* 
 * 1.	Проанализировать запросы, которые выполнялись на занятии, определить возможные корректировки и/или улучшения (JOIN пока не применять).
*/
-- -- --

/* 
 * 2.	Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
*/
-- insert into messages values( null, 1, 5, 'Бен, это Данила',  1, CURRENT_TIMESTAMP);
-- insert into messages values( null, 1, 5, 'Ben, I need help', 1, CURRENT_TIMESTAMP);

-- dbeaver параметр
select to_user_id from messages where from_user_id = :1 group by to_user_id having count(*) > 0 order by count(*) desc limit 1;

-- пользователь с id = 1
select to_user_id from messages where from_user_id = '1' group by to_user_id having count(*) > 0 order by count(*) desc limit 1;


/* 
*3.	Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
*/ 
with youngsters as ( select id from users order by birthday desc limit 10 )
select sum(likes_no) as 'Количество лайков 10 самых молодых пользователей:'
	from ( 
		select count(*) as likes_no from youngsters inner join photos_likes   on youngsters.id = photos_likes.user_id   group by user_id
		union all
		select count(*) as likes_no from youngsters inner join posts_likes    on youngsters.id = posts_likes.user_id    group by user_id
		union all
		select count(*) as likes_no from youngsters inner join comments_likes on youngsters.id = comments_likes.user_id group by user_id
	) a ;

select * from photos_likes where user_id in('14','33')
union all
select * from posts_likes where user_id in('14','33')
union all
select * from comments_likes where user_id in('14','33');


/* 
*4.	Определить кто больше поставил лайков (всего) - мужчины или женщины?
*/
use vk;

with tab as (
	select gender, sum(likes_no) as likes_no 
	from
	(   select user_id, gender, sum( likes_no ) as likes_no from (
		select user_id, count(*) as likes_no from  photos_likes group by user_id
		union all
		select user_id, count(*) as likes_no from  posts_likes group by user_id
		union all
		select user_id, count(*) as likes_no from  comments_likes group by user_id
	) a join users on user_id = users.id  group by user_id, gender ) b
	group by gender
) 
select if( sum(man) > sum(woman) , 'мужчины' , if (sum(man) < sum(woman) , 'женщины', 'лайков мужчины и женщины сделали поровну')) as 'Больше лайков поставили: '
from ( 
	select sum(man) as man , sum(woman) as woman from ( 
		select likes_no as man, 0 as woman from tab where gender = 'm'
		union 
		select 0 as man, likes_no as woman from tab where gender = 'f' ) a
) c
;


/* 
*5.	Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
*/
select  id, firstname, lastname	  	  
from users
order by 
(       
		(select count(*) from comments 			 where user_id           = id) 			
	  + (select count(*) from friend_requests    where initiator_user_id = id) 	
	  + (select count(*) from messages  		 where from_user_id      = id)		
	  + (select count(*) from photos 			 where user_id           = id) 
	  + (select count(*) from posts 			 where user_id           = id) 
	  + (select count(*) from user_communities	 where user_id           = id) 
)
asc limit 10;
	   

