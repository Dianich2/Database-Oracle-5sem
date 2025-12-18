alter database datafile 'C:\app\USER\product\21c\dbhomeXE\oradata\Tablespaces\TS_PID.dbf'
    AUTOEXTEND ON NEXT 5 m maxsize 300m;

--- ЗАДАНИЕ 1 ---
drop table T_RANGE;
create table T_RANGE (
    num number,
    time date
)
partition by range (num)(
    partition range0 values less than (20),
    partition range1 values less than (40),
    partition range2 values less than (60),
    partition range3 values less than (80),
    partition range4 values less than (maxvalue)
);

select * from USER_TABLES where table_name = 'T_RANGE';
select * from USER_TAB_PARTITIONS where TABLE_NAME = 'T_RANGE';

--- ЗАДАНИЕ 2 ---
drop table T_INTERVAL;
create table T_INTERVAL (
    num number,
    time date
)
partition by range (time)
interval (interval '1' month)
(
    partition range_min values less than (date '2025-01-01'),
    partition range_1 values less than (date '2025-02-01'),
    partition range_2 values less than (date '2025-03-01')
);

select * from USER_TABLES where table_name = 'T_INTERVAL';
select * from USER_TAB_PARTITIONS where TABLE_NAME = 'T_INTERVAL';

--- ЗАДАНИЕ 3 ---
drop table T_HASH;
create table T_HASH (
    num number,
    vstr varchar2(200)
)
partition by hash (vstr)
(
    partition range0,
    partition range1,
    partition range2,
    partition range3,
    partition range4
);

select * from USER_TABLES where table_name = 'T_HASH';
select * from USER_TAB_PARTITIONS where TABLE_NAME = 'T_HASH';

--- ЗАДАНИЕ 4 ---
drop table T_LIST;
create table T_LIST (
    num number,
    ch char(22)
)
partition by list (ch)
(
    partition range0 values ('a', 'e'),
    partition range1 values ('f', 'j'),
    partition range2 values ('k', 'o'),
    partition range3 values ('p', 't'),
    partition range4 values ('u', 'z'),
    partition range5 values (default)
);

select * from USER_TABLES where table_name = 'T_LIST';
select * from USER_TAB_PARTITIONS where TABLE_NAME = 'T_LIST';

--- ЗАДАНИЕ 5 ---

-- T_RANGE
insert into T_RANGE values (2, date'2025-01-02');
insert into T_RANGE values (22, date'2025-02-02');
insert into T_RANGE values (42, date'2025-03-02');
insert into T_RANGE values (62, date'2025-04-02');
insert into T_RANGE values (82, date'2025-05-02');

select * from T_RANGE;
select * from T_RANGE partition (range0);
select * from T_RANGE partition (range1);
select * from T_RANGE partition (range2);
select * from T_RANGE partition (range3);
select * from T_RANGE partition (range4);

truncate table T_RANGE;


-- T_INTERVAL
insert into T_INTERVAL values (2, date'2024-12-02');
insert into T_INTERVAL values (2, date'2025-01-02');
insert into T_INTERVAL values (22, date'2025-02-02');
insert into T_INTERVAL values (42, date'2025-03-02');
insert into T_INTERVAL values (62, date'2025-04-02');
insert into T_INTERVAL values (82, date'2025-05-02');

select * from T_INTERVAL;
-- тут у нас автоматически добавились партиции, так что посмотрим
select * from USER_TAB_PARTITIONS where TABLE_NAME = 'T_INTERVAL';

select * from T_INTERVAL partition (range_min);
select * from T_INTERVAL partition (range_1);
select * from T_INTERVAL partition (range_2);
select * from T_INTERVAL partition (sys_P3171);
select * from T_INTERVAL partition (sys_P3172);
select * from T_INTERVAL partition (sys_P3173);

truncate table T_INTERVAL;


-- T_HASH
insert into T_HASH values (1, '1111');
insert into T_HASH values (2, '2222');
insert into T_HASH values (3, '4444');
insert into T_HASH values (4, '6666');
insert into T_HASH values (5, '28328');

select * from T_HASH;
select * from T_HASH partition (range0);
select * from T_HASH partition (range1);
select * from T_HASH partition (range2);
select * from T_HASH partition (range3);
select * from T_HASH partition (range4);

select * from USER_TAB_PARTITIONS where TABLE_NAME = 'T_HASH';

truncate table T_HASH;
select ORA_HASH('1111') from dual;

-- T_LIST
insert into T_LIST values (1, 'a');
insert into T_LIST values (2, 'f');
insert into T_LIST values (3, 'k');
insert into T_LIST values (4, 'p');
insert into T_LIST values (5, 'u');
insert into T_LIST values (6, 'e');
insert into T_LIST values (7, 'j');
insert into T_LIST values (8, 'o');
insert into T_LIST values (9, 't');
insert into T_LIST values (10, 'z');
insert into T_LIST values (11, '99');
insert into T_LIST values (12, '00');

