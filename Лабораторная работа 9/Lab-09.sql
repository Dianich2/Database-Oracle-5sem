--- ЗАДАНИЕ 1 ---
declare
    au_type_row AUDITORIUM_TYPE%rowtype;
begin
    select * into au_type_row from AUDITORIUM_TYPE where AUDITORIUM_TYPE='ЛК';
    dbms_output.put_line('au_type_row.AUDITORIUM_TYPE = '
                             || au_type_row.AUDITORIUM_TYPE || chr(10) ||
                         'au_type_row.AUDITORIUM_TYPENAME = '
                             || au_type_row.AUDITORIUM_TYPENAME);
end;

--- ЗАДАНИЕ 2 ---
declare
    au_type_row AUDITORIUM_TYPE%rowtype;
begin
    select * into au_type_row from AUDITORIUM_TYPE where AUDITORIUM_TYPE like 'ЛК%';
    dbms_output.put_line('au_type_row.AUDITORIUM_TYPE = '
                             || au_type_row.AUDITORIUM_TYPE || chr(10) ||
                         'au_type_row.AUDITORIUM_TYPENAME = '
                             || au_type_row.AUDITORIUM_TYPENAME);
    exception
        when others then
            dbms_output.put_line('sqlerrm: ' || sqlerrm);
            dbms_output.put_line('sqlcode: ' || sqlcode);

end;

--- ЗАДАНИЕ 3 ---
declare
    au_type_row AUDITORIUM_TYPE%rowtype;
begin
    select * into au_type_row from AUDITORIUM_TYPE;
    dbms_output.put_line('au_type_row.AUDITORIUM_TYPE = '
                             || au_type_row.AUDITORIUM_TYPE || chr(10) ||
                         'au_type_row.AUDITORIUM_TYPENAME = '
                             || au_type_row.AUDITORIUM_TYPENAME);
    exception
        when too_many_rows then
            dbms_output.put_line('when to_many_rows');
            dbms_output.put_line('sqlerrm: ' || sqlerrm);
            dbms_output.put_line('sqlcode: ' || sqlcode);
end;

--- ЗАДАНИЕ 4 ---
declare
    au_type_row AUDITORIUM_TYPE%rowtype;
begin
    select * into au_type_row from AUDITORIUM_TYPE where AUDITORIUM_TYPE='222';
    dbms_output.put_line('au_type_row.AUDITORIUM_TYPE = '
                             || au_type_row.AUDITORIUM_TYPE || chr(10) ||
                         'au_type_row.AUDITORIUM_TYPENAME = '
                             || au_type_row.AUDITORIUM_TYPENAME);
    exception
        when no_data_found then
            dbms_output.put_line('no_data_found');
            dbms_output.put_line('sqlerrm: ' || sqlerrm);
            dbms_output.put_line('sqlcode: ' || sqlcode);
end;

declare
    au_type_row AUDITORIUM_TYPE%rowtype;
begin
    select * into au_type_row from AUDITORIUM_TYPE where AUDITORIUM_TYPE='ЛК';
    dbms_output.put_line('au_type_row.AUDITORIUM_TYPE = '
                             || au_type_row.AUDITORIUM_TYPE || chr(10) ||
                         'au_type_row.AUDITORIUM_TYPENAME = '
                             || au_type_row.AUDITORIUM_TYPENAME);
    if sql%found then
        dbms_output.put_line('found');
    end if;

    if sql%notfound then
        dbms_output.put_line('notfound');
    end if;

    dbms_output.put_line('rowcount = ' || sql%rowcount);

    if sql%isopen then
        dbms_output.put_line('isopen');
    else
        dbms_output.put_line('is not open');
    end if;
    exception
        when no_data_found then
            dbms_output.put_line('no_data_found');
            dbms_output.put_line('sqlerrm: ' || sqlerrm);
            dbms_output.put_line('sqlcode: ' || sqlcode);
end;

