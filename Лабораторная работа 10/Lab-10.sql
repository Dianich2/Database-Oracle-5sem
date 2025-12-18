--- ЗАДАНИЕ 1 ---
alter table TEACHER add BIRTHDAY date;
alter table TEACHER add SALARY number(20, 4);

update teacher set birthday = to_date('1958-01-01', 'yyyy-mm-dd'), salary = 3200 where teacher = 'СМЛВ';
update teacher set birthday = to_date('1985-02-15', 'yyyy-mm-dd'), salary = 2450 where teacher = 'ДТК';
update teacher set birthday = to_date('1978-03-22', 'yyyy-mm-dd'), salary = 2600.4 where teacher = 'УРБ';
update teacher set birthday = to_date('1990-04-10', 'yyyy-mm-dd'), salary = 2200.55 where teacher = 'ГРН';
update teacher set birthday = to_date('1982-05-05', 'yyyy-mm-dd'), salary = 3005.78 where teacher = 'ЖЛК';
update teacher set birthday = to_date('1989-06-30', 'yyyy-mm-dd'), salary = 2332.56 where teacher = 'МРЗ';
update teacher set birthday = to_date('1981-07-20', 'yyyy-mm-dd'), salary = 2198.54 where teacher = 'БРТШВЧ';
update teacher set birthday = to_date('1975-08-15', 'yyyy-mm-dd'), salary = 2374.5 where teacher = 'АРС';
update teacher set birthday = to_date('1983-09-01', 'yyyy-mm-dd'), salary = 1948.99 where teacher = 'НВРВ';
update teacher set birthday = to_date('1984-10-10', 'yyyy-mm-dd'), salary = 1848.23 where teacher = 'РВКЧ';
update teacher set birthday = to_date('1992-11-11', 'yyyy-mm-dd'), salary = 1749.67 where teacher = 'ДМДК';
update teacher set birthday = to_date('1980-12-12', 'yyyy-mm-dd'), salary = 1829.29 where teacher = 'БРГ';
update teacher set birthday = to_date('1976-01-20', 'yyyy-mm-dd'), salary = 2185.46 where teacher = 'РЖК';
update teacher set birthday = to_date('1987-02-25', 'yyyy-mm-dd'), salary = 2381.43 where teacher = 'ЗВГЦВ';
update teacher set birthday = to_date('1985-03-30', 'yyyy-mm-dd'), salary = 1697.25 where teacher = 'БЗБРДВ';
update teacher set birthday = to_date('1991-04-05', 'yyyy-mm-dd'), salary = 1439.26 where teacher = 'НСКВЦ';

select * from TEACHER;

--- ЗАДАНИЕ 2 ---
select regexp_substr(TEACHER_NAME, '(\S+)', 1) || ' ' ||
       substr(regexp_substr(TEACHER_NAME, '(\S+)', 1, 2), 1, 1) || '.' ||
       substr(regexp_substr(TEACHER_NAME, '(\S+)', 1, 3), 1, 1) || '.'
from TEACHER;

--- ЗАДАНИЕ 3 ---
select * from (select TEACHER, TEACHER_NAME, GENDER, PULPIT, BIRTHDAY, SALARY, to_char(BIRTHDAY, 'DAY') as dayname from TEACHER)
buf where dayname = 'ПОНЕДЕЛЬНИК';

--- ЗАДАНИЕ 4 ---
drop view teacher_birthday_next_month;
create view teacher_birthday_next_month as
    select TEACHER, TEACHER_NAME, GENDER, PULPIT, BIRTHDAY, SALARY, to_char(BIRTHDAY, 'MONTH') as monthname from TEACHER where to_char(BIRTHDAY, 'MONTH') = to_char(add_months(sysdate, 1), 'MONTH');

select * from teacher_birthday_next_month;

--- ЗАДАНИЕ 5 ---
-- ну тут наверное удобно и прикольно будет использовать CTE и иерархию
create view teacher_birthday_count_per_month as
WITH months AS (
  select to_char(add_months(trunc(sysdate, 'YEAR'), level-1), 'MONTH') as month_name from dual
  connect by level <= 12
)
select m.month_name , count(*) as count_birthday
from TEACHER t inner join months m on to_char(t.BIRTHDAY, 'MONTH') = m.month_name group by m.month_name;

select * from teacher_birthday_count_per_month;

