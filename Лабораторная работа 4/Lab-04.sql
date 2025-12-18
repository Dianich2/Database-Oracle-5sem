--- ЗАДАНИЕ 1 ---
select * from v$pdbs;
select * from DBA_DATA_FILES;
select * from DBA_TEMP_FILES;

--- ЗАДАНИЕ 2 ---
-- -- тут короче нам лучше переключиться на PDB
-- alter session set container = CDB$ROOT;
-- alter session set container = XEPDB1;

drop tablespace PID_QDATA including contents and datafiles;
create tablespace PID_QDATA
DATAFILE 'C:\app\USER\product\21c\dbhomeXE\oradata\Tablespaces\PDI_QDATA.dbf'
size 10 m
offline;

-- я буду делать для нашего пользователя PIDCORE
alter tablespace PID_QDATA ONLINE;
alter user PIDCORE quota 2m on PID_QDATA;

-- вот это надо делать от PIDCORE
-- создадим новое подключение для упрощения жизни
select * from USER_SYS_PRIVS;
select * from USER_TS_QUOTAS;
create table PIDCORE.PID_T1(pk int primary key, num int) tablespace PID_QDATA;
insert into PIDCORE.PID_T1 (pk, num) values (1, 1);
insert into PIDCORE.PID_T1 (pk, num) values (2, 2);
insert into PIDCORE.PID_T1 (pk, num) values (3, 3);

select * from PIDCORE.PID_T1;
--- ЗАДАНИЕ 3 ---
select * from user_SEGMENTS where TABLESPACE_NAME='PID_QDATA';

--- ЗАДАНИЕ 4 ---
-- ну тут будем выполнять под PIDCORE наверное
drop table PIDCORE.PID_T1;
select * from user_SEGMENTS where TABLESPACE_NAME='PID_QDATA';
select * from USER_SEGMENTS;
select * from USER_RECYCLEBIN;
-- ну короче по факту после удаления таблицы у нас, как и должно было, поменялось имя сегмента
-- а также в USER_RECYCLEBIN добавилась запись об этом и мы можем восстановить эту таблицу

--- ЗАДАНИЕ 5 ---
-- тоже под PIDCORE
flashback table PIDCORE.PID_T1 to before drop;
select * from USER_SEGMENTS;
select * from USER_RECYCLEBIN;

--- ЗАДАНИЕ 6 ---
truncate table PIDCORE.PID_T1;
begin
    for i in 4..10004
        loop
            insert into PIDCORE.PID_T1(pk, num) values (i, i);
        end loop;
end;

select * from PIDCORE.PID_T1 order by pk;

--- ЗАДАНИЕ 7 ---
-- тоже под PIDCORE
select * from USER_SEGMENTS;
select * from USER_EXTENTS;

--- ЗАДАНИЕ 8 ---
drop tablespace PID_QDATA including contents and datafiles ;

--- ЗАДАНИЕ 9 ---
--  вернемся в CDB$ROOT
select * from V$LOGFILE;
select * from V$LOG; -- где CURRENT, та и текущая группа

--- ЗАДАНИЕ 10 ---
select * from V$LOGFILE;

--- ЗАДАНИЕ 11 ---
-- 13:58
alter system switch logfile;
select * from V$LOG;

--- ЗАДАНИЕ 12 ---
alter database add logfile group 4
    ('C:\app\USER\product\21c\oradata\XE\REDO04_1.LOG',
    'C:\app\USER\product\21c\oradata\XE\REDO04_2.LOG',
    'C:\app\USER\product\21c\oradata\XE\REDO04_3.LOG'
    )
size 50m;
select * from V$LOG;
select * from V$LOGFILE;
alter system switch logfile;
select CURRENT_SCN from V$database;

--- ЗАДАНИЕ 13 ---
-- нужно переключиться, чтобы у нас GROUP 4 не было CURRENT
-- и еще нужно создать контрольную точку, так как у нас этот журнал ACTIVE
alter system checkpoint;
alter system switch logfile;
alter database drop logfile member 'C:\app\USER\product\21c\oradata\XE\REDO04_1.LOG';
alter database drop logfile member 'C:\app\USER\product\21c\oradata\XE\REDO04_2.LOG';
-- последний файлик лучше удалять с группой
alter database drop logfile group 4;
select * from V$LOG;
select * from V$LOGFILE;

--- ЗАДАНИЕ 14 ---
-- архивирование не выполняется(в ARCHIVED записано NO)
select name, LOG_MODE from V$DATABASE;
-- и тут у нас NOARCHIVELOG
select INSTANCE_name, ARCHIVER, ACTIVE_STATE from V$INSTANCE;
-- тут тоже STOPPED

--- ЗАДАНИЕ 15 ---
select * from V$ARCHIVED_LOG;

--- ЗАДАНИЕ 16 ---
-- ну тут наверное лучше будем делать через консольку, используя sqlplus
-- после выполнения необходимых действий
-- тут у нас LOG_MODE=ARCHIVELOG
select name, LOG_MODE from V$DATABASE;
-- тут у нас теперь ARCHIVER=STARTED
select INSTANCE_name, ARCHIVER, ACTIVE_STATE from V$INSTANCE;
-- а тут у нас появились YES, где не CURRENT
select * from v$LOG;

--- ЗАДАНИЕ 17 ---
alter system set log_archive_dest_1='LOCATION=C:\app\USER\product\21c\oradata\XE';
select * from V$ARCHIVED_LOG; -- еще не появился, надо переключиться
alter system switch logfile;
select * from V$ARCHIVED_LOG; -- а теперь он есть

select * from V$ARCHIVED_LOG order by SEQUENCE#;
select * from V$LOG order by SEQUENCE#;

--- ЗАДАНИЕ 18 ---
-- опять же делаем это через консольку, используя sqlplus
-- тут у нас LOG_MODE=NOARCHIVELOG
select name, LOG_MODE from V$DATABASE;
-- тут у нас теперь ARCHIVER=STOPPED
select INSTANCE_name, ARCHIVER, ACTIVE_STATE from V$INSTANCE;

--- ЗАДАНИЕ 19 ---
select * from V$CONTROLFILE;

--- ЗАДАНИЕ 20 ---
-- наверное здесь мы тоже лучше воспользуемся sqlplus
select * from V$CONTROLFILE_RECORD_SECTION;

--- ЗАДАНИЕ 21 ---
-- местоположение в Windows обычно в домашней папке ORACLE_HOME, можем посмотреть через реестр
-- C:\app\USER\product\21c\admin\XE\pfile тут у меня init.ora
-- C:\app\USER\product\21c\dbhomeXE\srvm\admin тут тоже у меня init.ora
-- C:\app\USER\product\21c\database -- тут у меня SPFILE
select * from V$PARAMETER;

--- ЗАДАНИЕ 22 ---
-- это сделаем через sqlplus
create PFILE='PDI_PFILE.ORA' from SPFILE;
-- он будет здесь C:\app\USER\product\21c\dbhomeXE\database

--- ЗАДАНИЕ 23 ---
-- у меня он тут C:\app\USER\product\21c\database
select * from V$PWFILE_USERS;

--- ЗАДАНИЕ 24 ---
select * from v$DIAG_INFO order by NAME;

--- ЗАДАНИЕ 25 ---
-- C:\app\USER\product\21c\diag\rdbms\xe\xe\alert