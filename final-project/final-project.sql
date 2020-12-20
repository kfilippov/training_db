-- filename: final-project.sql
/*
 * Требования к курсовому проекту:
 * 1. Составить общее текстовое описание БД и решаемых ею задач;
 */

/*
 * -- ОПИСАНИЕ --
 *  
 * Система управления клиентами (CRM).
 * Основные цели БД:
 * - хранить данные о клиентах и контактах с ними;
 * - помогать компании конвертировать потребности клиентов в договора;
 * - контроллировать и повышать эффективность команды, работающей с клиентами.
 * 
 */
drop database if exists  crm;
create database crm;
use crm;

/*
 * 2. Минимальное количество таблиц - 10;
 * Таблицы:
 * -- 01: employees      - сотрудники команды продаж
 * -- 02: products       - продукты и услуги
 * -- 03: customers      - клиенты
 * -- 04: leads          - контакты потенциальных (либо существующих) клиентов, например полученные в ходе рекламной кампании
 * -- 05: lead_photos    - фотографии лидов
 * -- 06: calls          - взаимодействия c потенциальными (либо существующими) клиентами 
 * -- 07: cases          - задачи клиентов/тендеры, в рамках которых возможна продажа услуг/продуктов
 * -- 08: cases_products - продукты, которые может закупить клиент в рамках кейса
 * -- 09: cases_leads    - лиды, связанные с закрытие кейса/тендера
 * -- 10: campain        - рекламная/промо-кампания
 * 
 *
 * 3. скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами);
 */

-- 01
drop table if exists employees;
create table if not exists employees(
	id 		   serial,
	title      enum('Mr.', 'Dr.', 'Mrs.', 'Ms', 'Phd', ''),
	name 	   varchar(128),
	email      varchar(64) unique,
	phone      varchar(64),
	birthday   date,
	created_at datetime default now(),
	updated_at datetime,	
	primary key(id)	
) comment 'сотрудники команды продаж';

-- 02 
drop table if exists products;
create table if not exists products (
	id 	  	    serial,
	name        varchar(64),
	description text,
	price       float,
 	updated_at  datetime default now(),
	primary key(id)	
) comment 'продукты и услуги';

-- 03
drop table if exists customers;
create table if not exists customers(
	id 		          serial,
	industry          varchar(64), 
	employees         bigint unsigned,
	website           varchar(64),
	owner_id          bigint unsigned not null comment 'Аккаунт-менеджер клиента',	
	-- no_of_leads       
	-- no_of_cases         	
	primary key(id),
	foreign key(owner_id) references employees(id)
) comment 'клиенты';

-- 04
drop table if exists leads;
create table if not exists leads(
	id 		          serial,
	customer_id       bigint unsigned not null comment 'Компания-клиент',	
	lead_owner_id     bigint unsigned not null comment 'Владелец лида',	
	lead_photo_id     bigint unsigned comment 'Фотография',	
	name 	          varchar(64),
	title             enum('Mr.', 'Dr.', 'Mrs.', 'Ms', 'Phd', ''),
	email      		  varchar(64) unique,
	phone        	  varchar(64),	
	created_at        datetime default now(),
	is_decision_maker bool,
	is_converted      bool default 0,	
	converted_on      date default '9999-12-31',	
	primary key(id),
	foreign key(customer_id) references customers(id),
	foreign key(lead_owner_id) references employees(id)	
) comment 'контакты потенциальных (либо существующих) клиентов, например полученные в ходе рекламной кампании';


-- 05
drop table if exists lead_photos;
create table if not exists lead_photos(
	id serial,
	lead_id bigint unsigned not null,
	filename varchar(100),
	description text,
	created_at datetime default now(),
	primary key(id),
	foreign key(lead_id) references leads(id)	
) comment 'фотографии лидов';

-- 06
drop table if exists calls;
create table if not exists calls(
	id 		           serial,
	lead_id     	   bigint unsigned not null ,	
	employee_id        bigint unsigned not null ,
	callback_on        datetime,
	communication_type enum('Phone', 'Mobile', 'Email', 'Skype', 'Zoom', 'Whatsapp'),
	note               text,
	is_completed       bool default 0,	
	primary key(id),
	foreign key(lead_id) references leads(id)	
) comment 'взаимодействия c потенциальными (либо существующими) клиентами';

-- 07
drop table if exists cases;
create table if not exists cases(
	id 		           serial,
	customer_id        bigint unsigned not null ,	
	employee_id        bigint unsigned not null ,
	description        text,
	due_date           date,
	is_completed       bool default 0,	
	is_service_case    bool default 0,	
	primary key(id),
	foreign key(customer_id) references customers(id),
	foreign key(employee_id) references employees(id)	
) comment 'задачи клиентов/тендеры, в рамках которых возможна продажа услуг/продуктов';

