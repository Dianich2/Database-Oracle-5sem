-- нужно дать пользователю PIDCORE привилегии на работу с триггерами
grant CREATE ANY TRIGGER, DROP ANY TRIGGER, ALTER ANY TRIGGER to PIDCORE;

--- ЗАДАНИЕ 1 ---
create table for_trigger(
    a int primary key,
    b int default 1 check ( b > 0 ),
    c int not null,
    d int unique
);

--- ЗАДАНИЕ 2 ---
declare
    x int := 1;
begin
    loop
        insert into for_trigger values (x, x + 1, x + 2, x + 3);
        exit when x >= 10;
        x := x + 1;
    end loop;
end;

truncate table for_trigger;
select * from for_trigger;

--- ЗАДАНИЕ 3 ---
create or replace trigger trigger_before_idu before
    insert or delete or update on for_trigger
    begin
        dbms_output.put_line('trigger_before_idu');
end;

--- ЗАДАНИЕ 5-6 ---
create or replace trigger trigger_before_idu_row before
    insert or delete or update on for_trigger
    for each row
    begin
        if inserting then
            dbms_output.put_line('trigger_before_idu_row  insert');
        elsif deleting then
            dbms_output.put_line('trigger_before_idu_row  delete');
        elsif updating then
            dbms_output.put_line('trigger_before_idu_row  update');
        end if;
end;

insert into for_trigger values (100, 101, 102, 103);
update for_trigger set a = 105 where a = 100;
delete from for_trigger where a = 105;

--- ЗАДАНИЕ 7 ---
create or replace trigger trigger_after_i after
    insert on for_trigger
    begin
        dbms_output.put_line('trigger_after_i');
end;

create or replace trigger trigger_after_d after
    delete on for_trigger
    begin
        dbms_output.put_line('trigger_after_d');
end;

create or replace trigger trigger_after_u after
    update on for_trigger
    begin
        dbms_output.put_line('trigger_after_u');
end;

--- ЗАДАНИЕ 8 ---
create or replace trigger trigger_after_i_row after
    insert on for_trigger
    for each row
    begin
        dbms_output.put_line('trigger_after_i_row');
end;

create or replace trigger trigger_after_d_row after
    delete on for_trigger
    for each row
    begin
        dbms_output.put_line('trigger_after_d_row');
end;

create or replace trigger trigger_after_u_row after
    update on for_trigger
    for each row
    begin
        dbms_output.put_line('trigger_after_u_row');
end;

insert into for_trigger values (100, 101, 102, 103);
update for_trigger set a = 105 where a = 100;
delete from for_trigger where a = 105;

select * from user_TRIGGERS;

--- ЗАДАНИЕ 9 ---
create table AUDIT_(
    OperationDate date,
    OperationType varchar2(20),
    TriggerName varchar2(50),
    data varchar2(200)
);

-- ЗАДАНИЕ 10 ---
-- тут в триггерах уровня оператора мы не можем использовать :new и :old
create or replace trigger trigger_before_idu before
    insert or delete or update on for_trigger
    begin
        dbms_output.put_line('trigger_before_idu');
        if inserting then
            insert into AUDIT_ values(sysdate, 'insert', 'trigger_before_idu', '-');
        elsif deleting then
            insert into AUDIT_ values(sysdate, 'delete', 'trigger_before_idu', '-');
        elsif updating then
            insert into AUDIT_ values(sysdate, 'update', 'trigger_before_idu', '-');
        end if;
end;

create or replace trigger trigger_before_idu_row before
    insert or delete or update on for_trigger
    for each row
    begin
        if inserting then
            dbms_output.put_line('trigger_before_idu_row  insert');
            insert into AUDIT_ values(sysdate, 'insert', 'trigger_before_idu_row', ':new: ' || :new.a || ' ' || :new.b || ' ' || :new.c || ' ' || :new.d);
        elsif deleting then
            dbms_output.put_line('trigger_before_idu_row  delete');
            insert into AUDIT_ values(sysdate, 'delete', 'trigger_before_idu_row', ':old: ' || :old.a || ' ' || :old.b || ' ' || :old.c || ' ' || :old.d);
        elsif updating then
            dbms_output.put_line('trigger_before_idu_row  update');
            insert into AUDIT_ values(sysdate, 'update', 'trigger_before_idu_row', ':old: ' || :old.a || ' ' || :old.b || ' ' || :old.c || ' ' || :old.d ||
                                                                                    ':new: ' || :new.a || ' ' || :new.b || ' ' || :new.c || ' ' || :new.d);
        end if;