-- !!!!!
-- в 5, 7, 9 заданиях не забываем коммитить вручную,
-- когда нужно(перед rollback) (пойму короче по идее)

--- ЗАДАНИЕ 5 ---
begin
    update AUDITORIUM_TYPE set AUDITORIUM_TYPENAME = 'ЛК_т' where AUDITORIUM_TYPENAME = 'Лекционная';
    --commit;
    rollback;
    exception
        when others then
            dbms_output.put_line('sqlerrm: ' || sqlerrm);
            dbms_output.put_line('sqlcode: ' || sqlcode);
end;
select * from AUDITORIUM_TYPE;

-- вернем обратно
update AUDITORIUM_TYPE set AUDITORIUM_TYPENAME = 'Лекционная' where AUDITORIUM_TYPENAME = 'ЛК_т';

--- ЗАДАНИЕ 6 ---
begin
    update AUDITORIUM_TYPE set AUDITORIUM_TYPE = 'ЛК_t2' where AUDITORIUM_TYPE = 'ЛК';
    exception
        when others then
            dbms_output.put_line('sqlerrm: ' || sqlerrm);
            dbms_output.put_line('sqlcode: ' || sqlcode);
end;

--- ЗАДАНИЕ 7 ---
begin
    insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values ('LK', 'LK');
    --commit;
    rollback;
    exception
        when others then
            dbms_output.put_line('sqlerrm: ' || sqlerrm);
            dbms_output.put_line('sqlcode: ' || sqlcode);
end;
select * from AUDITORIUM_TYPE;

-- вернем обратно
delete from AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'LK';

--- ЗАДАНИЕ 8 ---
begin
    insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values ('ЛК', 'LK');
    exception
        when others then
            dbms_output.put_line('sqlerrm: ' || sqlerrm);
            dbms_output.put_line('sqlcode: ' || sqlcode);
end;

--- ЗАДАНИЕ 9 ---
begin
    delete from AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'LK';
    commit;
    --rollback;
    exception
        when others then
            dbms_output.put_line('sqlerrm: ' || sqlerrm);
            dbms_output.put_line('sqlcode: ' || sqlcode);
end;
select * from AUDITORIUM_TYPE;

-- вернем обратно
insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) values ('LK', 'LK');

--- ЗАДАНИЕ 10 ---
begin
    delete from AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'ЛК';
    exception
        when others then
            dbms_output.put_line('sqlerrm: ' || sqlerrm);
            dbms_output.put_line('sqlcode: ' || sqlcode);
end;

--- ЗАДАНИЕ 11 ---
declare
    cursor teacher_cursor is select * from TEACHER;
    t_teacher TEACHER.TEACHER%TYPE;
    t_teachername TEACHER.TEACHER_NAME%TYPE;
    t_gender TEACHER.GENDER%TYPE;
    t_pulpit TEACHER.PULPIT%TYPE;
begin
    open teacher_cursor;
    loop
        fetch teacher_cursor into t_teacher, t_teachername,
            t_gender, t_pulpit;
        exit when teacher_cursor%notfound;
        dbms_output.put_line('teacher = ' || rtrim(t_teacher) || ', teacher_name = ' || rtrim(t_teachername) ||
                                ', gender = ' || rtrim(t_gender) || ', pulpit = ' || rtrim(t_pulpit));
    end loop;
    close teacher_cursor;
end;

select * from TEACHER;

--- ЗАДАНИЕ 12 ---
declare
    cursor subject_cursor is select * from SUBJECT;
    s_subject SUBJECT%rowtype;
begin
    open subject_cursor;
    fetch subject_cursor into s_subject;
    while subject_cursor%found
    loop
        dbms_output.put_line('subject = ' || rtrim(s_subject.SUBJECT) || ', subject_name = ' || rtrim(s_subject.SUBJECT_NAME) ||
                                ', pulpit = ' || rtrim(s_subject.PULPIT));
        fetch subject_cursor into s_subject;
    end loop;
    close subject_cursor;
