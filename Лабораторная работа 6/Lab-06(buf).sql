--- ЗАДАНИЕ 2 ---
select * from V$PDBS;
select * from DBA_TABLESPACES;
select TABLESPACE_NAME, CONTENTS, SEGMENT_SPACE_MANAGEMENT from DBA_TABLESPACES;
select * from DBA_DATA_FILES;
select FILE_Name, TABLESPACE_NAME, STATUS, ONLINE_STATUS from DBA_DATA_FILES;
select * from DBA_TEMP_FILES;
select FILE_Name, TABLESPACE_NAME, STATUS, SHARED from DBA_TEMP_FILES;
select * from DBA_ROLES;
select ROLE, ROLE_ID, COMMON, AUTHENTICATION_TYPE from DBA_ROLES;
select * from DBA_USERS;
select USERNAME, USER_ID, DEFAULT_TABLESPACE, TEMPORARY_TABLESPACE, PROFILE, COMMON, ACCOUNT_STATUS from DBA_USERS;

--- ЗАДАНИЕ 7 ---
-- это нужно делать от PIDCORE в XEPDB1
select * from USER_TABLES;
select TABLE_NAME, TABLESPACE_NAME, STATUS from USER_TABLES;

--- ЗАДАНИЕ 10 ---
select * from USER_SEGMENTS;
select SEGMENT_NAME from USER_SEGMENTS;

--- ЗАДАНИЕ 11 ---
create view segment_view as select
count(*) as segment_count, sum(EXTENTS) as extent_count, sum(BLOCKS) as block_count, (sum(BYTES) / 1024) size_k from USER_SEGMENTS;

select * from segment_view;

select * from TAB_PIDCORE;