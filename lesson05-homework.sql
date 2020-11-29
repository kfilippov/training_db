-- filename: lesson05-homework.sql


-- 01 Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
use vk;
-- select * from users limit 10; 
update users set created_at = now(), updated_at = now();

/* 
-- 02 Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
-- Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
-- подготовка:

-- select distinct updated_at, created_at from users;
-- select distinct DATE_FORMAT(STR_TO_DATE(created_at, '%Y-%c-%d %H:%i:%s'), '%d.%c.%Y %h:%i')  from users;

alter table users modify column created_at varchar(100);
update users set created_at  = DATE_FORMAT(STR_TO_DATE(created_at, '%Y-%c-%d %H:%i:%s'), '%d.%c.%Y %h:%i')  ;

alter table users modify column updated_at varchar(100);
update users set updated_at  = DATE_FORMAT(STR_TO_DATE(updated_at, '%Y-%c-%d %H:%i:%s'), '%d.%c.%Y %h:%i')  ;

*/
update
	users
set
	created_at = DATE_FORMAT(STR_TO_DATE(created_at, '%d.%c.%Y %h:%i'), '%Y-%c-%d %H:%i:%s') ;
alter table users modify column created_at datetime default now();

update users set updated_at  = DATE_FORMAT(STR_TO_DATE(updated_at, '%d.%c.%Y %h:%i'), '%Y-%c-%d %H:%i:%s')  ;
alter table users modify column updated_at datetime default now();

select distinct updated_at, created_at from users;


/* 3.	В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
 *      0, если товар закончился и выше нуля, если на складе имеются запасы. 
 *      Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
 *      Однако нулевые запасы должны выводиться в конце, после всех записей.
*/
/*
-- подготовка
use my_world;

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';
truncate table storehouses_products ;
insert into storehouses_products  (id, value) values (1, 300), (2, 400), (3, 250), (5, 0), (6,100), (7,0);

**/
(select * from storehouses_products where value != 0 order by value )
union 
select * from storehouses_products where value = 0;

/*
 * 4.	(по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august)
 * 
 */
use vk;
select * from users where lower(date_format(birthday, '%M')) in ('may', 'august');


/* 
 * 5.	(по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
 * 
 */
use my_world;
select
	*
from
	catalogs
where
	id in(5,
	1,
	2)
order by
	case
		id when 5 then 1
		when 1 then 2
		when 2 then 3
	end asc ;


-- ++