end;

create or replace trigger trigger_after_i after
    insert on for_trigger
    begin
        dbms_output.put_line('trigger_after_i');
        insert into AUDIT_ values(sysdate, 'insert', 'trigger_after_i', '-');
end;

create or replace trigger trigger_after_d after
    delete on for_trigger
    begin
        dbms_output.put_line('trigger_after_d');
        insert into AUDIT_ values(sysdate, 'delete', 'trigger_after_d', '-');
end;

create or replace trigger trigger_after_u after
    update on for_trigger
    begin
        dbms_output.put_line('trigger_after_u');
        insert into AUDIT_ values(sysdate, 'update', 'trigger_after_u', '-');
end;

create or replace trigger trigger_after_i_row after
    insert on for_trigger
    for each row
    begin
        dbms_output.put_line('trigger_after_i_row');
        insert into AUDIT_ values(sysdate, 'insert', 'trigger_after_i_row', ':new: ' || :new.a || ' ' || :new.b || ' ' || :new.c || ' ' || :new.d);
end;

create or replace trigger trigger_after_d_row after
    delete on for_trigger
    for each row
    begin
        dbms_output.put_line('trigger_after_d_row');
        insert into AUDIT_ values(sysdate, 'delete', 'trigger_after_d_row', ':old: ' || :old.a || ' ' || :old.b || ' ' || :old.c || ' ' || :old.d);
end;

create or replace trigger trigger_after_u_row after
    update on for_trigger
    for each row
    begin
        dbms_output.put_line('trigger_after_u_row');
        insert into AUDIT_ values(sysdate, 'update', 'trigger_after_u_row', ':old: ' || :old.a || ' ' || :old.b || ' ' || :old.c || ' ' || :old.d ||
                                                                                    ':new: ' || :new.a || ' ' || :new.b || ' ' || :new.c || ' ' || :new.d);
end;

insert into for_trigger values (100, 101, 102, 103);
update for_trigger set a = 105 where a = 100;
delete from for_trigger where a = 105;

select * from AUDIT_;

--- ЗАДАНИЕ 11 ---
-- ну ту по факту мы увидим вывод dbms_output before триггеров, но больше
-- ничего так как транзакция откатится
insert into for_trigger values (1, 5, 7, 8);
select * from AUDIT_;

--- ЗАДАНИЕ 12 ---
-- триггеры автоматически удаляются
drop table for_trigger;
select * from USER_TRIGGERS;
select * from for_trigger;

create or replace trigger trigger_stop_drop_table
    before drop on schema
    begin
        if ORA_DICT_OBJ_NAME = 'FOR_TRIGGER' then
            raise_application_error(-20000, 'You try drop table for_trigger. You can not do this');
        end if;
end;

--- ЗАДАНИЕ 13 ---
-- ну тут триггеры останутся, но теперь мы не сможем ничего сделать
-- из-за того, что таблицы нет, в триггерах будет ошибка и всё, но они типо включены
-- просто эта проверка типо как отложенная
drop table AUDIT_;
select * from USER_TRIGGERS;

insert into for_trigger values (100, 101, 102, 103);
update for_trigger set a = 105 where a = 100;
delete from for_trigger where a = 105;
-- ну изменить мы можем просто пересоздав первоначальные

--- ЗАДАНИЕ 14 ---
create view for_trigger_view as
    select * from for_trigger;

select * from for_trigger_view;

create or replace trigger trigger_instead_of_for_trigger_view instead of
    insert on for_trigger_view
    begin
        dbms_output.put_line('trigger_instead_of_for_trigger_view');
        insert into for_trigger values(222, 222, 222, 222);
end;

-- отключим ненужные на текущий момент триггеры
alter table for_trigger disable all triggers;
select * from USER_TRIGGERS;

select * from for_trigger;
select * from for_trigger_view;
insert into for_trigger_view values (200, 200, 200, 200);
delete from for_trigger where a = 222;

--- ЗАДАНИЕ 15 ---
-- тут будет пусто, так как эти представления показывают порядок, если мы его явно задавали(что мы не делали)
alter table for_trigger enable all triggers;
select * from USER_TRIGGERS;
select * from USER_TRIGGER_ORDERING;
select * from ALL_TRIGGER_ORDERING;