select * from T_LIST;
select * from T_LIST partition (range0);
select * from T_LIST partition (range1);
select * from T_LIST partition (range2);
select * from T_LIST partition (range3);
select * from T_LIST partition (range4);
select * from T_LIST partition (range5);

select * from USER_TAB_PARTITIONS where TABLE_NAME = 'T_LIST';

truncate table T_LIST;

--- ЗАДАНИЕ 6 ---

-- T_RANGE
alter table T_RANGE enable row movement;
update T_RANGE partition(range0) set num = num + 30;

select * from T_RANGE;
select * from T_RANGE partition (range0);
select * from T_RANGE partition (range1);
select * from T_RANGE partition (range2);
select * from T_RANGE partition (range3);
select * from T_RANGE partition (range4);

select * from USER_TAB_PARTITIONS where TABLE_NAME = 'T_RANGE';


-- T_INTERVAL
alter table T_INTERVAL enable row movement;
update T_INTERVAL partition(sys_P3172) set time = add_months(time, -2);

select * from USER_TAB_PARTITIONS where TABLE_NAME = 'T_INTERVAL';

select * from T_INTERVAL partition (range_min);
select * from T_INTERVAL partition (range_1);
select * from T_INTERVAL partition (range_2);
select * from T_INTERVAL partition (sys_P3171);
select * from T_INTERVAL partition (sys_P3172);
select * from T_INTERVAL partition (sys_P3173);


-- T_HASH
alter table T_HASH enable row movement;
update T_HASH partition(range0) set vstr = '2020';

select * from T_HASH;
select * from T_HASH partition (range0);
select * from T_HASH partition (range1);
select * from T_HASH partition (range2);
select * from T_HASH partition (range3);
select * from T_HASH partition (range4);


-- T_LIST
alter table T_LIST enable row movement;
update T_LIST partition(range0) set ch = '2020';

select * from T_LIST;
select * from T_LIST partition (range0);
select * from T_LIST partition (range1);
select * from T_LIST partition (range2);
select * from T_LIST partition (range3);
select * from T_LIST partition (range4);
select * from T_LIST partition (range5);


--- ЗАДАНИЕ 7 ---

-- T_RANGE
select * from T_RANGE;
select * from T_RANGE partition (range0);
select * from T_RANGE partition (range1);
select * from T_RANGE partition (range2);
select * from T_RANGE partition (range3);
select * from T_RANGE partition (range4);

alter table T_RANGE merge partitions range0, range1 into partition range01;

select * from USER_TAB_PARTITIONS where TABLE_NAME = 'T_RANGE';

select * from T_RANGE partition (range01);
select * from T_RANGE partition (range2);
select * from T_RANGE partition (range3);
select * from T_RANGE partition (range4);

--- ЗАДАНИЕ 8 ---

-- T_RANGE
select * from T_RANGE partition (range01);
select * from T_RANGE partition (range2);
select * from T_RANGE partition (range3);
select * from T_RANGE partition (range4);

alter table T_RANGE split partition range01 at (20) into (
    partition range0,
    partition range1
);

select * from USER_TAB_PARTITIONS where TABLE_NAME = 'T_RANGE';


select * from T_RANGE;
select * from T_RANGE partition (range0);
select * from T_RANGE partition (range1);
select * from T_RANGE partition (range2);
select * from T_RANGE partition (range3);
select * from T_RANGE partition (range4);

--- ЗАДАНИЕ 9 ---
select * from T_RANGE partition (range0);
select * from T_RANGE partition (range1);
select * from T_RANGE partition (range2);
select * from T_RANGE partition (range3);
select * from T_RANGE partition (range4);

drop table buf;
create table buf(
    num number,
    time date
);
insert into buf values (10, date'2025-10-02');
insert into buf values (12, date'2025-12-02');
select * from buf;

alter table T_RANGE exchange partition range0
with table buf without validation;

select * from T_RANGE partition (range0);
select * from T_RANGE partition (range1);
select * from T_RANGE partition (range2);
select * from T_RANGE partition (range3);
select * from T_RANGE partition (range4);

select * from buf;



-- по приколу типо еще метод--
create table T_SYSTEM (
    id number,
    data_content varchar2(100)
)
partition by system (
    partition part1,
    partition part2,
    partition part3
);

insert into T_SYSTEM partition (part3) values(8, 'wefwef')

select * from user_tab_partitions where table_name = 'T_SYSTEM'

select * from T_SYSTEM partition (part1);
select * from T_SYSTEM partition (part2);
select * from T_SYSTEM partition (part3);