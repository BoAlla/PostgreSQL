-- Скрипт создания таблиц
CREATE TABLE borisova.accounts
(
  acc_number char(20),
  acc_bic char(9),
  acc_currecy char(3) not null,
  acc_number_transit char(20) unique,
  acc_number_agreement char(7) not null unique,
  PRIMARY KEY(acc_number, acc_bic)
);
--drop table accounts;
CREATE TABLE borisova.card
(
  card_number char(16) PRIMARY KEY,
  card_surname varchar(64) not null,
  card_name varchar(64) not null,
  card_balance real not null,
  card_pay_system varchar(32) not null,
  card_validity date not null,
  card_code char(3) not null,
  acc_number char(20),
  acc_bic char(9),
  CONSTRAINT fk_card FOREIGN KEY (acc_number, acc_bic) REFERENCES borisova.accounts (acc_number, acc_bic)
);
--drop table borisova.card;
CREATE TABLE borisova.operation
(
  oper_id bigint PRIMARY KEY,
  oper_status varchar(32) not null,
  oper_amount_card real not null,
  oper_amount_oper real not null,
  oper_date timestamp not null,
  oper_type varchar(64) not null,
  oper_sender varchar(256) not null,
  oper_recipient varchar(256) not null,
  oper_accnum_sec varchar(34) not null,
  oper_accbic_sec varchar(11) not null,
  acc_number char(20),
  acc_bic char(9),
 CONSTRAINT fk_oper FOREIGN KEY (acc_number, acc_bic) REFERENCES borisova.accounts (acc_number, acc_bic));
 --drop table borisova.operation;

INSERT INTO borisova.accounts values ('40817840138254387243', '044525059', 'USD', '40817840138251387243', '6453544');
INSERT INTO borisova.accounts values ('40817810138255096001', '044525059', 'RUB', NULL, '9137305');
INSERT INTO borisova.accounts values ('40817840138255542227', '044525059', 'USD', '40817840138251542227', '6091999');
INSERT INTO borisova.accounts values ('40817810138255016848', '044525059', 'RUB', NULL, '1500488');
INSERT INTO borisova.accounts values ('40817978138259218899', '044525059', 'EUR', '40817978138251218899', '9630449');
INSERT INTO borisova.accounts values ('40817810138254259996', '044525059', 'RUB', NULL, '9088256');
INSERT INTO borisova.accounts values ('40817810138255907642', '044525059', 'RUB', NULL, '2284350');
INSERT INTO borisova.accounts values ('40817810138255226540', '044525059', 'RUB', NULL, '1681263');
INSERT INTO borisova.accounts values ('40817810138253475319', '044525059', 'RUB', NULL, '4175723');
INSERT INTO borisova.accounts values ('40817810138255113457', '044525059', 'RUB', NULL, '6750681');
INSERT INTO borisova.accounts values ('40817810138258910456', '044525059', 'RUB', NULL, '7944608');
INSERT INTO borisova.accounts values ('40817810138258691665', '044525059', 'RUB', NULL, '7767387');
INSERT INTO borisova.accounts values ('40817810138253307313', '044525059', 'RUB', NULL, '8705215');
INSERT INTO borisova.accounts values ('40817810138258125229', '044525059', 'RUB', NULL, '6868531');
INSERT INTO borisova.accounts values ('40817810138254788780', '044525059', 'RUB', NULL, '1960131');
INSERT INTO borisova.accounts values ('40817810138255895262', '044525059', 'RUB', NULL, '7540849');

select * from borisova.accounts;

--delete from borisova.accounts; 

