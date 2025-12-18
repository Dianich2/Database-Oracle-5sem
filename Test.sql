-- все тори представления это одно и то же(синонимы)
select * from USER_TAB_COLS;
select * from USER_TAB_COLUMNS;
select * from cols;

select * from DBA_USERS; -- пользователи
select * from DBA_PROFILES; -- профили безопасности
select * from DBA_ROLES; -- роли
select * from DBA_ROLE_PRIVS; -- роли, назначенные пользователям
select * from DBA_SYS_PRIVS; -- системные привилегии, назначенные пользователям или ролям
select * from DBA_TAB_PRIVS; -- объектные привилегии, назначенные ролям
select * from DBA_COL_PRIVS; -- привилегии на уровне столбцов для пользователей или ролей
select * from ROLE_ROLE_PRIVS; -- роли, назначенные другим ролям
select * from ROLE_SYS_PRIVS; -- системные привилегии, назначенные ролям
select * from ROLE_TAB_PRIVS; -- объектные привилегии, назначенные ролям
select * from role_col_privs; -- у меня почему-то нет такого
select * from USER_ROLE_PRIVS; -- роли текущего пользователя
select * from USER_SYS_PRIVS; -- системные привилегии текущего пользователя
select * from USER_TAB_PRIVS; -- объектрные привилегии текущего пользователя

SELECT REGEXP_REPLACE ('swap around 10 7778 ', '(.*)(\d\d )(.*)', '\3\2\1\3')
FROM dual;


