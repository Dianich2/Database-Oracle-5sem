-- дадим пользователю привилегии на работу с процедурами и функциями
grant CREATE ANY PROCEDURE, DROP ANY PROCEDURE, EXECUTE ANY PROCEDURE to PIDCORE;

select * from TEACHER;
--- ЗАДАНИЕ 1 ---
declare
    procedure GET_TEACHERS(PCODE TEACHER.PULPIT%type) is
        cursor teacher_cursor is select * from TEACHER where PULPIT = PCODE;
        rec_teacher TEACHER%rowtype;
        begin
            for rec_teacher in teacher_cursor
            loop
                dbms_output.put_line('teacher = ' || rtrim(rec_teacher.TEACHER) ||
                                     ', teacher_name = ' || rtrim(rec_teacher.TEACHER_NAME) ||
                                     ', gender = ' || rtrim(rec_teacher.gender) ||
                                     ', pulpit = ' || rtrim(rec_teacher.PULPIT) ||
                                     ', birthday = ' || rec_teacher.BIRTHDAY ||
                                     ', salary = ' || rec_teacher.SALARY);
            end loop;
        end;
begin
 GET_TEACHERS('ИСиТ');
end;

select * from TEACHER where PULPIT='ИСиТ';

--- ЗАДАНИЕ 2-3 ---
declare
    function GET_NUM_TEACHERS(PCODE TEACHER.PULPIT%type) return number is
        count_v number(5);
        begin
           select count(*) into count_v from TEACHER where PULPIT = PCODE;
           return count_v;
        end GET_NUM_TEACHERS;
begin
    dbms_output.put_line('GET_NUM_TEACHERS("ИСиТ") = ' || GET_NUM_TEACHERS('ИСиТ'));
end;


select count(*) from TEACHER where PULPIT = 'ИСиТ';

--- ЗАДАНИЕ 4 ---
drop procedure GET_TEACHERS;
create procedure GET_TEACHERS(FCODE FACULTY.FACULTY%type) is
    cursor teacher_cursor is select TEACHER, TEACHER_NAME, GENDER, p.PULPIT, BIRTHDAY, SALARY, p.FACULTY
            from TEACHER t inner join PULPIT p on t.PULPIT = p.PULPIT where p.FACULTY = FCODE;
    rec_teacher teacher_cursor%rowtype;
    begin
        for rec_teacher in teacher_cursor
        loop
            dbms_output.put_line('teacher = ' || rtrim(rec_teacher.TEACHER) ||
                                     ', teacher_name = ' || rtrim(rec_teacher.TEACHER_NAME) ||
                                     ', gender = ' || rtrim(rec_teacher.gender) ||
                                     ', pulpit = ' || rtrim(rec_teacher.PULPIT) ||
                                     ', birthday = ' || rec_teacher.BIRTHDAY ||
                                     ', salary = ' || rec_teacher.SALARY ||
                                     ', faculty = ' || rec_teacher.FACULTY
                                 );

        end loop;
end GET_TEACHERS;

begin
    GET_TEACHERS('ИТ');
end;

drop procedure GET_SUBJECTS;
create procedure GET_SUBJECTS(PCODE SUBJECT.PULPIT%type) is
    cursor subject_cursor is select * from SUBJECT where PULPIT = PCODE;
    rec_subject subject_cursor%rowtype;
    begin
        for rec_subject in subject_cursor
        loop
            dbms_output.put_line('subject = ' || rtrim( rec_subject.SUBJECT) ||
                                     ', subject_name = ' || rtrim( rec_subject.SUBJECT_NAME) ||
                                     ', pulpit = ' || rtrim( rec_subject.PULPIT)
                                 );

        end loop;
end GET_SUBJECTS;

begin
    GET_SUBJECTS('ИСиТ');
end;

--- ЗАДАНИЕ 5 ---
declare
    function GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%type) return number is
        count_v number(3);
    begin
        select count(*) into count_v from TEACHER t inner join PULPIT p
            on t.PULPIT = p.PULPIT where p.FACULTY = FCODE;
        return count_v;
    end GET_NUM_TEACHERS;