INSERT INTO borisova.card values ('2774051014607298', 'KOMAROV', 'ALEKSEI', '20.00', 'Мир', '190924', '232', '40817840138254387243', '044525059');
INSERT INTO borisova.card values ('4774051063039464', 'PETROV', 'VITALII', '268282.99', 'VISA', '140623', '637', '40817810138255096001', '044525059');
INSERT INTO borisova.card values ('5774051273110185', 'NOVIKOV', 'ILIA', '969.35', 'MasterCard', '240723', '986', '40817840138255542227', '044525059');
INSERT INTO borisova.card values ('5774052086853706', 'FEDOROV', 'EVGENII', '7616.73', 'Maestro', '250524', '753', '40817810138255016848', '044525059');
INSERT INTO borisova.card values ('2774052715659638', 'PETROV', 'ARTEM', '16.76', 'Мир', '290423', '969', '40817978138259218899', '044525059');
INSERT INTO borisova.card values ('4774053857746361', 'VASILEV', 'NIKOLAI', '80198.33', 'VISA', '071124', '618', '40817810138254259996', '044525059');
INSERT INTO borisova.card values ('5774053994802991', 'GUSEV', 'ILIA', '321015.44', 'MasterCard', '170823', '950', '40817810138255907642', '044525059');
INSERT INTO borisova.card values ('5774054625960737', 'PETROVA', 'SVETLANA', '88754.79', 'Maestro', '251024', '672', '40817810138255226540', '044525059');
INSERT INTO borisova.card values ('2774054889242514', 'SOLOVEVA', 'MARIIA', '672990.67', 'Мир', '240124', '765', '40817810138253475319', '044525059');
INSERT INTO borisova.card values ('4774055023530298', 'PETROV', 'IGOR', '287935.00', 'VISA', '091024', '323', '40817810138255113457', '044525059');
INSERT INTO borisova.card values ('5774055154903956', 'PETROVA', 'NADEZHDA', '60161', 'MasterCard', '260723', '626', '40817810138258910456', '044525059');
INSERT INTO borisova.card values ('5774055881351545', 'KULIKOVA', 'LIUDMILA', '3399', 'Maestro', '010323', '258', '40817810138258691665', '044525059');
INSERT INTO borisova.card values ('2774056102320324', 'KISELEVA', 'ANNA', '220695.90', 'Мир', '030523', '421', '40817810138253307313', '044525059');
INSERT INTO borisova.card values ('4774056308483484', 'POPOV', 'DENIS', '6806261.00', 'VISA', '211024', '972', '40817810138258125229', '044525059');
INSERT INTO borisova.card values ('5774056532771917', 'STEPAMOVA', 'ALENA', '402771.24', 'MasterCard', '200723', '249', '40817810138254788780', '044525059');
INSERT INTO borisova.card values ('5774056624167248', 'KOVALEV', 'IGOR', '702136.98', 'Maestro', '140722', '897', '40817810138255895262', '044525059');
INSERT INTO borisova.card values ('2774058139760787', 'KOMAROV', 'ALEKSEI', '625.85', 'Мир', '090622', '992', '40817840138254387243', '044525059');
INSERT INTO borisova.card values ('4774058238189199', 'PETROV', 'VITALII', '753112', 'VISA', '201123', '200', '40817810138255096001', '044525059');
INSERT INTO borisova.card values ('5774059501948151', 'NOVIKOV', 'ILIA', '95.51', 'MasterCard', '151024', '209', '40817840138255542227', '044525059');
INSERT INTO borisova.card values ('5774059517016225', 'FEDOROV', 'EVGENII', '49.88', 'Maestro', '310124', '867', '40817810138255016848', '044525059');


select * from borisova.card;
--delete from borisova.card; 

CREATE SEQUENCE borisova.seq_id_oper
START WITH 100000
INCREMENT BY 1
MINVALUE 1;
--drop sequence seq_id_oper

INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '23500.00', '23500', to_date('03.09.2021 2:23:22', 'DD.MM.YYYY hh24:mi:ss'), 'Входящий перевод', 'Лихачёва Лидия Станиславовна ', 'Федоров Евгений Федорович', '40701978078020303855', '044525976', '40817810138255016848', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '6000.00', '6000', to_date('23.10.2021 6:44:55', 'DD.MM.YYYY hh24:mi:ss'), 'Возврат, отмена операции', 'ООО "Набор средств" ', 'Петров Виталий Вадимович', '40801978774566779006', '044525976', '40817810138255096001', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '0.14', '10', to_date('04.06.2021 2:09:49', 'DD.MM.YYYY hh24:mi:ss'), 'Возврат, отмена операции', 'ООО "Лето в наших сердцах"  ', 'Новиков Илья Семёнович', '42201840188873196121', '044525976', '40817840138255542227', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '1000.00', '1000', to_date('26.04.2021 12:59:14', 'DD.MM.YYYY hh24:mi:ss'), 'Возврат, отмена операции', 'ЗАО "Площадь" ', 'Федоров Евгений Федорович', '42103840442308456827', '044525976', '40817810138255016848', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '936.00', '936', to_date('08.12.2021 0:38:42', 'DD.MM.YYYY hh24:mi:ss'), 'Возврат, отмена операции', 'ОАО "Могучая безопасность" ', 'Федоров Евгений Федорович', '42201978395154766706', '044525976', '40817810138255016848', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '100.00', '100', to_date('27.03.2022 3:14:19', 'DD.MM.YYYY hh24:mi:ss'), 'Возврат, отмена операции', 'ООО "КОМПЬЮТЕРНЫЕ СИСТЕМЫ" ', 'Васильев Николай Геннадьевич', '42302810737975530019', '044525976', '40817810138254259996', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '1184.38', '1184.38', to_date('05.05.2021 2:29:10', 'DD.MM.YYYY hh24:mi:ss'), 'Возврат, отмена операции', 'ОАО "Действие закона" ', 'Гусев Илья Матвеевич', '40703840628131551284', '044525976', '40817810138255907642', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '155.00', '155', to_date('08.03.2022 1:20:35', 'DD.MM.YYYY hh24:mi:ss'), 'Возврат, отмена операции', 'ООО "Зона отвественности" ', 'Петрова Светлана Федосеевна', '42302978132971333967', '044525976', '40817810138255226540', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '371.40', '371.4', to_date('27.10.2021 18:00:38', 'DD.MM.YYYY hh24:mi:ss'), 'Возврат, отмена операции', 'ООО "Наивысший берег" ', 'Соловьева Мария Валерьяновна', '40703810801318596890', '044525201', '40817810138253475319', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '166.00', '166', to_date('29.06.2021 14:04:45', 'DD.MM.YYYY hh24:mi:ss'), 'Возврат, отмена операции', 'ПАО "Мастер" ', 'Петров Игорь Гордеевич', '42201840316443777772', '049205774', '40817810138255113457', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '105.00', '105', to_date('25.10.2021 3:27:13', 'DD.MM.YYYY hh24:mi:ss'), 'Возврат, отмена операции', 'ПАО "Объем" ', 'Петрова Надежда Андреевна', '40802810843396358623', '049240748', '40817810138258910456', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '2300.00', '2300', to_date('23.02.2022 19:03:40', 'DD.MM.YYYY hh24:mi:ss'), 'Входящий перевод', 'Осипов Олег Павелович ', 'Куликова Людмила Петровна', '40703840780024424039', '049205795', '40817810138258691665', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '400.00', '400', to_date('30.04.2021 3:19:48', 'DD.MM.YYYY hh24:mi:ss'), 'Входящий перевод', 'Шарова Амалия Арсеньевна ', 'Киселева Анна Ивановна', '40703810692105968291', '044599244', '40817810138253307313', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '1361.43', '1361.43', to_date('28.10.2021 20:40:12', 'DD.MM.YYYY hh24:mi:ss'), 'Входящий перевод', 'Чернов Павел Ринатович ', 'Попов Денис Ярославович', '40803978713737742027', '044579710', '40817810138258125229', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '200.00', '200', to_date('05.07.2021 6:58:56', 'DD.MM.YYYY hh24:mi:ss'), 'Входящий перевод', 'Юдина Вера Петровна ', 'Степанова Алена Филипповна', '42101840854630355913', '046311772', '40817810138254788780', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '252.00', '252', to_date('13.03.2022 11:23:28', 'DD.MM.YYYY hh24:mi:ss'), 'Входящий перевод', 'Доронин Эмиль Всеволодович ', 'Ковалев Игорь Григорьевич', '42001840607369504726', '041012765', '40817810138255895262', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '70.00', '70', to_date('16.02.2022 13:44:48', 'DD.MM.YYYY hh24:mi:ss'), 'Входящий перевод', 'Пестова Эвелина Даниловна ', 'Куликова Людмила Петровна', '42203840932954262957', '044585218', '40817810138258691665', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '229.99', '229.99', to_date('12.05.2021 17:19:37', 'DD.MM.YYYY hh24:mi:ss'), 'Входящий перевод', 'Миронов Василий Станиславович ', 'Петров Виталий Вадимович', '40801978184361648525', '044525551', '40817810138255096001', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '3.34', '243', to_date('19.10.2021 19:38:09', 'DD.MM.YYYY hh24:mi:ss'), 'Входящий перевод', 'Соколов Анатолий Маратович  ', 'Новиков Илья Семёнович', '42201978475340839861', '049205805', '40817840138255542227', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '1.65', '120', to_date('18.09.2021 14:25:54', 'DD.MM.YYYY hh24:mi:ss'), 'Входящий перевод', 'Осипов Олег Павелович  ', 'Федоров Евгений Федорович', '42201978212499564090', '049240803', '40817810138255016848', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '1339.00', '1339', to_date('10.09.2021 5:21:02', 'DD.MM.YYYY hh24:mi:ss'), 'Входящий перевод', 'Лебедев Ярослав Русланович ', 'Куликова Людмила Петровна', '42001840494416414559', '044585677', '40817810138258691665', '044525059');
INSERT INTO borisova.operation values (nextval('borisova.seq_id_oper'), 'Исполнена', '1250.00', '1250', to_date('04.06.2021 14:06:25', 'DD.MM.YYYY hh24:mi:ss'), 'Входящий перевод', 'Назаров Макар Петрович ', 'Васильев Николай Геннадьевич', '42103978573325529274', '048952752', '40817810138254259996', '044525059');
select * from borisova.operation;
