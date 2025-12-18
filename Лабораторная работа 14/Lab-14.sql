--- ЗАДАНИЕ 1-5 ---
drop table table_source;
drop table table_dest;
drop table table_copystatus;

create table table_source(
    num int,
    time_v date
);

create table table_dest(
    num int,
    time_v date
);

create table table_copystatus(
    date_v date,
    isSuccessful varchar2(3) check ( isSuccessful = 'YES' or isSuccessful = 'NO'),
    error_m varchar2(300)
);

create or replace package COPY_DATA_PACKAGE as
    procedure COPY_DATA_;
    procedure standart_run;
    procedure user_run;
    procedure user_pause;
    procedure user_continue;
    procedure user_cancellation;
    function check_job_status return boolean;
    function GET_JOB_NUM return number;
end COPY_DATA_PACKAGE;


create or replace package body COPY_DATA_PACKAGE as
    mess varchar2(200);
    procedure COPY_DATA_ is
    begin
        insert into table_dest select num, time_v from table_source where num < 200;
        delete from table_source where num < 200;
        insert into table_copystatus values (sysdate, 'YES', NULL);
        commit;
        exception
            when others then
                rollback;
                mess := sqlerrm;
                insert into table_copystatus values (sysdate, 'NO', mess);
                commit;
    end COPY_DATA_;

    function GET_JOB_NUM return number is
        num number := null;
    begin
        select count(*) into num from user_JOBS where WHAT = 'begin COPY_DATA_PACKAGE.COPY_DATA_; end;';
        if num <> 0 then
            select job into num from user_JOBS where WHAT = 'begin COPY_DATA_PACKAGE.COPY_DATA_; end;';
        else
            num := null;
        end if;
        return num;
    end GET_JOB_NUM;

    procedure standart_run is
        num_job number := null;
    begin
        num_job := GET_JOB_NUM();
        if num_job is null then
        dbms_job.submit(
            num_job,
            'begin COPY_DATA_PACKAGE.COPY_DATA_; end;',
            trunc(NEXT_DAY(SYSDATE, 'ВТОРНИК'), 'dd') + 11/24,
            'trunc(NEXT_DAY(SYSDATE, ''ВТОРНИК''), ''dd'') + 7'
        );
        commit;
        else
            raise_application_error(-20222, 'Job already exists. Num this job is ' || num_job);
        end if;
        exception
            when others then
                dbms_output.put_line('error: ' || sqlerrm);
    end standart_run;

    procedure user_run is
        num_job number := null;
    begin
         num_job := GET_JOB_NUM();
        if num_job is null then
        dbms_job.submit(
            num_job,
            'begin COPY_DATA_PACKAGE.COPY_DATA_; end;',
            sysdate + interval '1' minute - interval '3' hour,
            'sysdate + 7'
        );
        commit;
        else
            raise_application_error(-20222, 'Job already exists. Num this job is ' || num_job);
        end if;
        exception
            when others then
                dbms_output.put_line('error: ' || sqlerrm);
    end user_run;

    procedure user_pause is
    num_job number := null;
    begin
        num_job := GET_JOB_NUM();
        if num_job is not null then
            dbms_job.broken(num_job, true);
        else
            raise_application_error(-20223, 'Job does not exist.');
        end if;
        commit;
        exception
            when others then
                dbms_output.put_line('error: ' || sqlerrm);
    end user_pause;

    procedure user_cancellation is
     num_job number := null;
    begin
         num_job := GET_JOB_NUM();
        if num_job is not null then
            dbms_job.remove(num_job);
        else
            raise_application_error(-20223, 'Job does not exist.');
        end if;
        commit;
        exception
            when others then
                dbms_output.put_line('error: ' || sqlerrm);
    end user_cancellation;

     procedure user_continue is
     num_job number := null;
    begin
         num_job := GET_JOB_NUM();
        if num_job is not null then
            dbms_job.broken(num_job, false);
        else
            raise_application_error(-20223, 'Job does not exist.');
        end if;
        commit;
        exception
            when others then
                dbms_output.put_line('error: ' || sqlerrm);
    end user_continue;

    function check_job_status return boolean is
     num_job number := null;
    begin
         num_job := GET_JOB_NUM();
        if num_job is null then
            return false;
        end if;
        return true;
    end check_job_status;
