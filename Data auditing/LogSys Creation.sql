-- Задание 1
-- Создание таблицы для хранения логов
CREATE TABLE borisova.card_audit
AS
  SELECT *
  FROM borisova.card
  WHERE false;
alter table borisova.card_audit 
add column operation char(1) NOT NULL,
add column user_name varchar(32) NOT NULL,
add column change_time timestamp NOT NULL,
add column name_col_changed varchar(128);
select * from borisova.card_audit;
-- Создание триггерной функции 
create or replace function borisova.card_audit_information() 
returns trigger as  
$card_audit$
declare 
update_columns text;
begin
if (TG_OP = 'DELETE') THEN
INSERT INTO borisova.card_audit VALUES(OLD.*, 'D', current_user, now(), 'All');
elsif (TG_OP = 'UPDATE') THEN
update_columns:='';
if old.card_number<>new.card_number then	
	update_columns:='card_number';
end if;
if old.card_surname<>new.card_surname then
	update_columns:=update_columns||' card_surname';
end if;
if old.card_name<>new.card_name then
	update_columns:=update_columns||' card_name';
end if;
if old.card_balance<>new.card_balance then
	update_columns:=update_columns||' card_balance';
end if;
if old.card_pay_system<>new.card_pay_system then
	update_columns:=update_columns||' card_pay_system';
end if;
if old.card_validity<>new.card_validity then
	update_columns:=update_columns||' card_validity';
end if;
if old.card_code<>new.card_code then
	update_columns:=update_columns||' card_code';
end if;
if old.acc_number<>new.acc_number then
	update_columns:=update_columns||' acc_number';
end if;
if old.acc_bic<>new.acc_bic then
	update_columns:=update_columns||' acc_bic';
end if;
insert into borisova.card_audit VALUES(OLD.*, 'U', current_user, now(), update_columns);
elsif (TG_OP = 'INSERT') THEN
insert into borisova.card_audit VALUES (NEW.*, 'I', current_user, now(), 'All');
end if;
return null;
end;
$card_audit$ 
language plpgsql;
-- Создание триггера
create trigger card_audit_trigger
after insert or update or delete on borisova.card
for each row 
execute procedure borisova.card_audit_information();

--Задание 2
-- Строки таблицы card, которые не были изменены
select borisova.card.card_number, borisova.card.card_surname, borisova.card.card_name, borisova.card.card_balance, borisova.card.card_pay_system, borisova.card.card_validity, borisova.card.card_code, borisova.card.acc_number, borisova.card.acc_bic
from borisova.card
left join borisova.card_audit on borisova.card.card_number=borisova.card_audit.card_number
where borisova.card_audit.card_number is null
union 
--Восстановление удаленных строк
select card_number, card_surname, card_name, card_balance, card_pay_system, card_validity, card_code, acc_number, acc_bic 
from borisova.card_audit
where operation='D' and change_time>'2022-12-10 19:26:00'
union 
--Восстановление вставленных строк
select a.card_number, a.card_surname, a.card_name, a.card_balance, a.card_pay_system, a.card_validity, a.card_code, a.acc_number, a.acc_bic 
from borisova.card_audit a
where a.operation='I' and a.change_time<'2022-12-10 19:26:00' and a.card_number not in 
																	(
																		select r.card_number
																		from borisova.card_audit r
																		where r.operation='D' and r.change_time<'2022-12-10 19:26:00' and a.change_time<=r.change_time
																	)
union
--Восстановление старых значений до update
(select distinct on(card_number) card_number, card_surname, card_name, card_balance, card_pay_system, card_validity, card_code, acc_number, acc_bic
from borisova.card_audit 
where operation='U' and change_time>'2022-12-10 19:26:00'
order by card_number, change_time asc)
union
select card_number, card_surname, card_name, card_balance, card_pay_system, card_validity, card_code, acc_number, acc_bic 
from borisova.card c
where c.card_number in 
(select card_number
from borisova.card_audit a
where a.operation='U' and a.change_time<'2022-12-10 19:26:00' and a.card_number not in 
	(select card_number
	from borisova.card_audit a
	where a.operation='U' and a.change_time>'2022-12-10 19:26:00'
	)
)
order by card_number;