begin
    dbms_output.put_line('GET_NUM_TEACHERS("ИТ") = ' || GET_NUM_TEACHERS('ИТ'));
end;

declare
    function GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%type) return number is
        count_v number(3);
    begin
        select count(*) into count_v from SUBJECT where PULPIT = PCODE;
        return count_v;
    end GET_NUM_SUBJECTS;
begin
    dbms_output.put_line('GET_NUM_SUBJECTS("ИСиТ") = ' || GET_NUM_SUBJECTS('ИСиТ'));
end;

--- ЗАДАНИЕ 6 ---
create package TEACHERS_ as
    procedure GET_TEACHERS(FCODE FACULTY.FACULTY%type);
    procedure GET_SUBJECTS(PCODE SUBJECT.PULPIT%type);
    function  GET_NUM_TEACHERS (FCODE FACULTY.FACULTY%type) return number;
    function GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%type) return number;
end TEACHERS_;

create package body TEACHERS_ is
    procedure GET_TEACHERS(FCODE FACULTY.FACULTY%type) is
    cursor teacher_cursor is select TEACHER, TEACHER_NAME, GENDER, p.PULPIT, BIRTHDAY, SALARY, p.FACULTY
            from TEACHER t inner join PULPIT p on t.PULPIT = p.PULPIT where p.FACULTY = FCODE;
    rec_teacher teacher_cursor%rowtype;
    begin
        for rec_teacher in teacher_cursor
        loop
            dbms_output.put_line('teacher = ' || rtrim(rec_teacher.TEACHER) ||
                                     ', teacher_name = ' || rtrim(rec_teacher.TEACHER_NAME) ||
                                     ', gender = ' || rtrim(rec_teacher.gender) ||
                                     ', pulpit = ' || rtrim(rec_teacher.PULPIT) ||
                                     ', birthday = ' || rec_teacher.BIRTHDAY ||
                                     ', salary = ' || rec_teacher.SALARY ||
                                     ', faculty = ' || rec_teacher.FACULTY
                                 );

        end loop;
    end GET_TEACHERS;

    procedure GET_SUBJECTS(PCODE SUBJECT.PULPIT%type) is
        cursor subject_cursor is select * from SUBJECT where PULPIT = PCODE;
        rec_subject subject_cursor%rowtype;
        begin
            for rec_subject in subject_cursor
            loop
                dbms_output.put_line('subject = ' || rtrim( rec_subject.SUBJECT) ||
                                         ', subject_name = ' || rtrim( rec_subject.SUBJECT_NAME) ||
                                         ', pulpit = ' || rtrim( rec_subject.PULPIT)
                                     );

            end loop;
    end GET_SUBJECTS;

    function GET_NUM_TEACHERS(FCODE FACULTY.FACULTY%type) return number is
            count_v number(3);
        begin
            select count(*) into count_v from TEACHER t inner join PULPIT p
                on t.PULPIT = p.PULPIT where p.FACULTY = FCODE;
            return count_v;
        end GET_NUM_TEACHERS;

    function GET_NUM_SUBJECTS(PCODE SUBJECT.PULPIT%type) return number is
            count_v number(3);
        begin
            select count(*) into count_v from SUBJECT where PULPIT = PCODE;
            return count_v;
        end GET_NUM_SUBJECTS;
end TEACHERS_;

--- ЗАДАНИЕ 7 ---
begin
    TEACHERS_.GET_TEACHERS('ИТ');
    TEACHERS_.GET_SUBJECTS('ИСиТ');
    dbms_output.put_line('TEACHERS_.GET_NUM_TEACHERS("ИТ") = ' || TEACHERS_.GET_NUM_TEACHERS('ИТ'));
    dbms_output.put_line('TEACHERS_.GET_NUM_SUBJECTS("ИСиТ") = ' || TEACHERS_.GET_NUM_SUBJECTS('ИСиТ'));
end;




