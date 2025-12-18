--- ЗАДАНИЕ 1 ---
select * from V$PDBS;
select * from dba_pdbs;

--- ЗАДАНИЕ 2 ---
select * from V$INSTANCE;

--- ЗАДАНИЕ 3 ---
select * from DBA_REGISTRY;
select * from PRODUCT_COMPONENT_VERSION;

--- ЗАДАНИЕ 4 ---
-- тут будем выполнять через ORACLE DATABASE CONFIGURATION ASSISTANT
-- обязательно под админом, а то будет всё не хорошо

--- ЗАДАНИЕ 5 ---
-- тут снова проверяем все PDB(должна появиться наша PDI_PDB)
select * from V$PDBS;

--- ЗАДАНИЕ 6 ---
-- все это по факту надо будет для удобства перетащить в консоль подключения system для PDI_PDB, после его создания
-- и там уже выполнять
drop tablespace PID_PDB_TS including contents and datafiles;
create tablespace PID_PDB_TS
DATAFILE 'C:\app\USER\product\21c\dbhomeXE\oradata\Tablespaces\PID_PDB.dbf'
size 10 m
autoextend on next 500 k
maxsize 100 m
extent management local;

drop tablespace PID_PDB_TEMP_TS;
create temporary tablespace PID_PDB_TEMP_TS
TEMPFILE 'C:\app\USER\product\21c\dbhomeXE\oradata\Tablespaces\PID_PDB_TEMP.dbf'
size 10 m
autoextend on next 500 k
maxsize 100 m
extent management local;

create role RL_U1_PID_PDB;
-- ну тут по факту будет логично наделить роль хоть какими-то привилегиями(
-- например, создание таблиц и т.д.)
GRANT CREATE ANY TABLE,
      CREATE SESSION,
      CONNECT,
      SELECT ANY TABLE,
      INSERT ANY TABLE,
      DROP ANY TABLE
      TO RL_U1_PID_PDB;

create profile PF_U1_PID_PDB LIMIT
PASSWORD_LIFE_TIME 180
SESSIONS_PER_USER 3
FAILED_LOGIN_ATTEMPTS 5
PASSWORD_LOCK_TIME 1
PASSWORD_REUSE_TIME 10
PASSWORD_GRACE_TIME DEFAULT
CONNECT_TIME 180
IDLE_TIME 30;

create user U1_PID_PDB identified by "123"
default tablespace PID_PDB_TS
temporary tablespace PID_PDB_TEMP_TS
profile PF_U1_PID_PDB
account unlock
password expire;

select * from dba_users where username = 'U1_PID_PDB';

ALTER USER U1_PID_PDB QUOTA UNLIMITED ON PID_PDB_TS;

grant RL_U1_PID_PDB to U1_PID_PDB;
select * from DBA_ROLES where ROLE like '%PDB%';
select * from DBA_USERS where USERNAME like '%PID%';

--- ЗАДАНИЕ 7 ---
-- ну подключение мы создаем и потом весь код, также как и в предыдущем задании лучше перетащить в консоль
-- того пользователя
create table PID_table(num int);
insert into PID_table(num) values (1);
insert into PID_table(num) values (2);
insert into PID_table(num) values (3);
select * from PID_table;

--- ЗАДАНИЕ 8 ---
-- тут будем смотреть из подключения system для PID_PDB
select * from DBA_TABLESPACES;
select * from DBA_DATA_FILES;
select * from DBA_TEMP_FILES;
select * from DBA_ROLES;
select * from DBA_SYS_PRIVS;
select * from ROLE_SYS_PRIVS;
select * from DBA_PROFILES;
select * from DBA_USERS;
select * from DBA_SYS_PRIVS pr inner join DBA_USERS us on pr.GRANTEE = us.USERNAME;
select * from DBA_ROLE_PRIVS pr inner join DBA_USERS us on pr.GRANTEE = us.USERNAME;;

--- ЗАДАНИЕ 9 ---
-- тут выполняем под подключением PID, так как там у меня CDB$ROOT
ALTER SESSION SET CONTAINER = "CDB$ROOT"; -- если вдруг мы не там
create user C##PID identified by "123321500%"
CONTAINER=ALL;

-- тут нужно будет переключиться на подключение PID_PDB
grant create session to C##PID CONTAINER=ALL;
grant set container to C##PID; -- это типо чтобы менять контейнер, как вот я выше делала для того пользователя(по факту не обязательно)
select * from DBA_SYS_PRIVS where GRANTEE = 'C##PID';

-- проверка работоспособности
select * from USER_SYS_PRIVS;
select * from dba_users where USERNAME = 'C##PID';
--- ЗАДАНИЕ 10 ---
-- это надо сделать через консольку, тут у нас под system не хватает привилегий
ALTER PLUGGABLE DATABASE PID_PDB OPEN;
ALTER PLUGGABLE DATABASE PID_PDB CLOSE IMMEDIATE;
DROP PLUGGABLE DATABASE PID_PDB INCLUDING DATAFILES;
DROP USER C##PID CASCADE;
-- ну и после выполнения команд удостоверимся, что PID_PDB нету больше
select * from V$PDBS;