-- filename: lesson09-homework.sql

-- Практическое задание по теме “Транзакции, переменные, представления”
/* 
 * 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
 * Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
 *  
 */

start transaction;
set session @id := 1;
delete from sample.users where id = @id;
insert into sample.users select * from shop.users where id = @id;
delete from shop.users where id = @id;
select * from shop.users where id = @id;
select * from sample.users where id = @id;
commit;


/* 
 * 2. Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.
 */
create view products_catalogs 
as 
select products.name as product_name, catalogs.name as catalog_name
from products join catalogs 
on products.id = catalogs.id
order by products.name;

prepare get_products_and_catalogs from 'select * from products_catalogs where catalog_name like ?';
set @catalog_search_pattern = '%а%ты';
execute get_products_and_catalogs using @catalog_search_pattern;


/**
 * 3.(по желанию) Пусть имеется таблица с календарным полем created_at. 
 * В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17. 
 * Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует. 
 */

-- При решении исходил из того что дата 2016-08-04 должна выпасть из выборки и для неё должен быть проставлен '0'.
create schema if not exists dz9;
use dz9;
	drop table if exists x;
	create table x ( id serial, created_at date);
	insert into x (created_at) values ('2018-08-01'),('2016-08-04'), ('2018-08-16'),('2018-08-17');

drop temporary table if exists tmp ;
create temporary table tmp (day_of_aug date);
describe tmp;

	set @i = 1;
	insert into tmp
	select str_to_date(concat('2018-08-', @i := @i + 1), '%Y-%c-%e') as day_of_aug
	from information_schema.`COLUMNS` c , ( select @i := 0 ) str
	limit 31;

drop temporary table if exists tmp2 ;
create temporary table tmp2 (day_of_aug date);
insert into tmp2 select distinct created_at as day_of_aug from x;

	select * from tmp; -- 
	select * from tmp2;

select tmp.day_of_aug, 
	   if( tmp2.day_of_aug is null , 0 , 1) as to_be_or_not_to_be 
from tmp
left outer join tmp2 
	on tmp.day_of_aug = tmp2.day_of_aug 
order by tmp.day_of_aug ;
	

 /*
  * 4.(по желанию) Пусть имеется любая таблица с календарным полем created_at. 
  * Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
  * 
  */

-- подготовка данных
create schema if not exists dz9;
use dz9;
	drop table if exists x;
	create table x ( id serial, created_at date);
	truncate table x;
	create or replace view vx as select created_at from x order by created_at desc with check option;
	insert into vx values ('2018-08-01'),('2016-08-04'), ('2019-12-31'),('2018-08-17'),
	                                  ('2017-04-01'),('2019-11-03'), ('2020-01-11'),('2018-11-17');
	drop view if exists vx;

-- вариант 'А'	
select * from x order by created_at desc;         
create or replace algorithm = temptable view top_5 as (select * from x order by created_at desc limit 5);
drop temporary  table if exists tmpx;
create temporary table if not exists tmpx ( id serial, created_at date);
insert into tmpx select * from top_5;
truncate x;
insert into x select * from tmpx;
drop temporary table tmpx;
select * from top_5 order by created_at desc;
drop view top_5;
select * from x order by created_at desc;

	                                 
-- вариант 'Б'	                                 
select count(*) from x;	                  
select * from x order by created_at desc;	                  
drop view if exists  y;
create or replace view y as (select id from x order by created_at desc limit 5);

delete from x where not exists (select id from y where y.id = x.id);
select count(*) from x;
select * from x order by created_at desc;


-- Практическое задание по теме “Администрирование MySQL”

/* 
 * 1. Создайте двух пользователей которые имеют доступ к базе данных shop. 
 * Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
 * второму пользователю shop — любые операции в пределах базы данных shop.
 * 
 */
use shop;
create user if not exists shop_read ;
grant select on shop.* to shop_read;
create user if not exists shop ;
grant all on shop.* to shop_read;

-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"
/* 
 * 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
 * в зависимости от текущего времени суток. С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
 * с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
 * 
 */

-- delimiter //
drop function if exists hello;
create function hello( iv_time time ) returns text deterministic 
begin 
	declare txt text;
	
	if( iv_time >= '06:00:00'     and iv_time < '12:00:00' ) then  
		set txt = 'Доброе утро';  
	elseif( iv_time >= '12:00:00' and iv_time < '18:00:00' ) then
		set txt = 'Добрый день';
	elseif( iv_time >= '18:00:00' and iv_time <= '23:59:59' ) then
		set txt = 'Добрый вечер';
	else
		set txt = 'Доброй ночи';
	end if;
	return txt;
end;


select hello( current_time() ) ;

select hello( '08:03:30' ) ;
select hello( '17:59:59' ) ;
select hello( '21:33:09' ) ;
select hello( '01:15:56' ) ;

/*
 * 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
 * Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
 * Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.
 */
show triggers;
use shop;

select * from products;

insert into products values (8, null, null, 1000, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
delete from products where id = 8;

drop trigger if exists tg_products_name_or_desc_not_null ;

create trigger tg_products_name_or_desc_not_null before insert on products 
for each row begin 
	if( name is null and NEW.description is null ) then 
	  signal sqlstate '45000' set MESSAGE_TEXT = 'INSERT not null.';
	end if;
end;

insert into products values (9, null, null, 1000, 2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
delete from products where id = 9;

show triggers;


/*
 * 3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
 * Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
 * Вызов функции FIBONACCI(10) должен возвращать число 55.
 * */

drop function if exists fib;

create function fib(n int unsigned) returns bigint unsigned deterministic 
begin 
	declare f  bigint unsigned default 1; -- f(n)
	declare f1 bigint unsigned default 1; -- f(n-1)
	declare f2 bigint unsigned default 1; -- f(n-2)
	declare i int    unsigned default 1;
	if( n = 1 or n = 2 ) then
		set f = 1;
	elseif ( n > 2 ) then		
		while i <= n - 2 do			
			set f = f1 + f2;			
			set f2 = f1;
			set f1 = f;
			set i = i + 1;
		end while; 		
	else
		set f = 0;	
	end if;
	return f;
end;


select fib(10);

