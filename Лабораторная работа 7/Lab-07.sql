--- ЗАДАНИЕ 1 ---
-- ну тут по факту для заданий 2-6 нужно дать привилегии
-- на создание последовательностей(ну и пусть будет на удаление)
grant create sequence, drop any sequence to PIDCORE;
-- далее для заданий 8, 10-12, 16 нужно дать привилегии
-- на создание таблиц(ну и пусть будет на удаление)
grant create any table, drop any table to PIDCORE;
-- далее для задания 9 нужно дать привилегии
-- на создание кластера(ну и пусть будет на удаление)
grant create any cluster, drop any cluster to PIDCORE;
-- далее для заданий 14-15 нужно дать привилегии на
-- создание синонимов(частных и публичных, ну а также
-- дадим еще привилегии на удаление)
grant create any synonym, drop any synonym to PIDCORE;
grant create public synonym, drop public synonym to PIDCORE;
-- так, далее для заданий 16-17 нужно дать привилегии на
-- создание представлений(просто и материализованных, ну а также
-- -- дадим еще привилегии на удаление)
grant create any view, drop any view to PIDCORE;
grant create any materialized view, drop any materialized view to PIDCORE;
-- ну еще нам нужно дать привилегии на просмотр некоторых системных представлений(это нужно сделать через sqlplus, у system не хватит
-- привилегий на это)
grant select on DBA_CLUSTERS to PIDCORE;
grant select on DBA_TABLES to PIDCORE;
grant select on DBA_SEQUENCES to PIDCORE;
grant select on DBA_VIEWS to PIDCORE;
grant select on DBA_SYNONYMS to PIDCORE;
GRANT EXECUTE ON DBMS_MVIEW TO PIDCORE;
-- а ну еще для таблиц нам нужна будет вставка и удаление
grant insert any table, delete any table to PIDCORE;

-- и еще нам для материализованного представления, для установки времени обновления нужна эта привилегия
GRANT CREATE JOB TO PIDCORE;

-- после предоставления проверим привилегии(все остальные действия выполняем под подключением PIDCORE_XEPDB1)
select * from USER_SYS_PRIVS;
select * from USER_TS_QUOTAS;

--- ЗАДАНИЕ 2 ---
create sequence PIDCORE.s1
start with 1000
increment by 10
nominvalue
nomaxvalue
nocycle
nocache
noorder;

select PIDCORE.s1.nextval from dual;
select PIDCORE.s1.currval from dual;

--- ЗАДАНИЕ 3-4 ---
create sequence PIDCORE.s2
start with 10
increment by 10
maxvalue 100
nocycle;

-- тут при попытке выйти за maxvalue будет ошибка(логично)
select PIDCORE.s2.nextval from dual; -- будем выполнять несколько раз
select PIDCORE.s2.currval from dual;

--- ЗАДАНИЕ 5 ---
create sequence PIDCORE.s3
start with 10
increment by -10
maxvalue 10
minvalue -100
nocycle
order;
-- тут при попытке выйти за minvalue будет ошибка(логично)
select PIDCORE.s3.nextval from dual; -- будем выполнять несколько раз
select PIDCORE.s3.currval from dual;

--- ЗАДАНИЕ 6 ---
create sequence PIDCORE.s4
start with 1
increment by 1
maxvalue 10 -- там в задание написано minvalue, но это не совсем логично(наверное опечатка в задании))
cycle
cache 5
noorder;

select PIDCORE.s4.nextval from dual; -- будем выполнять несколько раз
select PIDCORE.s4.currval from dual;

--- ЗАДАНИЕ 7 ---
select * from USER_SEQUENCES;
-- или так(так как мы дали привилегии на просмотр этого представления)
select * from DBA_SEQUENCES where SEQUENCE_OWNER='PIDCORE';

--- ЗАДАНИЕ 8 ---
drop table PIDCORE.T1;
create table PIDCORE.T1(
N1 NUMBER(20),
N2 NUMBER(20),
N3 NUMBER(20),
N4 NUMBER(20)
)
cache
storage (buffer_pool keep);

-- давайте еще сбросим наши последовательности на начало
alter sequence PIDCORE.s1 restart start with 1000;
alter sequence PIDCORE.s2 restart start with 10;
alter sequence PIDCORE.s3 restart start with 10;
alter sequence PIDCORE.s4 restart start with 1;

--- можно так
begin
    for i in 0..6
    loop
        insert into PIDCORE.T1 values (PIDCORE.s1.nextval, PIDCORE.s2.nextval, PIDCORE.s3.nextval, PIDCORE.s4.nextval);
    end loop;
end;