-- 08
drop table if exists cases_products ;
create table cases_products (
	id            serial,
	case_id       bigint unsigned not null,
	product_id    bigint unsigned not null,	
	state         boolean,
	primary key(id),
	foreign key (case_id) references cases(id),
	foreign key (product_id) references products(id)
) comment 'продукты, которые может закупить клиент в рамках кейса';

-- 09
drop table if exists cases_leads ;
create table cases_leads (
	id serial,
	case_id    bigint unsigned not null,
	lead_id    bigint unsigned not null,	
	state      boolean,
	primary key(id),
	foreign key (case_id) references cases(id),
	foreign key (lead_id) references leads(id)
) comment 'лиды, связанные с закрытие кейса/тендера';

-- 10 
drop table if exists campain;
create table campain (
	id          serial,
	employee_id bigint unsigned not null, 
	starts_on   date,
	ends_on     date,
	state       boolean,
	primary key(id),
	foreign key (employee_id) references employees(id)
) comment 'рекламная/промо-кампания';


/*
 * 4. создать ERDiagram для БД; 
 */
-- -- -- см. KP.docx -- -- -- 


/*
 * 5. скрипты наполнения БД данными; 
 */
INSERT INTO `employees` (`id`, `title`, `name`, `email`, `phone`, `birthday`, `created_at`, `updated_at`) VALUES ('1', 'Mrs.', 'Adalberto Lang V', 'lloyd08@example.net', '+7-300-206-9702', '2020-03-10', '1979-11-20 13:53:24', '1983-04-09 06:23:54');
INSERT INTO `employees` (`id`, `title`, `name`, `email`, `phone`, `birthday`, `created_at`, `updated_at`) VALUES ('2', 'Mr.', 'Carolanne Volkman Sr.', 'tstark@example.net', '+7-03108043485', '1999-04-15', '1982-03-23 16:41:41', '2018-09-23 09:01:58');
INSERT INTO `employees` (`id`, `title`, `name`, `email`, `phone`, `birthday`, `created_at`, `updated_at`) VALUES ('3', 'Mr.', 'Chelsea Predovic', 'christy80@example.net', '+7-839.042.4120', '1980-02-24', '1991-09-14 19:03:32', '1985-09-07 20:36:36');
INSERT INTO `employees` (`id`, `title`, `name`, `email`, `phone`, `birthday`, `created_at`, `updated_at`) VALUES ('4', 'Ms', 'Guadalupe Ankunding', 'leatha.bednar@example.com', '+1-623-850-1485', '1981-05-05', '1994-09-13 14:01:00', '2005-06-11 00:23:33');
INSERT INTO `employees` (`id`, `title`, `name`, `email`, `phone`, `birthday`, `created_at`, `updated_at`) VALUES ('5', 'Phd', 'Frederik Streich', 'rasheed.walsh@example.org', '+361.178.6090', '1988-09-03', '2011-07-03 00:28:55', '1984-11-18 17:46:22');
INSERT INTO `employees` (`id`, `title`, `name`, `email`, `phone`, `birthday`, `created_at`, `updated_at`) VALUES ('6', 'Mrs.', 'Billie Daniel', 'dgreenfelder@example.net', '+486-045-1245x92048', '1983-09-20', '2005-06-28 00:59:05', '1978-03-22 09:04:48');
INSERT INTO `employees` (`id`, `title`, `name`, `email`, `phone`, `birthday`, `created_at`, `updated_at`) VALUES ('7', 'Phd', 'Ila Considine V', 'shauck@example.com', '+1-554-202-3277x96974', '1995-07-20', '1988-09-07 06:42:27', '1991-09-02 19:21:47');

INSERT INTO `products` (`id`, `name`, `description`, `price`, `updated_at`) VALUES ('1', 'Тренинг', 'Eaque veniam rerum officiis facere recusandae ut minima. Necessitatibus neque minus doloremque dicta et.', '250300', '1990-06-28 16:00:13');
INSERT INTO `products` (`id`, `name`, `description`, `price`, `updated_at`) VALUES ('2', 'Разработка', 'Neque corporis facere ab. Nesciunt quod necessitatibus cupiditate et in tempore. Est aut possimus nihil non consectetur occaecati.', '200100', '2002-06-29 14:10:42');
INSERT INTO `products` (`id`, `name`, `description`, `price`, `updated_at`) VALUES ('3', 'Лицензия', 'Minus perspiciatis repellat et veritatis. Placeat consequatur consequatur in adipisci id. Perferendis exercitationem et quibusdam. Rerum nam velit et.', '3003000', '1997-08-22 00:19:39');
INSERT INTO `products` (`id`, `name`, `description`, `price`, `updated_at`) VALUES ('4', 'Консультация', 'Rerum nostrum ut sit accusamus quidem soluta. Corporis non illo voluptas laborum aut molestiae. Doloribus qui aliquam aut eos.', '43000', '1984-04-30 18:37:02');
INSERT INTO `products` (`id`, `name`, `description`, `price`, `updated_at`) VALUES ('5', 'ПОддержка', 'Qui debitis omnis eveniet repudiandae eius. Eos illo rerum ullam ea excepturi. Facilis voluptates ea et voluptatem temporibus tenetur velit numquam. Quo deserunt minus aliquid.', '150900', '1978-12-25 01:42:25');

INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('1', 'metzondricka', '4', 'http://metzondricka.net/', '1');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('2', 'kautzer', '367235446', 'http://kautzer.net/', '2');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('3', 'romaguera', '0', 'http://www.romaguera.biz/', '3');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('4', 'kilback', '66', 'http://kilback.com/', '4');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('5', 'feil', '21473238', 'http://feil.org/', '5');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('6', 'doyle', '869937', 'http://doyle.biz/', '6');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('7', 'lynch', '5780798', 'http://lynch.org/', '7');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('8', 'dickens', '162', 'http://www.dickens.com/', '1');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('9', 'kertzmannbashirian', '0', 'http://www.kertzmannbashirian.com/', '2');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('10', 'abernathy', '4738306', 'http://abernathy.com/', '3');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('11', 'yost', '9', 'http://yost.com/', '4');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('12', 'kingstehr', '149', 'http://www.kingstehr.org/', '5');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('13', 'paucekpredovic', '9', 'http://www.paucekpredovic.com/', '6');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('14', 'ratkerunolfsson', '0', 'http://www.ratkerunolfsson.net/', '7');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('15', 'hoeger', '336', 'http://www.hoeger.biz/', '1');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('16', 'mitchellcarter', '6', 'http://www.mitchellcarter.com/', '2');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('17', 'kihndaniel', '52', 'http://kihndaniel.com/', '3');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('18', 'parkerconroy', '0', 'http://www.parkerconroy.com/', '4');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('19', 'dibbert', '0', 'http://www.dibbert.org/', '5');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('20', 'jaskolskiwaelchi', '4120509', 'http://jaskolskiwaelchi.info/', '6');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('21', 'gaylordkilback', '544368', 'http://www.gaylordkilback.info/', '7');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('22', 'littlefarrell', '94216116', 'http://www.littlefarrell.org/', '1');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('23', 'christiansen', '0', 'http://www.christiansen.biz/', '2');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('24', 'lindgren', '694931355', 'http://lindgren.net/', '3');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('25', 'bednar', '5', 'http://www.bednar.biz/', '4');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('26', 'hartmannzemlak', '37177645', 'http://www.hartmannzemlak.com/', '5');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('27', 'skiles', '657794', 'http://www.skiles.net/', '6');
INSERT INTO `customers` (`id`, `industry`, `employees`, `website`, `owner_id`) VALUES ('28', 'greenfelder', '210949128', 'http://www.greenfelder.com/', '7');