end;

select * from table_source;
select * from table_dest;
select * from table_copystatus;
select * from user_JOBS;
grant Create any job, create any procedure, drop any procedure, execute any procedure to PIDCORE;

select * from DBA_SYS_PRIVS where GRANTEE = 'SYS';

insert into table_source values (1, date'2025-01-10');
insert into table_source values (2, date'2025-01-10');
insert into table_source values (222, date'2025-01-10');
insert into table_source values (22, date'2025-01-10');

truncate table table_source;
truncate table table_dest;


begin
    --COPY_DATA_PACKAGE.standart_run();
--     if COPY_DATA_PACKAGE.check_job_status() then
--         dbms_output.put_line('exists');
--     else
--         dbms_output.put_line('not exists');
--     end if;
    --COPY_DATA_PACKAGE.user_pause();
    --COPY_DATA_PACKAGE.user_continue();
    COPY_DATA_PACKAGE.user_cancellation();
    --COPY_DATA_PACKAGE.user_run();
    --dbms_job.REMOVE(100);

--     dbms_job.submit(
--             num_job,
--             'begin COPY_DATA_PACKAGE.COPY_DATA_; end;',
--             trunc(NEXT_DAY(SYSDATE, 'ВТОРНИК'), 'dd') + 11/24,
--             'trunc(NEXT_DAY(SYSDATE, ''ВТОРНИК''), ''dd'') + 7'
--     );
end;

    create or replace function GET_JOB_NUM return number is
        num number := null;
    begin
        select count(*) into num from USER_JOBS where WHAT = '%begin COPY_DATA_PACKAGE.COPY_DATA_; end;%';
        if num <> 0 then
            select job into num from USER_JOBS where WHAT = '%begin COPY_DATA_PACKAGE.COPY_DATA_; end;%';
        else
            num := null;
        end if;
        return num;
    end GET_JOB_NUM;

    create or replace procedure standart_run is
        num_job number := null;
    begin
        num_job := GET_JOB_NUM();
        DBMS_OUTPUT.PUT_LINE(num_job);
        if num_job is null then
        dbms_job.submit(
            num_job,
            'begin COPY_DATA_PACKAGE.COPY_DATA_; end;',
            trunc(NEXT_DAY(SYSDATE, 'ВТОРНИК'), 'dd') + 11/24,
            'trunc(NEXT_DAY(SYSDATE, ''ВТОРНИК''), ''dd'') + 7'
        );
        commit;
        else
            raise_application_error(-20222, 'Job already exists. Num this job is ' || num_job);
        end if;
        exception
            when others then
                dbms_output.put_line('error: ' || sqlerrm);
    end standart_run;

    create or replace procedure user_run is
        num_job number := null;
    begin
         num_job := GET_JOB_NUM();
        if num_job is null then
        dbms_job.submit(
            num_job,
            'begin COPY_DATA_PACKAGE.COPY_DATA_; end;',
            sysdate + interval '1' minute - interval '3' hour,
            'sysdate + 7'
        );
        commit;
        else
            raise_application_error(-20222, 'Job already exists. Num this job is ' || num_job);
        end if;
        exception
            when others then
                dbms_output.put_line('error: ' || sqlerrm);
    end user_run;

-- GRANT CREATE JOB TO PIDCORE;
-- GRANT MANAGE SCHEDULER TO PIDCORE;
-- GRANT EXECUTE ON DBMS_JOB TO PIDCORE;
-- GRANT EXECUTE ON DBMS_SCHEDULER TO PIDCORE;

-- begin
--     user_run();
-- end;

select  * from USER_JOBS;




-- дадим пользователю привилегию
grant MANAGE SCHEDULER to PIDCORE;
select * from USER_SYS_PRIVS;

--- ЗАДАНИЕ 6 ---

create or replace package COPY_DATA_PACKAGE_SH as
    procedure COPY_DATA_;
    procedure standart_run;
    procedure user_run(da in timestamp with time zone);
    procedure user_pause;
    procedure user_continue;
    procedure user_cancellation;
    function is_Exist return boolean;
end COPY_DATA_PACKAGE_SH;