-- Задание 3
--Сохраним таблицу, полученную для вывода данных на момент времени
create table borisova.card_copy as
(
select borisova.card.card_number, borisova.card.card_surname, borisova.card.card_name, borisova.card.card_balance, borisova.card.card_pay_system, borisova.card.card_validity, borisova.card.card_code, borisova.card.acc_number, borisova.card.acc_bic
from borisova.card
left join borisova.card_audit on borisova.card.card_number=borisova.card_audit.card_number
where borisova.card_audit.card_number is null
union 
select card_number, card_surname, card_name, card_balance, card_pay_system, card_validity, card_code, acc_number, acc_bic 
from borisova.card_audit
where operation='D' and change_time>'2022-12-10 19:26:00'
union 
select a.card_number, a.card_surname, a.card_name, a.card_balance, a.card_pay_system, a.card_validity, a.card_code, a.acc_number, a.acc_bic 
from borisova.card_audit a
where a.operation='I' and a.change_time<'2022-12-10 19:26:00' and a.card_number not in 
																	(
																		select r.card_number
																		from borisova.card_audit r
																		where r.operation='D' and r.change_time<'2022-12-10 19:26:00' and a.change_time<=r.change_time
																	)
union
(select distinct on(card_number) card_number, card_surname, card_name, card_balance, card_pay_system, card_validity, card_code, acc_number, acc_bic
from borisova.card_audit 
where operation='U' and change_time>'2022-12-10 19:26:00'
order by card_number, change_time asc)
union
select card_number, card_surname, card_name, card_balance, card_pay_system, card_validity, card_code, acc_number, acc_bic 
from borisova.card c
where c.card_number in 
(select card_number
from borisova.card_audit a
where a.operation='U' and a.change_time<'2022-12-10 19:26:00' and a.card_number not in 
	(select card_number
	from borisova.card_audit a
	where a.operation='U' and a.change_time>'2022-12-10 19:26:00'
	)
)
order by card_number
);
--Удалим все значения из текущей таблицы card
delete from borisova.card;
--Вставим значения из card_copy в card
insert INTO borisova.card select * FROM borisova.card_copy;
--Удалим копию таблицы card
drop table borisova.card_copy;
--Проверяем изменения 
select * from borisova.card;

--Задание 4
--Создание функции для системы логирования 
CREATE OR REPLACE FUNCTION borisova.sys_log(tab_name text)
returns text
AS $$
BEGIN
execute 
--Таблица для хранения логов
  '
  CREATE TABLE if not exists '||tab_name||'_sys_log
  AS
  SELECT *
  FROM '||tab_name||'
  WHERE false;
  alter table '||tab_name||'_sys_log 
  add column operation char(1) NOT NULL,
  add column user_name varchar(32) NOT NULL,
  add column change_time timestamp NOT NULL;
  
--Триггерная функция для логирования изменений 
create or replace function '||tab_name||'_sys_log_func()
returns trigger as  
$card_audit$
begin
if (TG_OP = ''DELETE'') THEN
INSERT INTO '||tab_name||'_sys_log VALUES(OLD.*, ''D'', current_user, now());
elsif (TG_OP = ''UPDATE'') THEN
insert into '||tab_name||'_sys_log VALUES(OLD.*, ''U'', current_user, now());
elsif (TG_OP = ''INSERT'') THEN
insert into '||tab_name||'_sys_log VALUES (NEW.*, ''I'', current_user, now());
end if;
return null;
end;
$card_audit$ 
language plpgsql;

--Триггер, срабатывающий при изменении таблицы
create trigger sys_log_trigger
after insert or update or delete on '||tab_name||'
for each row 
execute procedure '||tab_name||'_sys_log_func()
  ';
  return tab_name;
END; $$ 
LANGUAGE 'plpgsql';
-- Вызов функции для создания системы логирования
select * from borisova.sys_log('borisova.card');

--Дополнительное задание 3
--Создание таблицы для хранения логов с партицированием по времени изменения 
CREATE TABLE borisova.card_audit_partitioning
(
  card_number char(16),
  card_surname varchar(64),
  card_name varchar(64),
  card_balance real,
  card_pay_system varchar(32),
  card_validity date,
  card_code char(3),
  acc_number char(20),
  acc_bic char(9),
  operation char(1),
  user_name varchar(32),
  change_time timestamp,
  name_col_changed varchar(128)
)
PARTITION BY RANGE (change_time);
--Создание триггерной функции, записывающей изменения в таблицу логирования
create or replace function borisova.card_audit_part() 
returns trigger as  
$card_audit_part$
declare 
update_columns text;
begin
if (TG_OP = 'DELETE') THEN
INSERT INTO borisova.card_audit_partitioning VALUES(OLD.*, 'D', current_user, now(), 'All');
elsif (TG_OP = 'UPDATE') THEN
update_columns:='';
if old.card_number<>new.card_number then	
	update_columns:='card_number';
end if;
if old.card_surname<>new.card_surname then
	update_columns:=update_columns||' card_surname';
end if;
if old.card_name<>new.card_name then
	update_columns:=update_columns||' card_name';
end if;
if old.card_balance<>new.card_balance then
	update_columns:=update_columns||' card_balance';
end if;
if old.card_pay_system<>new.card_pay_system then
	update_columns:=update_columns||' card_pay_system';
end if;
if old.card_validity<>new.card_validity then
	update_columns:=update_columns||' card_validity';
end if;
if old.card_code<>new.card_code then
	update_columns:=update_columns||' card_code';
end if;
if old.acc_number<>new.acc_number then
	update_columns:=update_columns||' acc_number';
end if;
if old.acc_bic<>new.acc_bic then
	update_columns:=update_columns||' acc_bic';
