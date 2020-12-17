use dz11; -- shop

/* 
 * 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs 
 * помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.
 */

drop table if exists logs ;
create table logs ( created_at datetime
                  , tablename  char(64)
                  , id bigint
                  , name varchar(255)
                  ) engine = Archive ;

drop trigger if exists tg_archive_users; 
create trigger tg_archive_users after insert on users 
for each row 
begin 
	insert into logs values (now(), 'users', new.id, new.name) ;
end;

drop trigger if exists tg_archive_catalogs; 
create trigger tg_archive_catalogs after insert on catalogs 
for each row 
begin 
	insert into logs values (now(), 'catalogs', new.id, new.name) ;
end;

drop trigger if exists tg_archive_products; 
create trigger tg_archive_products after insert on products 
for each row 
begin 
	insert into logs values (now(), 'products', new.id, new.name) ;
end;

insert into users (name) values ('Jeff D');
insert into products (name) values ('new product!!!');
insert into catalogs (name) values ('new catal+');
select * from logs;

/*
 * 2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
 */
drop procedure if exists sp_add_million_users;
create procedure sp_add_million_users()
begin 
	declare i int default 0;
	m: loop
		set i = i + 1;
		if ( i > 1000000 ) then
			leave m;
		else 
			insert into users(name) values ( concat('User-#', i ) ); 			
		end if;					
	end loop m; 	 
end;

call sp_add_million_users();


/* Практическое задание по теме “NoSQL”
 * 1. В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов. 
 */
-- > set  "192.168.1.1" 1
-- > incr "192.168.1.1"
-- > get  "192.168.1.1"

/*
 * 2. При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, поиск электронного адреса пользователя по его имени. 
 */
-- > hset db ivan i@mail.ru
-- > hset db petr p@mail.ru 
-- > hget db ivan 
-- > hscan db 0 match "*"


/* 
 *3. Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB.
 */
/*
db.shop.insert({
catalogs : 
  [ 
    { id: 1, name: "Процессоры" },
    { id: 2, name: "Материнские платы"}, 
    { id: 3, name: "Видеокарты"},
    { id: 4, name: "Жесткие диски"}, 
    { id: 5, name: "Оперативная память"} 
   ]
 ,  
 products :
  [ 
	{ id: "1", name:"Intel Core i3-8100", description: "Процессор для настольных персональных компьютеров, основанных на платформе Intel.  ", price: "7890", catalog_id:  "1", created_at : "2020-12-15 23:57:41", updated_at :"2020-12-15 23:57:41" },
	{ id: "2", name:"Intel Core i5-7400", description: "Процессор для настольных персональных компьютеров, основанных на платформе Intel.  ", price: "12700", catalog_id: "1", created_at : "2020-12-15 23:57:41", updated_at :"2020-12-15 23:57:41" },
	{ id: "3", name:"AMD FX-8320E", description: "Процессор для настольных персональных компьютеров, основанных на платформе AMD.          ", price: "4780", catalog_id:  "1", created_at : "2020-12-15 23:57:41", updated_at :"2020-12-15 23:57:41" },
	{ id: "4", name:"AMD FX-8320", description: "Процессор для настольных персональных компьютеров, основанных на платформе AMD.           ", price: "7120", catalog_id:  "1", created_at : "2020-12-15 23:57:41", updated_at :"2020-12-15 23:57:41" },
	{ id: "5", name:"ASUS ROG MAXIMUS X HERO", description: "Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX    ", price: "19310", catalog_id: "2", created_at : "2020-12-15 23:57:41", updated_at :"2020-12-15 23:57:41" },
	{ id: "6", name:"Gigabyte H310M S2H", description: "Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX             ", price: "4790", catalog_id:  "2", created_at : "2020-12-15 23:57:41", updated_at :"2020-12-15 23:57:41" },
	{ id: "7", name:"MSI B250M GAMING PRO ", description: "Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX           ", price: "5060", catalog_id:  "2", created_at : "2020-12-15 23:57:41", updated_at :"2020-12-15 23:57:41" }
  ]
})

*/