-- или так
insert into PIDCORE.T1 values (PIDCORE.s1.nextval, PIDCORE.s2.nextval, PIDCORE.s3.nextval, PIDCORE.s4.nextval);
insert into PIDCORE.T1 values (PIDCORE.s1.nextval, PIDCORE.s2.nextval, PIDCORE.s3.nextval, PIDCORE.s4.nextval);
insert into PIDCORE.T1 values (PIDCORE.s1.nextval, PIDCORE.s2.nextval, PIDCORE.s3.nextval, PIDCORE.s4.nextval);
insert into PIDCORE.T1 values (PIDCORE.s1.nextval, PIDCORE.s2.nextval, PIDCORE.s3.nextval, PIDCORE.s4.nextval);
insert into PIDCORE.T1 values (PIDCORE.s1.nextval, PIDCORE.s2.nextval, PIDCORE.s3.nextval, PIDCORE.s4.nextval);
insert into PIDCORE.T1 values (PIDCORE.s1.nextval, PIDCORE.s2.nextval, PIDCORE.s3.nextval, PIDCORE.s4.nextval);
insert into PIDCORE.T1 values (PIDCORE.s1.nextval, PIDCORE.s2.nextval, PIDCORE.s3.nextval, PIDCORE.s4.nextval);

select * from PIDCORE.T1;

--- ЗАДАНИЕ 9 ---
create cluster PIDCORE.ABC(
    X number(10),
    V varchar2(12)
)
hashkeys 200;

--- ЗАДАНИЕ 10 ---
create table PIDCORE.A(
XA NUMBER(10),
VA VARCHAR2(12),
BA NUMBER(5)
)
cluster PIDCORE.ABC(XA, VA);

--- ЗАДАНИЕ 11 ---
create table PIDCORE.B(
XB NUMBER(10),
VB VARCHAR2(12),
BB NUMBER(5)
)
cluster PIDCORE.ABC(XB, VB);

--- ЗАДАНИЕ 12 ---
create table PIDCORE.C(
XС NUMBER(10),
VС VARCHAR2(12),
BС NUMBER(5)
)
cluster PIDCORE.ABC(XС, VС);

--- ЗАДАНИЕ 13 ---
select * from USER_CLUSTERS;
-- или так(так как мы дали привилегии на просмотр этого представления)
select * from DBA_CLUSTERS where OWNER='PIDCORE';

select * from USER_TABLES;
-- или так(так как мы дали привилегии на просмотр этого представления)
select * from DBA_TABLES where OWNER='PIDCORE';

--- ЗАДАНИЕ 14 ---
drop synonym PIDCORE.CC;
create synonym PIDCORE.CC for PIDCORE.C;
select * from PIDCORE.CC;

--- ЗАДАНИЕ 15 ---
drop public synonym BB;
create public synonym BB for PIDCORE.B;
select * from BB; -- так как синоним публичный, то мы можем обратиться и не только от PIDCORE

--- ЗАДАНИЕ 16 ---
drop table PIDCORE.B1;
drop table PIDCORE.A1;
create table PIDCORE.A1(
  XA number(10),
  constraint pk_XA primary key (XA),
  YA number(10)
);

create table PIDCORE.B1(
  XB number(10),
  constraint fk_XB_XA foreign key (XB) references PIDCORE.A1(XA),
  YB number(10)
);

insert into PIDCORE.A1 values (1, 1);
insert into PIDCORE.A1 values (2, 2);
insert into PIDCORE.A1 values (3, 3);

insert into PIDCORE.B1 values (1, 3);
insert into PIDCORE.B1 values (2, 2);
insert into PIDCORE.B1 values (3, 1);

drop view PIDCORE.V1;
create view PIDCORE.V1 as select * from PIDCORE.A1 inner join PIDCORE.B1
on PIDCORE.A1.XA = PIDCORE.B1.XB;

select * from PIDCORE.V1;

--- ЗАДАНИЕ 17 ---
drop materialized view PIDCORE.MV;
create materialized view PIDCORE.MV
tablespace TS_PID
refresh complete
start with sysdate
next sysdate + interval '2' MINUTE
with primary key
as select XA, XB, YA, YB from PIDCORE.A1 inner join PIDCORE.B1
on PIDCORE.A1.XA = PIDCORE.B1.XB;

delete from PIDCORE.B1 where XB=4;
delete from PIDCORE.A1 where XA=4;
commit;

select * from PIDCORE.V1;
select * from PIDCORE.MV;
insert into PIDCORE.A1 values (4, 4);
insert into PIDCORE.B1 values (4, 0);
commit;
select * from PIDCORE.MV;
select * from user_mviews;
ALTER MATERIALIZED VIEW PIDCORE.MV COMPILE;
begin
DBMS_MVIEW.REFRESH('MV');
end;