INSERT INTO `leads` (`id`, `customer_id`, `lead_owner_id`, `lead_photo_id`, `name`, `title`, `email`, `phone`, `created_at`, `is_decision_maker`, `is_converted`, `converted_on`) VALUES ('1', '1', '1', '39039', 'Prof. Torey Ullrich', 'Ms', 'claude02@example.net', '+41(6)2592693126', '1986-03-26 02:18:31', 1, 1, '2005-09-11');
INSERT INTO `leads` (`id`, `customer_id`, `lead_owner_id`, `lead_photo_id`, `name`, `title`, `email`, `phone`, `created_at`, `is_decision_maker`, `is_converted`, `converted_on`) VALUES ('2', '2', '2', '2073112', 'Dayna Rau', '', 'gcole@example.com', '009.952.4959x97873', '2017-07-24 09:57:28', 1, 1, '1983-06-03');
INSERT INTO `leads` (`id`, `customer_id`, `lead_owner_id`, `lead_photo_id`, `name`, `title`, `email`, `phone`, `created_at`, `is_decision_maker`, `is_converted`, `converted_on`) VALUES ('3', '3', '3', '4', 'Prof. Elisabeth Kub IV', 'Mrs.', 'sylvia74@example.org', '05116417017', '2015-02-19 18:29:15', 1, 1, '1983-07-28');
INSERT INTO `leads` (`id`, `customer_id`, `lead_owner_id`, `lead_photo_id`, `name`, `title`, `email`, `phone`, `created_at`, `is_decision_maker`, `is_converted`, `converted_on`) VALUES ('4', '4', '4', '451', 'Dr. Cali Thiel', '', 'alycia.little@example.net', '011-124-8743x33451', '2015-12-15 14:03:17', 1, 0, '2001-06-10');
INSERT INTO `leads` (`id`, `customer_id`, `lead_owner_id`, `lead_photo_id`, `name`, `title`, `email`, `phone`, `created_at`, `is_decision_maker`, `is_converted`, `converted_on`) VALUES ('5', '5', '5', '623970', 'Lacy Pfeffer DVM', 'Mrs.', 'dawn30@example.com', '09816309230', '1977-05-21 20:44:37', 0, 0, '2020-03-13');
INSERT INTO `leads` (`id`, `customer_id`, `lead_owner_id`, `lead_photo_id`, `name`, `title`, `email`, `phone`, `created_at`, `is_decision_maker`, `is_converted`, `converted_on`) VALUES ('6', '6', '6', '38116', 'Pablo McDermott', '', 'presley98@example.net', '04593165008', '1981-08-13 02:50:31', 1, 0, '1994-03-07');
INSERT INTO `leads` (`id`, `customer_id`, `lead_owner_id`, `lead_photo_id`, `name`, `title`, `email`, `phone`, `created_at`, `is_decision_maker`, `is_converted`, `converted_on`) VALUES ('7', '7', '7', '21562941', 'Preston Connelly', 'Mr.', 'heaven24@example.net', '1-770-226-5492x570', '2006-02-16 05:47:51', 0, 1, '1993-03-29');
INSERT INTO `leads` (`id`, `customer_id`, `lead_owner_id`, `lead_photo_id`, `name`, `title`, `email`, `phone`, `created_at`, `is_decision_maker`, `is_converted`, `converted_on`) VALUES ('8', '8', '1', '5123', 'Mrs. Christiana Volkman', 'Ms', 'abbigail.pagac@example.org', '+92(4)6343275888', '1975-06-02 01:13:32', 1, 1, '1973-05-23');
INSERT INTO `leads` (`id`, `customer_id`, `lead_owner_id`, `lead_photo_id`, `name`, `title`, `email`, `phone`, `created_at`, `is_decision_maker`, `is_converted`, `converted_on`) VALUES ('9', '9', '2', '4331', 'Mr. Sigurd Daniel IV', 'Phd', 'eusebio.larkin@example.com', '01497607443', '2010-09-22 00:42:17', 0, 0, '1992-09-02');
INSERT INTO `leads` (`id`, `customer_id`, `lead_owner_id`, `lead_photo_id`, `name`, `title`, `email`, `phone`, `created_at`, `is_decision_maker`, `is_converted`, `converted_on`) VALUES ('10', '10', '3', '159368695', 'Dr. Gavin Eichmann', 'Ms', 'kuvalis.jermaine@example.net', '833-077-5522', '1996-03-24 20:35:56', 0, 0, '2010-02-21');
INSERT INTO `leads` (`id`, `customer_id`, `lead_owner_id`, `lead_photo_id`, `name`, `title`, `email`, `phone`, `created_at`, `is_decision_maker`, `is_converted`, `converted_on`) VALUES ('11', '11', '4', '23680858', 'Jackie Torp', 'Mr.', 'alexane.hoeger@example.org', '(790)132-7413', '1999-03-14 10:35:50', 0, 0, '1986-03-09');
INSERT INTO `leads` (`id`, `customer_id`, `lead_owner_id`, `lead_photo_id`, `name`, `title`, `email`, `phone`, `created_at`, `is_decision_maker`, `is_converted`, `converted_on`) VALUES ('12', '12', '5', '8911', 'Dejah Wisoky', 'Dr.', 'serenity86@example.com', '980-535-6939', '1981-12-13 01:24:33', 0, 0, '2012-04-11');
INSERT INTO `leads` (`id`, `customer_id`, `lead_owner_id`, `lead_photo_id`, `name`, `title`, `email`, `phone`, `created_at`, `is_decision_maker`, `is_converted`, `converted_on`) VALUES ('13', '13', '6', '583522784', 'Cordelia Casper', 'Mrs.', 'leonardo40@example.com', '552.764.0390x6561', '2017-02-08 10:27:39', 0, 1, '1978-04-27');
INSERT INTO `leads` (`id`, `customer_id`, `lead_owner_id`, `lead_photo_id`, `name`, `title`, `email`, `phone`, `created_at`, `is_decision_maker`, `is_converted`, `converted_on`) VALUES ('14', '14', '7', '36355655', 'Eliezer Sawayn', 'Phd', 'darrin.schmeler@example.net', '(844)527-9753x909', '2008-10-03 06:42:24', 0, 0, '1991-05-27');


