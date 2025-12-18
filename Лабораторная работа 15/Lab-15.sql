---- задание 1-2 ----
-- это под подключением
create table test(
    name varchar2(100),
    num number
);
select * from user_TABLES;
select * from test;

-- это под своим
drop database link  BSTULINK;

create database link BSTULINK
connect to C##DIA
identified by "123"
using '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=172.16.13.248)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=ORCL)))';

select * from test@BSTULINK;

insert into test@BSTULINK(name, num) values ('test1', 1);
insert into test@BSTULINK(name, num) values ('test2', 2);
insert into test@BSTULINK(name, num) values ('test3', 3);
commit;

update test@BSTULINK set num = num + 1 where 1 = 1;
commit;

delete from test@BSTULINK where 1 = 1;
commit;

create or replace procedure select_data(num_buf number) is
    name_buf varchar2(100);
begin
    select name into name_buf from test@BSTULINK where num = num_buf;
    DBMS_OUTPUT.PUT_LINE(name_buf);
    exception
        when others then
            DBMS_OUTPUT.PUT_LINE('NO');
end;

create or replace function return_data(num_buf number)
return varchar2 is
    name_buf varchar2(100);
begin
    select name into name_buf from test@BSTULINK where num = num_buf;
    return name_buf;
    exception
        when others then
            return 'NO';
end;

begin
    select_data(2);
    DBMS_OUTPUT.PUT_LINE(return_data(1));
end;

---- задание 3-4 ----
drop public database link PBSTULINK;

create public database link PBSTULINK
connect to C##DIA
identified by "123"
using '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=172.16.13.248)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=ORCL)))';


select * from test@PBSTULINK;

insert into test@PBSTULINK(name, num) values ('test1', 1);
insert into test@PBSTULINK(name, num) values ('test2', 2);
insert into test@PBSTULINK(name, num) values ('test3', 3);
commit;

update test@PBSTULINK set num = num + 1 where 1 = 1;
commit;

delete from test@PBSTULINK where 1 = 1;
commit;

create or replace procedure select_data2(num_buf number) is
    name_buf varchar2(100);
begin
    select name into name_buf from test@PBSTULINK where num = num_buf;
    DBMS_OUTPUT.PUT_LINE(name_buf);
    exception
        when others then
            DBMS_OUTPUT.PUT_LINE('NO');
end;

create or replace function return_data2(num_buf number)
return varchar2 is
    name_buf varchar2(100);
begin
    select name into name_buf from test@PBSTULINK where num = num_buf;
    return name_buf;
    exception
        when others then
            return 'NO';
end;

begin
    select_data2(2);
    DBMS_OUTPUT.PUT_LINE(return_data2(1));
end;


select * from v$pdbs;