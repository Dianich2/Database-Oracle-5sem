--- ЗАДАНИЕ 1 ---
begin
    null;
end;

--- ЗАДАНИЕ 2 ---
-- главное не забыть включить вывод и здесь, и в sqlplus
begin
    dbms_output.put_line('Hello World!');
end;

--- ЗАДАНИЕ 3 ---
declare
    a int := 2;
    b int := 0;
    c int;
begin
    c := a / b;
    exception
        when others
        then
            dbms_output.put_line(sqlerrm);
            dbms_output.put_line(sqlcode);
end;

--- ЗАДАНИЕ 4 ---
declare
    a int := 2;
    b int := 0;
    c int;
begin
    dbms_output.put_line('a = ' || a || ', b = ' || b);
    begin
    c := a / b;
    exception
        when others
        then
            dbms_output.put_line(sqlerrm);
            dbms_output.put_line(sqlcode);
    end;
end;

-- а можно и так
declare
    a int := 2;
    b int := 0;
    c int;
begin
    dbms_output.put_line('a = ' || a || ', b = ' || b);
    begin
    c := a / b;
    end;
        exception
        when others
        then
            dbms_output.put_line(sqlerrm);
            dbms_output.put_line(sqlcode);
end;

--- ЗАДАНИЕ 5 ---
select * from V$PARAMETER where NAME='plsql_warnings';

--- ЗАДАНИЕ 6 ---
select keyword from v$reserved_words where length = 1;

--- ЗАДАНИЕ 7 ---
select keyword from v$reserved_words where length > 1 order by KEYWORD;

--- ЗАДАНИЕ 8 ---
select * from V$PARAMETER where NAME like 'plsql%';

--- ЗАДАНИЕ 9-17 ---
declare
    -- ЗАДАНИЕ 10
    res number(5);
    a number(5) := 22;
    b number(5) := 2;
    -- ЗАДАНИЕ 12
    fix_po number(5, 2);
    fix_p number(5, 2) := 22.2;
    -- ЗАДАНИЕ 13
    fix_po_n number(5, -1);
    fix_p_n number(5, -1) := 22.5;
    -- ЗАДАНИЕ 14
    bfo_num binary_float;
    bf_num binary_float := 222222.22222;
    -- ЗАДАНИЕ 15
    bfo_numD binary_double;
    bf_numD binary_double := 222222.22222;
    -- ЗАДАНИЕ 16
    fix_p_e number(22, 5) := 2.2E+10;
    fix_p_e2 number(22, 5);
    -- ЗАДАНИЕ 17
    f boolean;
    t boolean := true;
begin
    -- ЗАДАНИE 11
    res := a + b;
    dbms_output.put_line('a + b = ' || res);
    res := a - b;
    dbms_output.put_line('a - b = ' || res);
    res := a * b;
    dbms_output.put_line('a * b = ' || res);
    res := a / b;
    dbms_output.put_line('a / b = ' || res);
    res := mod(a, b);
    dbms_output.put_line('a % b = ' || res);
    -- ЗАДАНИЕ 12
    dbms_output.put_line('fix_po = ' || fix_po);
    dbms_output.put_line('fix_p = ' || fix_p);
    -- ЗАДАНИЕ 13
    dbms_output.put_line('fix_po_n = ' || fix_po_n);
    dbms_output.put_line('fix_p_n = ' || fix_p_n);
    -- ЗАДАНИЕ 14
    dbms_output.put_line('bfo_num = ' || bfo_num);
    dbms_output.put_line('bf_num = ' || bf_num);
    -- ЗАДАНИЕ 15
    dbms_output.put_line('bfo_numD = ' || bfo_numD);
    dbms_output.put_line('bf_numD = ' || bf_numD);
    -- ЗАДАНИЕ 16
    dbms_output.put_line('fix_p_e = ' || fix_p_e);
    fix_p_e2 := 2.2E+10;
    dbms_output.put_line('fix_p_e2 = ' || fix_p_e2);
    -- ЗАДАНИЕ 17
    if t then dbms_output.put_line('t = ' || 'true');
    else dbms_output.put_line('t = ' || 'false');
    end if;
    if f then dbms_output.put_line('f = ' || 'true');
    else dbms_output.put_line('f = ' || 'false');
    end if;
end;

--- ЗАДАНИЕ 18 ---
declare
    v2 constant varchar2(2) := 'v2';
    ch constant char(2) := 'ch';
    num constant number(5, 2) := 22.2;
begin
    dbms_output.put_line('Const v2 = ' || v2);
    dbms_output.put_line('Const ch = ' || ch);
    dbms_output.put_line('Const num = ' || num);
    dbms_output.put_line('Const num + 2 = ' || (num + 2));
    dbms_output.put_line('Const num * 2 = ' || (num * 2));
end;

--- ЗАДАНИЕ 19 ---
declare
    au_type AUDITORIUM_TYPE.AUDITORIUM_TYPENAME%type;
begin
    au_type := 'Лекционная';
    dbms_output.put_line('au_type = ' || au_type);
end;

--- ЗАДАНИЕ 20 ---
declare
    au_type_row AUDITORIUM_TYPE%rowtype;
begin
    au_type_row.AUDITORIUM_TYPE := 'ЛК';
    au_type_row.AUDITORIUM_TYPENAME := 'Лекционная';
    dbms_output.put_line('au_type_row.AUDITORIUM_TYPE = ' ||
                         au_type_row.AUDITORIUM_TYPE || chr(10) ||
                         'au_type_row.AUDITORIUM_TYPENAME = ' ||
                         au_type_row.AUDITORIUM_TYPENAME);
end;

--- ЗАДАНИЕ 21-22 ---
declare
    num int := 0;
begin
    if num = 2 then
        num := num + 2;
        dbms_output.put_line('num + 2 = ' || num);
    elsif num = 1 then
        num := num + 1;
        dbms_output.put_line('num + 1 = ' || num);
    else
        dbms_output.put_line('num = ' || num);
    end if;
end;

--- ЗАДАНИЕ 23 ---
declare
    num int := 0;
begin
    case num
        when 2 then num := num + 2;
        dbms_output.put_line('num + 2 = ' || num);
        when 1 then num := num + 1;
        dbms_output.put_line('num + 1 = ' || num);
        else
        dbms_output.put_line('num = ' || num);
    end case;
end;

--- ЗАДАНИЕ 24 ---
declare
    num int := 10;
begin
    loop
        dbms_output.put_line('num = ' || num);
        num := num - 1;
        exit when num = 0;
    end loop;
end;

--- ЗАДАНИЕ 25 ---
declare
    num int := 10;
begin
    while(num <> 0)
    loop
        dbms_output.put_line('num = ' || num);
        num := num - 1;
    end loop;
end;

--- ЗАДАНИЕ 26 ---
begin
    for num in reverse 1..10
    loop
        dbms_output.put_line('num = ' || num);
    end loop;
end;







