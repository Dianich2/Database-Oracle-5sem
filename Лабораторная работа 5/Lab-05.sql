--- ЗАДАНИЕ 1 ---
select * from v$SGA;
select sum(value) as total_size from v$SGA;

--- ЗАДАНИЕ 2 ---
select * from V$SGA_DYNAMIC_COMPONENTS;
select * from V$SGAINFO;
select Pool, sum(BYTES) from V$SGASTAT group
    by POOL;

--- ЗАДАНИЕ 3 ---
-- тут будет в байтах
select COMPONENT,GRANULE_SIZE from V$SGA_DYNAMIC_COMPONENTS;
-- если нужно в Мб
select COMPONENT, (GRANULE_SIZE / (1048576)) as GRANULE_SIZE from V$SGA_DYNAMIC_COMPONENTS;

--- ЗАДАНИЕ 4 ---
-- это то, что доступно для перераспределения между компонентами SGA
select * from V$SGA_DYNAMIC_FREE_MEMORY;
-- это по идее общая свободная память(смотрим Free SGA Memory Available)
select * from V$SGAINFO;

--- ЗАДАНИЕ 5 ---
-- тут смотрим Maximum SGA Size(максимальный размер)
select * from V$SGAINFO where name like '%SGA%';
-- тут смотрим текущий размер
select sum(value) as total_size from v$SGA;
-- можно посмотреть через параметры(sga_max_size и sga_target)
select * from V$PARAMETER where NAME in ('sga_max_size', 'sga_target');
-- также еще можно посмотреть через sqlplus

--- ЗАДАНИЕ 6 ---
--- тут смотрим KEEP, DEFAULT и RECYCLE
select * from V$SGA_DYNAMIC_COMPONENTS;

--- ЗАДАНИЕ 7 ---
drop table PID;
create table PID(keep int) storage (buffer_pool keep);
--- ну по факту, чтобы увидеть сегмент нам нужно еще вставить данные
insert into PID(keep) values (1);
insert into PID(keep) values (2);
insert into PID(keep) values (3);
commit;
select * from PID;
select SEGMENT_NAME, SEGMENT_TYPE, BUFFER_POOL from dba_SEGMENTS
where SEGMENT_NAME='PID';

--- ЗАДАНИЕ 8 ---
drop table PID_D;
create table PID_D(def int) storage (buffer_pool default);
--- ну по факту, чтобы увидеть сегмент нам нужно еще вставить данные
insert into PID_D(def) values (1);
insert into PID_D(def) values (2);
insert into PID_D(def) values (3);
commit;
select SEGMENT_NAME, SEGMENT_TYPE, BUFFER_POOL from dba_SEGMENTS
where SEGMENT_NAME='PID_D';

--- ЗАДАНИЕ 9 ---
-- можно посмотреть через параметры(log_buffer)
select * from V$PARAMETER where name = 'log_buffer';
select * from V$SGAINFO where name = 'Redo Buffers';
-- также еще можно посмотреть через sqlplus

--- ЗАДАНИЕ 10 ---
-- смотрим free memory
select * from V$SGASTAT where POOL='large pool';

--- ЗАДАНИЕ 11 ---
select USERNAME, SERVICE_NAME, SERVER from V$SESSION where TYPE = 'USER';
select *  from V$SESSION where USERNAME is not null;

--- ЗАДАНИЕ 12 ---
select * from V$PROCESS where BACKGROUND=1;
select name, DESCRIPTION from V$bgPROCESS;

--- ЗАДАНИЕ 13 ---
select * from V$PROCESS inner join V$SESSION
    on V$PROCESS.ADDR = V$SESSION.PADDR where STATUS='ACTIVE' and (V$PROCESS.BACKGROUND = 0 or V$PROCESS.BACKGROUND is null);

--- ЗАДАНИЕ 14 ---
select * from V$PROCESS where PNAME like 'DBW%';
select count(*) as count_DBWn from V$PROCESS where PNAME like 'DBW%';
-- можно еще через параметры(db_writer_processes)
select * from V$PARAMETER where NAME='db_writer_processes';
-- можно через sqlplus

--- ЗАДАНИЕ 15 ---
select SERVICE_ID, name, NETWORK_NAME, PDB from V$SERVICES;
select * from V$ACTIVE_SERVICES;

--- ЗАДАНИЕ 16 ---
select * from V$PARAMETER where NAME like '%dispatcher%';
-- также можно через sqlplus

--- ЗАДАНИЕ 17 ---
-- ну вообще смотрим через services.msc, там ищем OracleOraDB21Home1TNSListener

--- ЗАДАНИЕ 18 ---
-- тут ищем в C:\app\USER\product\21c\dbhomeXE\network\admin\sample
-- или тут C:\app\USER\product\21c\homes\OraDB21Home1\network\admin

--- ЗАДАНИЕ 19 ---
-- ну тут через утилиту lsnrctl

--- ЗАДАНИЕ 20 ---
-- тут можно через утилиту lsnrctl services LISTENER