INSERT INTO `calls` (`id`, `lead_id`, `employee_id`, `callback_on`, `communication_type`, `note`, `is_completed`) VALUES ('1', '1', '1', '2019-06-26 22:06:35', 'Phone', 'Ut quis amet ut dolore. Deleniti beatae non eaque consequatur incidunt.', 1);
INSERT INTO `calls` (`id`, `lead_id`, `employee_id`, `callback_on`, `communication_type`, `note`, `is_completed`) VALUES ('2', '2', '2', '1974-01-12 14:34:05', 'Whatsapp', 'Aut non recusandae sit natus. Exercitationem corporis blanditiis alias earum cum. Magni sit est et in doloremque.', 0);
INSERT INTO `calls` (`id`, `lead_id`, `employee_id`, `callback_on`, `communication_type`, `note`, `is_completed`) VALUES ('3', '3', '3', '2011-01-20 10:23:44', 'Email', 'Omnis aliquid ut ut consequatur qui. Occaecati distinctio voluptas cupiditate sapiente et consequuntur consequatur. Nisi omnis dolor molestiae enim temporibus provident tempore voluptatem.', 1);
INSERT INTO `calls` (`id`, `lead_id`, `employee_id`, `callback_on`, `communication_type`, `note`, `is_completed`) VALUES ('4', '4', '4', '2018-09-01 18:58:13', 'Whatsapp', 'Minima laboriosam atque veritatis nulla cupiditate impedit. Voluptatem neque dicta et nisi incidunt odio voluptatem qui. Enim rerum sapiente natus aspernatur perferendis. Sapiente cumque pariatur non minima soluta.', 1);
INSERT INTO `calls` (`id`, `lead_id`, `employee_id`, `callback_on`, `communication_type`, `note`, `is_completed`) VALUES ('5', '5', '5', '2019-07-25 20:13:08', 'Mobile', 'Nam id aut autem ex aliquam vel quis. Veniam magni sed omnis et est neque. Voluptatem laborum tempore reprehenderit voluptas assumenda.', 1);
INSERT INTO `calls` (`id`, `lead_id`, `employee_id`, `callback_on`, `communication_type`, `note`, `is_completed`) VALUES ('6', '6', '6', '1990-07-28 02:21:50', 'Skype', 'Aut sapiente expedita sed sint. Architecto qui ut dolorum voluptas dignissimos suscipit nihil. Quam odit dignissimos est dignissimos quia. Aut esse ut at ut labore.', 1);
INSERT INTO `calls` (`id`, `lead_id`, `employee_id`, `callback_on`, `communication_type`, `note`, `is_completed`) VALUES ('7', '7', '7', '2006-10-01 16:46:25', 'Skype', 'Asperiores quis corporis impedit id consequatur. Quibusdam modi labore beatae distinctio non omnis ea. Cum laudantium earum autem quae. Est amet neque aut.', 1);
INSERT INTO `calls` (`id`, `lead_id`, `employee_id`, `callback_on`, `communication_type`, `note`, `is_completed`) VALUES ('8', '8', '1', '1997-12-05 11:48:34', 'Phone', 'Qui cupiditate non distinctio minus iusto. Nam voluptate sed ea. Magni eum omnis tenetur nemo. Nulla sed et et qui.', 1);
INSERT INTO `calls` (`id`, `lead_id`, `employee_id`, `callback_on`, `communication_type`, `note`, `is_completed`) VALUES ('9', '9', '2', '2002-07-26 05:51:36', 'Zoom', 'Ipsam perferendis non explicabo illo eos pariatur ut et. Laudantium eos ut dolores quasi. Ea corrupti deleniti ipsum pariatur et. Rerum porro inventore nulla atque harum.', 1);
INSERT INTO `calls` (`id`, `lead_id`, `employee_id`, `callback_on`, `communication_type`, `note`, `is_completed`) VALUES ('10', '10', '3', '1970-09-28 20:45:27', 'Email', 'Architecto non aut omnis quia dicta voluptates molestiae. Eveniet quis ut est cumque repellendus ea voluptate sit. Id et laborum veritatis consequuntur. Nisi necessitatibus voluptas magni.', 0);


INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('1', '1', '1', 'Et molestiae dolores voluptatem et pariatur. Voluptas nam qui esse. Officia esse voluptas qui. Vel corporis ad fugiat aut nihil eum vitae cum.', '2013-09-12', 1, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('2', '2', '2', 'Soluta velit consequatur soluta facilis. Rerum ipsa quo voluptatibus modi tempore in sit. In ex facere exercitationem ipsum id voluptatum omnis iure.', '1994-11-16', 0, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('3', '3', '3', 'Blanditiis accusamus deserunt est et iusto natus. Hic tempora dolore est.', '2010-07-09', 0, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('4', '4', '4', 'Non quisquam adipisci debitis ipsum soluta voluptas et. Doloremque aut ut numquam reiciendis qui aperiam debitis. Commodi ab commodi voluptatem sunt exercitationem perferendis. Laudantium animi totam enim recusandae voluptates doloribus.', '2003-07-19', 0, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('5', '5', '5', 'Minima error deleniti sed deleniti. Exercitationem enim distinctio laudantium. Maxime quasi quo veniam consequatur iusto nobis.', '1979-05-10', 1, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('6', '6', '6', 'Sit aut dignissimos distinctio mollitia quia aperiam laudantium. Ipsa unde illum enim est libero corrupti. Molestiae delectus sit beatae consequatur maxime iusto assumenda. Aliquid assumenda quod et explicabo. Nihil quisquam laudantium ut omnis corporis ex.', '2010-01-15', 1, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('7', '7', '7', 'Molestiae et recusandae nam doloribus ea officia fugit. Omnis repudiandae vel illo qui enim. Voluptatem voluptas sit quia quod sunt modi beatae.', '1984-06-18', 0, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('8', '8', '1', 'Placeat id repudiandae rerum dolorum tenetur. Aut qui omnis eveniet expedita. Delectus est temporibus commodi amet molestiae. Animi ut qui voluptatibus rerum ut. Consequuntur minima quaerat rem enim non est.', '1983-09-06', 0, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('9', '9', '2', 'Qui ab nobis quia aperiam. Odio et debitis omnis. Laudantium harum blanditiis alias assumenda.', '1984-09-07', 0, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('10', '10', '3', 'Cumque sint voluptas dicta nesciunt. Sint ut repellat beatae dolor qui optio. Soluta unde provident rem magni ratione non culpa. Repellat explicabo sed dolorem qui non quos.', '2000-02-01', 0, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('11', '11', '4', 'Possimus dolore eius eveniet voluptate. Porro quod et ipsa facilis rerum. Et sit quaerat soluta similique.', '1975-03-25', 1, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('12', '12', '5', 'Molestiae perspiciatis ea et quia. Asperiores perferendis dolore atque dolores aut sit. Et itaque consequatur assumenda delectus quasi aut.', '1979-05-10', 1, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('13', '13', '6', 'Suscipit eos quasi voluptatem cum ea. Sed odit dolor officia est vel. Quia et modi consectetur.', '2017-11-08', 1, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('14', '14', '7', 'Debitis porro quo voluptatem dolores. Ipsum suscipit nisi enim dolorem sit. Esse sint et aliquid molestias quam.', '1977-07-12', 1, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('15', '15', '1', 'Quasi quia accusantium fugit aut quis autem iure esse. Cupiditate aliquid voluptatem fugit nesciunt voluptas itaque vitae minima. Labore veritatis ut animi sed veniam veritatis ut. Culpa voluptate amet quis laboriosam.', '1970-12-16', 1, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('16', '16', '2', 'Odit rerum qui accusantium eos. Iusto consequatur velit fugiat saepe odit rem molestias assumenda. Possimus facere enim facilis consectetur soluta numquam hic.', '1994-12-07', 0, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('17', '17', '3', 'Autem nihil qui et autem officiis. Minus at consequatur ipsa ullam similique ipsa aut esse. Deserunt sunt et quia occaecati. Asperiores odit voluptas quidem et sit facilis rerum. Adipisci corrupti et occaecati vitae libero est ut.', '1995-02-15', 1, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('18', '18', '4', 'Voluptatem numquam enim laborum. Velit ducimus autem a laborum consectetur. Inventore aspernatur eveniet eius aut.', '2009-08-24', 1, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('19', '19', '5', 'Debitis et neque et officia sunt dolor. Quam eos perspiciatis ut minus. Molestiae sint maiores ratione harum nam.', '1993-04-10', 0, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('20', '20', '6', 'Modi consequatur eum dolore dolor omnis. Perferendis voluptatem reprehenderit quia hic error nobis sit. Doloremque delectus quod vero minus. Quasi ex eos vero deserunt sed.', '1987-05-05', 1, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('21', '21', '7', 'Explicabo culpa rerum aut odit earum facilis. Excepturi mollitia magni in veniam facilis quo et ut. Eveniet dolores nam iusto nisi. Eius ab id quia cumque quis accusantium.', '1984-02-15', 0, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('22', '22', '1', 'Cupiditate qui suscipit cumque distinctio id autem. Sit blanditiis amet cum et aut unde velit. Quas magni tempora consequuntur consectetur alias impedit voluptas quasi.', '2010-09-22', 0, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('23', '23', '2', 'Dignissimos enim atque ut consequatur sit. Magnam delectus commodi vitae aliquam laboriosam est. Exercitationem laborum qui consequuntur perspiciatis minima sed ad. Cupiditate quo et quasi qui labore ut.', '1982-05-29', 1, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('24', '24', '3', 'Mollitia id iure non eaque. Aut voluptas repellat quos qui sit error et mollitia. Est reprehenderit rem voluptatem saepe et voluptatum. Odio porro assumenda atque quia id aut ut incidunt. Ipsum qui delectus pariatur accusantium.', '2001-07-05', 0, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('25', '25', '4', 'In et blanditiis omnis sed explicabo dolor explicabo voluptas. Ratione voluptatem rem dolorem sit ut at et. Quae assumenda optio excepturi. Id enim minus odio accusantium fuga explicabo facilis.', '2008-03-06', 1, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('26', '26', '5', 'Quaerat eum facilis sit eos veritatis qui. Iste esse libero provident adipisci vero. Velit cupiditate numquam rerum quae aut. Dolores consequatur enim nobis asperiores quaerat eos omnis.', '2008-12-05', 1, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('27', '27', '6', 'A odio nihil est repellat rem sint. Harum natus itaque sint tempora occaecati quos maxime nostrum. Dolores corrupti pariatur eos in ut odit.', '2020-08-29', 0, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('28', '28', '7', 'Debitis repudiandae officiis et dolorem. Delectus asperiores sunt quisquam illo sunt.', '1986-07-19', 0, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('29', '1', '1', 'Sint possimus sed culpa quo asperiores. Itaque occaecati consequatur animi porro exercitationem. Repudiandae quas porro ut commodi suscipit officiis.', '2005-02-05', 1, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('30', '2', '2', 'Delectus harum voluptatem qui distinctio. Quia deleniti libero sed in asperiores aut temporibus quia. Dolor quibusdam fugiat et eius at incidunt. Voluptate harum sunt occaecati minima.', '2002-08-19', 0, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('31', '3', '3', 'Cum est voluptatibus expedita blanditiis sit dolorem. Aliquid nihil mollitia autem aut deleniti. Atque quam dolores incidunt veritatis nihil.', '1984-11-16', 1, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('32', '4', '4', 'Suscipit earum sit odio alias. Autem aut laborum quos error. Natus qui voluptas molestias ut accusamus culpa incidunt. Sit omnis corrupti id et.', '1979-05-29', 1, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('33', '5', '5', 'Facere sit cupiditate beatae. Excepturi sunt eveniet quis aut numquam debitis repellendus. Saepe rem amet maxime omnis molestiae sed qui. Maiores qui accusamus id fugit neque qui.', '2015-06-19', 1, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('34', '6', '6', 'Similique iusto accusantium deleniti. Voluptas ea expedita quos id corrupti placeat ut. Quae laboriosam enim adipisci itaque optio. Sit possimus aut mollitia quasi sequi.', '1989-05-21', 1, 1);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('35', '7', '7', 'Aut harum accusantium est. Minima dolor consequuntur dolores dolor. Sit quia ipsa repudiandae quidem in.', '2005-09-18', 1, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('36', '8', '1', 'Eveniet eum et rem consequatur. At est consectetur quasi magni iusto dolores rerum voluptate. Modi occaecati rerum iusto minima esse. Illo labore quia ipsum optio est est.', '1984-04-22', 1, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('37', '9', '2', 'Et id consequatur aliquid blanditiis et sunt. Repudiandae qui esse numquam laudantium fugit placeat expedita explicabo. Aut accusantium officia reiciendis quod qui amet sint.', '1978-03-02', 0, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('38', '10', '3', 'Laudantium consequuntur nesciunt maiores aliquid cum aut molestias. Aut quis officiis et ipsa. Sequi exercitationem temporibus ipsa sapiente ut fugiat.', '2004-02-16', 0, 0);
INSERT INTO `cases` (`id`, `customer_id`, `employee_id`, `description`, `due_date`, `is_completed`, `is_service_case`) VALUES ('39', '11', '4', 'Quos voluptatibus aliquid omnis illo et vel perspiciatis. Qui omnis quod consequatur non assumenda quos ipsam eum. Aspernatur asperiores odio laudantium magnam veniam animi neque.', '1975-10-13', 0, 1);

INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('1', '1', '1', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('2', '2', '2', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('3', '3', '3', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('4', '4', '4', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('5', '5', '5', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('6', '6', '1', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('7', '7', '2', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('8', '8', '3', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('9', '9', '4', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('10', '10', '5', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('11', '11', '1', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('12', '12', '2', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('13', '13', '3', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('14', '14', '4', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('15', '15', '5', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('16', '16', '1', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('17', '17', '2', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('18', '18', '3', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('19', '19', '4', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('20', '20', '5', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('21', '21', '1', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('22', '22', '2', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('23', '23', '3', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('24', '24', '4', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('25', '25', '5', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('26', '26', '1', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('27', '27', '2', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('28', '28', '3', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('29', '29', '4', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('30', '30', '5', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('31', '31', '1', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('32', '32', '2', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('33', '33', '3', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('34', '34', '4', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('35', '35', '5', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('36', '36', '1', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('37', '37', '2', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('38', '38', '3', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('39', '39', '4', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('40', '1', '5', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('41', '2', '1', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('42', '3', '2', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('43', '4', '3', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('44', '5', '4', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('45', '6', '5', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('46', '7', '1', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('47', '8', '2', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('48', '9', '3', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('49', '10', '4', 0);
INSERT INTO `cases_products` (`id`, `case_id`, `product_id`, `state`) VALUES ('50', '11', '5', 0);

INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('1', '1', '1', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('2', '2', '2', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('3', '3', '3', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('4', '4', '4', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('5', '5', '5', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('6', '6', '6', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('7', '7', '7', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('8', '8', '8', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('9', '9', '9', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('10', '10', '10', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('11', '11', '11', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('12', '12', '12', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('13', '13', '13', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('14', '14', '14', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('15', '15', '1', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('16', '16', '2', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('17', '17', '3', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('18', '18', '4', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('19', '19', '5', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('20', '20', '6', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('21', '21', '7', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('22', '22', '8', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('23', '23', '9', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('24', '24', '10', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('25', '25', '11', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('26', '26', '12', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('27', '27', '13', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('28', '28', '14', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('29', '29', '1', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('30', '30', '2', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('31', '31', '3', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('32', '32', '4', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('33', '33', '5', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('34', '34', '6', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('35', '35', '7', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('36', '36', '8', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('37', '37', '9', 0);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('38', '38', '10', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('39', '39', '11', 1);
INSERT INTO `cases_leads` (`id`, `case_id`, `lead_id`, `state`) VALUES ('40', '1', '12', 1);

INSERT INTO `campain` (`id`, `employee_id`, `starts_on`, `ends_on`, `state`) VALUES ('1', '1', '2000-10-04', '1981-03-16', 0);
INSERT INTO `campain` (`id`, `employee_id`, `starts_on`, `ends_on`, `state`) VALUES ('2', '2', '2005-12-31', '1990-09-10', 0);
INSERT INTO `campain` (`id`, `employee_id`, `starts_on`, `ends_on`, `state`) VALUES ('3', '3', '1990-04-20', '1994-06-03', 0);

update leads set lead_photo_id = 1;
INSERT INTO lead_photos (id,lead_id,filename,description,created_at) VALUES (1, 1, 'c:\dummy','dummy','2020-12-21');

update cases set due_date = str_TO_DATE(CONCAT(year(now()),'-', month(now()), '-', (1 + rand()*27) div 1 ), '%Y-%c-%d');

/*
 * 6. скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы); 
 */
-- Портфолио открытых заявок по сотрудникам отдела продаж 
select e.name, sum(p.price) as portfolio 
	from cases          as c
	join employees      as e  on c.employee_id  =  e.id
	join cases_products as cp on cp.case_id     =  c.id
	join products       as p  on p.id           = cp.product_id 
group by e.name 
order by portfolio  desc;

-- Члены команды продаж с объёмом портфолио выше среднего
with leaders as (
select e.name, sum(p.price) as portfolio 
	from cases          as c
	join employees      as e  on c.employee_id  =  e.id
	join cases_products as cp on cp.case_id     =  c.id
	join products       as p  on p.id           = cp.product_id 
group by e.name 
order by portfolio  desc
) 
select * from leaders where portfolio > ( select avg(portfolio) from leaders );

-- Просроченные задачи по сотрудникам
select c.due_date, c.description, e.name, e.phone
   from cases     as c 
   join employees as e  on c.employee_id = e.id 
   where is_service_case = 0     
    and  is_service_case = 0
    and due_date < current_date()
   order by e.name, c.due_date asc; 
   
-- Задачи на неделю по сотрудникам
select c.due_date, c.description, e.name, e.phone
   from cases     as c 
   join employees as e  on c.employee_id = e.id 
   where is_service_case = 0     
    and  is_service_case = 0
    and due_date between current_date() and current_date()+7
   order by c.due_date, e.name;    
  
/*
 * 7. представления (минимум 2);
 */
-- открытые задачи
drop view if exists open_calls;
create view open_calls as (
	select * from calls where is_completed = 0
	order by employee_id  
);

-- просроченные сервис-кейсы
drop view if exists expired_service_cases;
create view expired_service_cases as (
	select * from cases c 
	where is_service_case = 1 
	  and is_completed = 0
   	  and due_date < now() 
);


/*
 * 8. хранимые процедуры / триггеры; 
 */

-- обновление даты конвертации лида
drop trigger if exists tg_update_converted_on_date; 
create trigger tg_update_converted_on_date after update on leads 
for each row 
begin 
	if ( new.is_converted <> old.is_converted )
	then 
		update leads set converted_on = current_date( ) where id = new.id;
	end if;
end;

-- обновление даты обновления сотрудника
drop trigger if exists tg_employees_updated; 
create trigger tg_employees_updated after update on employees 
for each row 
begin 
	update employees set updated_at = current_date( ) where id = new.id;	
end;
