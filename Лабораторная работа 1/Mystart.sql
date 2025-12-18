drop table PID_t;

create table PID_t(
    x number(3) primary key,
    s varchar2(50)
)

insert into PID_t (x, s) values (10, 'десять');
insert into PID_t (x, s) values (20, 'двадцать');
insert into PID_t (x, s) values (50, 'пятьдесят');
commit;

select * from PID_t;
commit;


update PID_t set s = 'ten' where x = 10;
update PID_t set s = 'twenty' where x = 20;
commit;

select * from PID_t;
select * from PID_t where x > 15;
SELECT sum(x) from PID_t WHERE LENGTH(s) > 6;


delete from PID_t where x = 10;
select * from PID_t;
commit;

create table PID_t1(
    x1 number(3),
    foreign key(x1) references PID_t(x)
);

insert into PID_t1(x1) values(20);
commit;


select * from PID_t p inner join PID_t1 p1 on p.x = p1.x1;
select * from PID_t p left join PID_t1 p1 on p.x = p1.x1;
select * from PID_t p right join PID_t1 p1 on p.x = p1.x1;

drop table PID_t1;
drop table PID_t;