end;

--- ЗАДАНИЕ 13 ---
declare
    cursor pt_tr_cursor is select p.PULPIT_NAME, t.TEACHER_NAME from PULPIT p inner join TEACHER t on p.PULPIT = t.PULPIT;
    rec_pt_tr pt_tr_cursor%rowtype;
begin
    for rec_pt_tr in pt_tr_cursor
    loop
        dbms_output.put_line('teacher_name = '|| rtrim(rec_pt_tr.TEACHER_NAME) ||
                                ', pulpit_name = ' || rtrim(rec_pt_tr.PULPIT_NAME));
    end loop;
end;

--- ЗАДАНИЕ 14 ---
declare
    cursor au_cursor(cap_begin AUDITORIUM.AUDITORIUM_CAPACITY%type, cap_end AUDITORIUM.AUDITORIUM_CAPACITY%type) is select * from AUDITORIUM
    where AUDITORIUM_CAPACITY >= cap_begin and AUDITORIUM_CAPACITY < cap_end;
    rec_au au_cursor%rowtype;
begin
    --- capacity < 20 ---
    dbms_output.put_line('Auditorium where capacity < 20');
    for rec_au in au_cursor(0, 20)
    loop
        dbms_output.put_line('auditorium = ' || rtrim(rec_au.AUDITORIUM) ||
                             ' auditorium_name = ' || rtrim(rec_au.AUDITORIUM_NAME) ||
                             ' auditorium_type = ' || rtrim(rec_au.AUDITORIUM_TYPE) ||
                             ' auditorium_capacity = ' || rec_au.AUDITORIUM_CAPACITY);
    end loop;

    --- capacity >= 21 and capacity <= 30 ---
    dbms_output.put_line('Auditorium where capacity >= 21 and capacity <= 30');
    for rec_au in au_cursor(21, 31)
    loop
        dbms_output.put_line('auditorium = ' || rtrim(rec_au.AUDITORIUM) ||
                             ' auditorium_name = ' || rtrim(rec_au.AUDITORIUM_NAME) ||
                             ' auditorium_type = ' || rtrim(rec_au.AUDITORIUM_TYPE) ||
                             ' auditorium_capacity = ' || rec_au.AUDITORIUM_CAPACITY);
    end loop;

    --- capacity >= 31 and capacity <= 60 ---
    dbms_output.put_line('Auditorium where capacity >= 31 and capacity <= 60');
    for rec_au in au_cursor(31, 61)
    loop
        dbms_output.put_line('auditorium = ' || rtrim(rec_au.AUDITORIUM) ||
                             ' auditorium_name = ' || rtrim(rec_au.AUDITORIUM_NAME) ||
                             ' auditorium_type = ' || rtrim(rec_au.AUDITORIUM_TYPE) ||
                             ' auditorium_capacity = ' || rec_au.AUDITORIUM_CAPACITY);
    end loop;

    --- capacity >= 61 and capacity <= 80 ---
    dbms_output.put_line('Auditorium where capacity >= 61 and capacity <= 80');
    open au_cursor(61, 81);
    fetch au_cursor into rec_au;
    while au_cursor%found
    loop
        dbms_output.put_line('auditorium = ' || rtrim(rec_au.AUDITORIUM) ||
                             ' auditorium_name = ' || rtrim(rec_au.AUDITORIUM_NAME) ||
                             ' auditorium_type = ' || rtrim(rec_au.AUDITORIUM_TYPE) ||
                             ' auditorium_capacity = ' || rec_au.AUDITORIUM_CAPACITY);
    fetch au_cursor into rec_au;
    end loop;
    close au_cursor;

    --- capacity >= 81 ---
    dbms_output.put_line('Auditorium where capacity >= 81');
    open au_cursor(81, 301); -- так как у нас constraint на макс. 300
    loop
        fetch au_cursor into rec_au;
        exit when au_cursor%notfound;
        dbms_output.put_line('auditorium = ' || rtrim(rec_au.AUDITORIUM) ||
                             ' auditorium_name = ' || rtrim(rec_au.AUDITORIUM_NAME) ||
                             ' auditorium_type = ' || rtrim(rec_au.AUDITORIUM_TYPE) ||
                             ' auditorium_capacity = ' || rec_au.AUDITORIUM_CAPACITY);
    end loop;
    close au_cursor;