end if;
insert into borisova.card_audit_partitioning VALUES(OLD.*, 'U', current_user, now(), update_columns);
elsif (TG_OP = 'INSERT') THEN
insert into borisova.card_audit_partitioning VALUES (NEW.*, 'I', current_user, now(), 'All');
end if;
return null;
end;
$card_audit_part$ 
language plpgsql;

--Создание триггера, срабатывающего при изменении таблицы 
create trigger card_audit_partitioning_tr
after insert or update or delete on borisova.card
for each row 
execute procedure borisova.card_audit_part();

--Просмотр талицы логов
select * from borisova.card_audit_partitioning;

--Создание партиций по дням 
CREATE TABLE borisova.card_audit_partitioning_2022_12_18 PARTITION OF borisova.card_audit_partitioning FOR VALUES FROM ('2022-12-18') TO ('2022-12-19');
CREATE TABLE borisova.card_audit_partitioning_2022_12_19 PARTITION OF borisova.card_audit_partitioning FOR VALUES FROM ('2022-12-19') TO ('2022-12-20');
CREATE TABLE borisova.card_audit_partitioning_2022_12_20 PARTITION OF borisova.card_audit_partitioning FOR VALUES FROM ('2022-12-20') TO ('2022-12-21');


--Дополнительное задание 5
--Создание таблицы для подсчета количества измененй
create table borisova.card_statistics
(
  card_number bigint,
  card_surname bigint,
  card_name bigint,
  card_balance bigint,
  card_pay_system bigint,
  card_validity bigint,
  card_code bigint,
  acc_number bigint,
  acc_bic bigint,
  name_col_changed varchar(128),
  change_time timestamp
);

--Вставка в таблицу значений из таблицы логирования 
insert into borisova.card_statistics (name_col_changed, change_time) (select name_col_changed, change_time  from borisova.card_audit);

--Просмотр таблицы 
select * from borisova.card_statistics;

--Обновление ячеек таблицы для подсчета количества вхождений подстроки в строку
update borisova.card_statistics 
set card_number = LENGTH(REPLACE(name_col_changed,'card_number','~'))-LENGTH(REPLACE(name_col_changed, 'card_number',''));
update borisova.card_statistics 
set card_surname = LENGTH(REPLACE(name_col_changed,'card_surname','~'))-LENGTH(REPLACE(name_col_changed, 'card_surname',''));
update borisova.card_statistics 
set card_name = LENGTH(REPLACE(name_col_changed,'card_name','~'))-LENGTH(REPLACE(name_col_changed, 'card_name',''));
update borisova.card_statistics 
set card_balance = LENGTH(REPLACE(name_col_changed,'card_balance','~'))-LENGTH(REPLACE(name_col_changed, 'card_balance',''));
update borisova.card_statistics 
set card_pay_system = LENGTH(REPLACE(name_col_changed,'card_pay_system','~'))-LENGTH(REPLACE(name_col_changed, 'card_pay_system',''));
update borisova.card_statistics 
set card_validity = LENGTH(REPLACE(name_col_changed,'card_validity','~'))-LENGTH(REPLACE(name_col_changed, 'card_validity',''));
update borisova.card_statistics 
set card_code = LENGTH(REPLACE(name_col_changed,'card_code','~'))-LENGTH(REPLACE(name_col_changed, 'card_code',''));
update borisova.card_statistics 
set acc_number = LENGTH(REPLACE(name_col_changed,'acc_number','~'))-LENGTH(REPLACE(name_col_changed, 'acc_number',''));
update borisova.card_statistics 
set acc_bic = LENGTH(REPLACE(name_col_changed,'acc_bic','~'))-LENGTH(REPLACE(name_col_changed, 'acc_bic',''));

--Просмотр таблицы 
select * from borisova.card_statistics;

--Суммирование количества вхождений подстроки в строку по столбцам и группировка строк по дням
select date_trunc('day', change_time) as data, sum(card_number) as card_number, sum(card_surname) as card_surname, sum(card_name) as card_name, sum(card_balance) as card_balance,
sum(card_pay_system) as card_pay_system, sum(card_validity) as card_validity, sum(card_code) as card_code, sum(acc_number) as acc_number, sum(acc_bic) as acc_bic 
from borisova.card_statistics
group by date_trunc('day', change_time);

--Проверка изменений
INSERT INTO borisova.card values ('5774050098903966', 'GRINCHEN', 'VITALIA', '601.61', 'MasterCard', '260723', '626', '40817840138255542227', '044525059');
delete from borisova.card where card_name='VITALIA';

update borisova.card set card_balance=56753 where card_number='5774056532771917';
update borisova.card set card_balance=433756 where card_number='5774056532771917';
update borisova.card set (card_name, card_balance)=('IGOR', 342288) where card_number='4774055023530298';
update borisova.card set card_balance=7 where card_number='5774056532771917';
update borisova.card set card_balance=55.3 where card_number='5774056532771917';
update borisova.card set card_balance=11.2 where card_number='5774056532771917';
update borisova.card set (card_name, card_balance)=('OLEG', 1223.5) where card_number='4774055023530298';
update borisova.card set card_balance=575.3 where card_number='5774056532771917';