create or replace package body COPY_DATA_PACKAGE_SH as
    mess varchar2(200);
    procedure COPY_DATA_ is
    begin
        insert into table_dest select num, time_v from table_source where num < 200;
        delete from table_source where num < 200;
        insert into table_copystatus values (sysdate, 'YES', NULL);
        exception
            when others then
                rollback;
                mess := sqlerrm;
                insert into table_copystatus values (sysdate, 'NO', mess);
                commit;
    end COPY_DATA_;

    function is_Exist return boolean is
        num number := null;
    begin
        select count(*) into num from USER_SCHEDULER_JOBS where JOB_NAME = 'COPY_JOB';
        if num <> 0 then
            return true;
        end if;
        return false;
    end is_Exist;

    procedure standart_run is
    begin
        if not is_Exist() then
        dbms_scheduler.create_job(
            'COPY_JOB',
            'PLSQL_BLOCK',
            'begin COPY_DATA_PACKAGE_SH.COPY_DATA_(); end;',
            start_date => cast(trunc(next_day(systimestamp, 'ВТОРНИК')) as timestamp) + interval '14' hour,
            repeat_interval => 'FREQ=WEEKLY; BYDAY=TUE; BYHOUR=14',
            enabled => true,
            auto_drop => false
        );
        commit;
        else
            raise_application_error(-20222, 'Job already exists.');
        end if;
        exception
            when others then
                dbms_output.put_line('error: ' || sqlerrm);
    end standart_run;

    procedure user_run(da timestamp with time zone) is
    begin
        if not is_Exist() then
        dbms_scheduler.create_job(
            'COPY_JOB',
            'PLSQL_BLOCK',
            'begin COPY_DATA_PACKAGE_SH.COPY_DATA_(); end;',
            start_date => greatest(da, systimestamp + interval '1' minute),
            repeat_interval => 'FREQ=WEEKLY; INTERVAL=1',
            enabled => true,
            auto_drop => false
        );
        commit;
        else
            raise_application_error(-20222, 'Job already exists.');
        end if;
        exception
            when others then
                dbms_output.put_line('error: ' || sqlerrm);
    end user_run;

    procedure user_pause is
    begin
        if is_Exist() then
            dbms_scheduler.disable('COPY_JOB', true);
        else
            raise_application_error(-20223, 'Job does not exist.');
        end if;
        commit;
        exception
            when others then
                dbms_output.put_line('error: ' || sqlerrm);
    end user_pause;

    procedure user_cancellation is
    begin
        if is_Exist() then
            dbms_scheduler.drop_job('COPY_JOB', true);
        else
            raise_application_error(-20223, 'Job does not exist.');
        end if;
        commit;
        exception
            when others then
                dbms_output.put_line('error: ' || sqlerrm);
    end user_cancellation;

     procedure user_continue is
     begin
         if is_Exist() then
            dbms_scheduler.enable('COPY_JOB');
        else
            raise_application_error(-20223, 'Job does not exist.');
        end if;
        commit;
        exception
            when others then
                dbms_output.put_line('error: ' || sqlerrm);
    end user_continue;
end;

select * from table_source;
select * from table_dest;
select * from table_copystatus;
select job_name, enabled, state, last_start_date, next_run_date, run_count
from user_scheduler_jobs
where job_name = 'COPY_JOB';

select * from NLS_SESSION_PARAMETERS;

insert into table_source values (1, date'2025-01-10');
insert into table_source values (2, date'2025-01-10');
insert into table_source values (222, date'2025-01-10');
insert into table_source values (22, date'2025-01-10');

truncate table table_source;
truncate table table_dest;

begin
    --COPY_DATA_PACKAGE_SH.standart_run();
--     if COPY_DATA_PACKAGE_SH.is_Exist() then
--         dbms_output.put_line('exists');
--     else
--         dbms_output.put_line('not exists');
--     end if;
    --COPY_DATA_PACKAGE_SH.user_pause();
    --COPY_DATA_PACKAGE_SH.user_continue();
    --COPY_DATA_PACKAGE_SH.user_cancellation();
    COPY_DATA_PACKAGE_SH.user_run(systimestamp + interval '1' minute);
end;


-- select * from USER_SCHEDULER_JOB_LOG where JOB_NAME = 'COPY_JOB'

select * from V$PARAMETER where NAME like 'max_%' order by  name;