end;

--- ЗАДАНИЕ 15 ---
declare
    type au_t is ref cursor return AUDITORIUM_TYPE%rowtype;
    au_cursor au_t;
    rec_au au_cursor%rowtype;
begin
    open au_cursor for select * from AUDITORIUM_TYPE where AUDITORIUM_TYPE like 'ЛК%';
    fetch au_cursor into rec_au;
    while au_cursor%found
    loop
        dbms_output.put_line('auditorium_type = ' || rtrim(rec_au.AUDITORIUM_TYPE) ||
                             ' auditorium_typename = ' || rtrim(rec_au.AUDITORIUM_TYPENAME));
    fetch au_cursor into rec_au;
    end loop;
    close au_cursor;
end;

--- ЗАДАНИЕ 16 ---
declare
    cursor pulpit_cursor is select p.PULPIT,
    cursor (select s.SUBJECT from SUBJECT s where p.PULPIT = s.PULPIT)
    from PULPIT p;
    subject_cursor sys_refcursor;
    subj SUBJECT.SUBJECT%type;
    pulp PULPIT.PULPIT%type;
    t boolean := false;
begin
    open pulpit_cursor;
    fetch pulpit_cursor into pulp, subject_cursor;
    while pulpit_cursor%found
    loop
        dbms_output.put_line('Subjects of the ' || rtrim(pulp) || ' pulpit: ');
        t := false;
        loop
            fetch subject_cursor into subj;
            exit when subject_cursor%notfound;
            t := true;
            dbms_output.put(rtrim(subj) || ' ');
        end loop;
        if not t then
            dbms_output.put_line('no subjects ' || chr(10));
        else
            dbms_output.new_line();
        end if;
        fetch pulpit_cursor into pulp, subject_cursor;
    end loop;
    close pulpit_cursor;
end;

select * from PULPIT;
select * from SUBJECT;

--- ЗАДАНИЕ 17 ---
select * from AUDITORIUM;

declare
    cursor auditorium_cursor(cap_begin AUDITORIUM.AUDITORIUM_CAPACITY%type, cap_end AUDITORIUM.AUDITORIUM_CAPACITY%type) is
        select AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY from AUDITORIUM where
        AUDITORIUM_CAPACITY >= cap_begin and AUDITORIUM_CAPACITY <= cap_end for update;
    rec_auditorium AUDITORIUM%rowtype;
begin
    for rec_auditorium in auditorium_cursor(40, 80)
    loop
        dbms_output.put_line('before update: ' || chr(10) || rec_auditorium.AUDITORIUM || ' ' || rec_auditorium.AUDITORIUM_NAME ||
                            ' ' || rec_auditorium.AUDITORIUM_TYPE || ' ' || rec_auditorium.AUDITORIUM_CAPACITY);
        update AUDITORIUM set AUDITORIUM_CAPACITY = AUDITORIUM_CAPACITY * 0.9 where current of auditorium_cursor;
        dbms_output.put_line('after update: ' || chr(10) || rec_auditorium.AUDITORIUM || ' ' || rec_auditorium.AUDITORIUM_NAME ||
                            ' ' || rec_auditorium.AUDITORIUM_TYPE || ' ' || rec_auditorium.AUDITORIUM_CAPACITY * 0.9);
    end loop;
end;

--- для упрощения жизни будем для возвращения к первоначальной таблице удалять все строки
-- и заново заполнять все строки из файлика UNIVER
truncate table AUDITORIUM;
select * from AUDITORIUM;

