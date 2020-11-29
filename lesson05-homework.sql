-- filename: lesson05-homework.sql


-- 01 ����� � ������� users ���� created_at � updated_at ��������� ��������������. ��������� �� �������� ����� � ��������.
use vk;
-- select * from users limit 10; 
update users set created_at = now(), updated_at = now();

/* 
-- 02 ������� users ���� �������� ��������������. ������ created_at � updated_at ���� ������ ����� VARCHAR � � ��� ������ ����� ���������� �������� � ������� 20.10.2017 8:10. 
-- ���������� ������������� ���� � ���� DATETIME, �������� �������� ����� ��������.
-- ����������:

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


/* 3.	� ������� ��������� ������� storehouses_products � ���� value ����� ����������� ����� ������ �����: 
 *      0, ���� ����� ���������� � ���� ����, ���� �� ������ ������� ������. 
 *      ���������� ������������� ������ ����� �������, ����� ��� ���������� � ������� ���������� �������� value. 
 *      ������ ������� ������ ������ ���������� � �����, ����� ���� �������.
*/
/*
-- ����������
use my_world;

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT '����� �������� ������� �� ������',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������ �� ������';
truncate table storehouses_products ;
insert into storehouses_products  (id, value) values (1, 300), (2, 400), (3, 250), (5, 0), (6,100), (7,0);

**/
(select * from storehouses_products where value != 0 order by value )
union 
select * from storehouses_products where value = 0;

/*
 * 4.	(�� �������) �� ������� users ���������� ������� �������������, ���������� � ������� � ���. ������ ������ � ���� ������ ���������� �������� (may, august)
 * 
 */
use vk;
select * from users where lower(date_format(birthday, '%M')) in ('may', 'august');


/* 
 * 5.	(�� �������) �� ������� catalogs ����������� ������ ��� ������ �������. SELECT * FROM catalogs WHERE id IN (5, 1, 2); ������������ ������ � �������, �������� � ������ IN.
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

