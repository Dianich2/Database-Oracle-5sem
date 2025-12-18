--- ЗАДАНИЕ 1 ---
drop tablespace TS_PID INCLUDING CONTENTS and DATAFILES;
CREATE TABLESPACE TS_PID
    DATAFILE 'C:\app\USER\product\21c\dbhomeXE\oradata\Tablespaces\TS_PID.dbf'
    SIZE 7 m
    AUTOEXTEND ON NEXT 5 m
    MAXSIZE 20 m;

--- ЗАДАНИЕ 2 ---
drop tablespace TS_PID_TEMP INCLUDING CONTENTS and DATAFILES;
CREATE TEMPORARY TABLESPACE TS_PID_TEMP
    TEMPFILE 'C:\app\USER\product\21c\dbhomeXE\oradata\Tablespaces\TS_PID_TEMP.dbf'
    SIZE 5 m
    AUTOEXTEND ON NEXT 3 m
    MAXSIZE 30 m;

--- ЗАДАНИЕ 3 ---
select * from DBA_TABLESPACES;

select * from DBA_DATA_FILES;
select * from DBA_TEMP_FILES;

--- ЗАДАНИЕ 4 ---
select value from V$PARAMETER where name = 'common_user_prefix'; -- префикс для ролей
-- изначально он был C##, поэтому поменяем через sqlplus в cmd(чтоб было прям по заданию)
-- после этого префикс будет пустой(так как нам еще нужно для профиля безопасности другой, да и чтоб потом не было проблем)
-- и мы сможем спокойно создать роль)
drop role RL_PIDCORE;
create role RL_PIDCORE;
select * from dba_roles where ROLE like 'RL_%';

-- посмотрим как правильно написать привилегии
select * from DBA_SYS_PRIVS where GRANTEE = 'SYS'
                              and PRIVILEGE like '%CREATE%' order by PRIVILEGE;
select * from DBA_SYS_PRIVS where GRANTEE = 'SYS'
                              and PRIVILEGE like '%DROP%' order by PRIVILEGE;

-- дадим пользователю права создавать объекты везде(если нужно только у себя,
-- то просто уберем ANY между CREATE и объектом)
grant CREATE SESSION,
      CREATE ANY TABLE,
      CREATE ANY VIEW,
      CREATE ANY PROCEDURE,
      DROP ANY TABLE,
      DROP ANY VIEW,
      DROP ANY PROCEDURE
      TO RL_PIDCORE;

select * from DBA_SYS_PRIVS where GRANTEE = 'RL_PIDCORE';
-- Кстати, для функций нет отдельных привилегий, они идут типо как с процедурами поэтому так

--- ЗАДАНИЕ 5 ---
-- по факту мы уже выводили выше сразу для проверки, но сделаем это еще раз)
select * from dba_roles where ROLE like 'RL_%';
select * from DBA_SYS_PRIVS where GRANTEE = 'RL_PIDCORE';

--- ЗАДАНИЕ 6 ---
drop profile PF_PIDCORE cascade ;
create PROFILE PF_PIDCORE LIMIT
       PASSWORD_LIFE_TIME 180 -- количество дней жизни пароля(через столько дней система потребует сменить пароль
       -- если пользователь не сменит пароль в течении PASSWORD_GRACE_TIME, то по факту аккаунт будет заблокан)
       SESSIONS_PER_USER  3 -- количество сессий для пользователя(ну то есть типо больше подключений пользователь не может сделать,
       -- нужно закрыть предыдущие)
       FAILED_LOGIN_ATTEMPTS 7 -- количество попыток входа(если это количество попыток будет истрачено и пользователь
       -- не ввел правильный пароль, то его аккант блокается на время PASSWORD_LOCK_TIME(кстати, при успешном входе,
       -- количество неправильных попыток сбрасывается))
       PASSWORD_LOCK_TIME 1 -- количество дней блокирования(после прохождения срока блокировки, она автоматически снимается
       -- или же администратор может разблокировать раньше)
       PASSWORD_REUSE_TIME 10 -- через сколько дней можно повторить пароль(тут типо смысл в том, что это срок, на который по факту
       -- ORACLE запоминает пароли, поэтому при смене пароля мы не можем поменять на старый пароль, пока не пройдет этот срок)
       PASSWORD_GRACE_TIME DEFAULT -- количество дней предупреждения о смене пароля(ну это, как было сказано раньше, время, которое
       -- дается пользователю на смену пароля после его просрочки, DEFAULT вроде бы это 7 дней)
       CONNECT_TIME 180 -- время соединения(в минутах)(по истечению этого срока соединение будет разорвано(кстати, по идее все незавер-
       -- шенные транзакции будут откатываться))
       IDLE_TIME 30; -- количество минут простоя(ну то есть, если мы указанное время будем бездействовать, то соединение разорвется
       -- заранее(но тут при каждом выполненном запросе счетчик этого времени сбрасывается))