--- ЗАДАНИЕ 18 ---
select * from AUDITORIUM;

declare
    cursor auditorium_cursor(cap_begin AUDITORIUM.AUDITORIUM_CAPACITY%type, cap_end AUDITORIUM.AUDITORIUM_CAPACITY%type) is
        select AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY from AUDITORIUM where
        AUDITORIUM_CAPACITY >= cap_begin and AUDITORIUM_CAPACITY <= cap_end for update;
    rec_auditorium AUDITORIUM%rowtype;
begin
    for rec_auditorium in auditorium_cursor(0, 20)
    loop
        dbms_output.put_line(rec_auditorium.AUDITORIUM || ' ' || rec_auditorium.AUDITORIUM_NAME ||
                            ' ' || rec_auditorium.AUDITORIUM_TYPE || ' ' || rec_auditorium.AUDITORIUM_CAPACITY);
        delete from AUDITORIUM where current of auditorium_cursor;
        end loop;
end;

--- для упрощения жизни будем для возвращения к первоначальной таблице удалять все строки
-- и заново заполнять все строки из файлика UNIVER
truncate table AUDITORIUM;
select * from AUDITORIUM;

--- ЗАДАНИЕ 19 ---
select * from AUDITORIUM;

declare
    cursor auditorium_cursor(cap_begin AUDITORIUM.AUDITORIUM_CAPACITY%type, cap_end AUDITORIUM.AUDITORIUM_CAPACITY%type) is
        select rowid, AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY from AUDITORIUM where
        AUDITORIUM_CAPACITY >= cap_begin and AUDITORIUM_CAPACITY <= cap_end for update;
    rec_auditorium auditorium_cursor%rowtype;
begin
    for rec_auditorium in auditorium_cursor(0, 90)
    loop
        case
            when rec_auditorium.AUDITORIUM_CAPACITY <= 50 then
                delete from AUDITORIUM where ROWID = rec_auditorium.rowid;
                dbms_output.put_line('delete ' || rec_auditorium.AUDITORIUM || ' ' || rec_auditorium.AUDITORIUM_NAME ||
                            ' ' || rec_auditorium.AUDITORIUM_TYPE || ' ' || rec_auditorium.AUDITORIUM_CAPACITY);
            when rec_auditorium.AUDITORIUM_CAPACITY > 50 then
                update AUDITORIUM set AUDITORIUM_CAPACITY = AUDITORIUM_CAPACITY * 1.2 where ROWID = rec_auditorium.rowid;
                dbms_output.put_line('update ' || rec_auditorium.AUDITORIUM || ' ' || rec_auditorium.AUDITORIUM_NAME ||
                            ' ' || rec_auditorium.AUDITORIUM_TYPE || ' ' || rec_auditorium.AUDITORIUM_CAPACITY);
        end case;
    end loop;
end;

--- для упрощения жизни будем для возвращения к первоначальной таблице удалять все строки
-- и заново заполнять все строки из файлика UNIVER
truncate table AUDITORIUM;
select * from AUDITORIUM;

--- ЗАДАНИЕ 20 ---
select * from TEACHER;

declare
    cursor teacher_cursor is select rownum, TEACHER, TEACHER_NAME, GENDER, PULPIT from TEACHER;
    rec_teacher teacher_cursor%rowtype;
begin
    for rec_teacher in teacher_cursor
    loop
        dbms_output.put_line('rownum = ' || rec_teacher.rownum || ', teacher = ' || rtrim(rec_teacher.TEACHER) || ', teacher_name  = ' || rtrim(rec_teacher.TEACHER_NAME) ||
                             ', gender = ' || rtrim(rec_teacher.GENDER) || ', pulpit = ' || rec_teacher.PULPIT);
        if mod(rec_teacher.ROWNUM, 3) = 0 then
            dbms_output.put_line('-------------');
        end if;
    end loop;
end;