--- ЗАДАНИЕ 6 ---
-- как-нибудь пойму, что я тут имела в виду
declare
    cursor teacher_cursor is select * from TEACHER
           where (
                  (( extract(month from BIRTHDAY) < extract(month from sysdate) or
                    (extract(month from BIRTHDAY) = extract(month from sysdate) and extract(day from BIRTHDAY) < extract(day from sysdate))
                  ) and mod(floor(months_between(sysdate, BIRTHDAY) / 12) + 1, 5) = 0)
                  or
                  (( extract(month from BIRTHDAY) > extract(month from sysdate) or
                    (extract(month from BIRTHDAY) = extract(month from sysdate) and extract(day from BIRTHDAY) > extract(day from sysdate))
                  ) and mod(floor(months_between(sysdate, BIRTHDAY) / 12) + 2, 5) = 0)
                 );
    rec_teacher teacher_cursor%rowtype;
begin
    for rec_teacher in teacher_cursor
    loop
        dbms_output.put_line('teacher = ' || rtrim(rec_teacher.TEACHER) ||
                             ', teacher_name = ' || rtrim(rec_teacher.TEACHER_NAME) ||
                             ', gender = ' || rtrim(rec_teacher.GENDER) ||
                             ', pulpit = ' || rtrim(rec_teacher.PULPIT) ||
                             ', birthday = ' || to_char(rec_teacher.BIRTHDAY, 'dd-mm-yyyy') ||
                             ', salary = ' || rec_teacher.SALARY);
    end loop;
end;

--- ЗАДАНИЕ 7 ---
declare
    cursor salary_cursor is select f.FACULTY,
           cursor (
               select p.PULPIT, floor(avg(t.SALARY)) as av_salary from PULPIT p inner join TEACHER t on p.PULPIT = t.PULPIT
                                                                  where f.FACULTY = p.FACULTY group by p.PULPIT)
    from FACULTY f;

    faculty_v FACULTY.FACULTY%type;
    pulpit_v PULPIT.PULPIT%type;
    salary_v TEACHER.SALARY%type;
    pulp_cursor sys_refcursor;
    buf_salary TEACHER.SALARY%type := 0;
    all_salary TEACHER.SALARY%type := 0;
begin
    open salary_cursor;
    fetch salary_cursor into faculty_v, pulp_cursor;
    while salary_cursor%found
    loop
        dbms_output.put_line('faculty = ' || rtrim(faculty_v));
        loop
            fetch pulp_cursor into pulpit_v, salary_v;
            exit when pulp_cursor%notfound;
            dbms_output.put_line('pulpit = ' || rtrim(pulpit_v) ||
                                 ', avg_pulpit_salary = ' || salary_v);
            buf_salary := buf_salary + salary_v;
        end loop;
        dbms_output.put_line('avg_faculty_salary = ' || buf_salary);
        dbms_output.new_line();
        all_salary := all_salary + buf_salary;
        buf_salary := 0;
        fetch salary_cursor into faculty_v, pulp_cursor;
    end loop;
    close salary_cursor;
    dbms_output.put_line('avg_faculties_salary = ' || all_salary);
end;

--- ЗАДАНИЕ 8 ---
declare
    TYPE pulp_type is record(
        pulpit char(20),
        pulpit_name varchar2(200)
    );

    type subj_type is record(
      subject char(20),
      subject_name varchar2(200),
      pulpit pulp_type
    );

    subj_1 subj_type;
    subj_2 subj_type;
begin
    subj_1.subject := 'БД';
    subj_1.subject_name := 'Базы данных';
    subj_1.pulpit.pulpit := 'ИСиТ';
    subj_1.pulpit.pulpit_name := 'Информационные системы и технологии';

    subj_2 := subj_1;
    subj_2.pulpit.pulpit := 'ПИ';
    subj_2.pulpit.pulpit_name := 'Программная инженерия';

    dbms_output.put_line('subj_1');
    dbms_output.put_line('subject = ' || rtrim(subj_1.subject) ||
                         ', subject_name = ' || rtrim(subj_1.subject_name) ||
                         ', pulpit = ' || rtrim(subj_1.pulpit.pulpit) ||
                         ', pulpit_name = ' || rtrim(subj_1.pulpit.pulpit_name));
    dbms_output.put_line('subj_2');
    dbms_output.put_line('subject = ' || rtrim(subj_2.subject) ||
                         ', subject_name = ' || rtrim(subj_2.subject_name) ||
                         ', pulpit = ' || rtrim(subj_2.pulpit.pulpit) ||
                         ', pulpit_name = ' || rtrim(subj_2.pulpit.pulpit_name));
end;






