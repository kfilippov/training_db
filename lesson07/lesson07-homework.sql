-- filename : lesson06-homework.sql  
-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение. Агрегация данных”
-- Работаем с БД vk и тестовыми данными, которые вы сгенерировали ранее:

/* 
 *  1.	Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
 */
insert into orders (user_id) values ( 3);
SELECT users.id FROM users inner join orders on users.id = orders.id;


/* 
 * 2.	Выведите список товаров products и разделов catalogs, который соответствует товару.
 */
select p.id, p.name, c.id, c.name 
from products p 
left join catalogs c 
on p.catalog_id  = c.id;


/* 
 * 3.	(по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
 * Поля from, to и label содержат английские названия городов, поле name — русское. 
 * Выведите список рейсов flights с русскими названиями городов.
 */

drop table if exists flights;

drop table if exists cities;

create table if not exists flights ( id serial primary key, city_from varchar(100), city_to varchar(100) ) ;

create table if not exists cities  ( label varchar(100), name varchar(100) ) ;

insert into flights (city_from, city_to) values 
('moscow', 'omsk')
, ('novgorod', 'kazan')
, ('irkutsk', 'moscow')
, ('omsk', 'irkutsk')
, ('moscow', 'kazan');

insert into cities (label, name) values
  ('moscow', 'Москва')
, ('irkutsk', 'Иркутск')
, ('novgorod', 'Новгород')
, ('kazan', 'Казань')
, ('omsk', 'Омск');

select f.id, c1.name as 'from', c2.name as 'to'
from flights f
left join cities c1 on f.city_from = c1.label
left join cities c2 on f.city_to   = c2.label;