select * from DBA_PROFILES where PROFILE like 'PF_PIDCORE';

--- ЗАДАНИЕ 7 ---
select * from DBA_PROFILES; -- если нужно чисто названия профилей, то просто заменим * на PROFILE
select * from DBA_PROFILES where PROFILE like 'PF_PIDCORE';
select * from DBA_PROFILES where PROFILE like 'DEFAULT';

--- ЗАДАНИЕ 8 ---
drop user PIDCORE cascade;
CREATE USER PIDCORE IDENTIFIED BY "123" -- как пользователь будет аутентифицироваться(у нас по паролю)
DEFAULT TABLESPACE TS_PID -- табличное пространство по умолчанию
quota unlimited on TS_PID
TEMPORARY TABLESPACE TS_PID_TEMP -- табличное пространство для временных данных
PROFILE PF_PIDCORE -- профиль безопасности
ACCOUNT UNLOCK -- учетная запись разблокирована
PASSWORD EXPIRE; -- срок действия пароля истек(то есть пользователь должен сменить пароль)

-- теперь мы здесь заходим через sqlplus и меняем пароль пользователя(можно через админа(sysdba))
select * from dba_users where USERNAME like 'PIDCORE';
select * from dba_ts_quotas;

-- мне кажется, что здесь еще нужно было бы дать пользователю нашу созданную роль RL_PIDCORE(
-- хотя в задании вроде не сказано)

GRANT RL_PIDCORE TO PIDCORE;

select * from DBA_SYS_PRIVS where GRANTEE = 'PIDCORE';
select * from DBA_ROLE_PRIVS where GRANTEE = 'PIDCORE';

--- ЗАДАНИЕ 10 ---
-- это нужно потом перекопировать в консоль для PIDCORE, если нужно создать у него
select * from dba_tables where TABLE_NAME = 'TAB_PIDCORE';
select * from USER_SYS_PRIVS;
select * from USER_ROLE_PRIVS;
select * from USER_TABLES;
drop table PIDCORE.TAB_PIDCORE;
create table PIDCORE.TAB_PIDCORE(first int);
drop view PIDCORE.VIEW_PIDCORE;
create view PIDCORE.VIEW_PIDCORE as select first
from PIDCORE.TAB_PIDCORE;

--- ЗАДАНИЕ 11 ---
DROP TABLESPACE PID_QDATA INCLUDING CONTENTS AND DATAFILES;
create tablespace PID_QDATA
DATAFILE 'C:\app\USER\product\21c\dbhomeXE\oradata\Tablespaces\PID_QDATA.dbf'
SIZE 10 m
AUTOEXTEND OFF
OFFLINE;

-- тут короче небольшой трабл, так как мы в мультитенантной среде
-- нам нужно подключиться к конкретному PDB, в нашем случае XEPDB1(в ошибке она)
-- alter session set container=XEPDB1;
-- alter session set container=CDB$ROOT;
-- select SYS_CONTEXT('USERENV', 'CON_NAME') FROM dual;
-- SELECT username FROM dba_users;

alter tablespace PID_QDATA online;
alter user PIDCORE quota 2 m on PID_QDATA;
select * from USER_TS_QUOTAS;

create table PIDCORE.PIDCORE_T1(num int) tablespace PID_QDATA;

select * from USER_TABLES;

insert into PIDCORE.PIDCORE_T1 values (0);
insert into PIDCORE.PIDCORE_T1 values (2);
insert into PIDCORE.PIDCORE_T1 values (5);

select * from PIDCORE.PIDCORE_T1;




