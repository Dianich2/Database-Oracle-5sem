-- перед созданием нужно не забыть переключить схему на PIDCORE
drop table SUBJECT;
drop table TEACHER;
drop table PULPIT;
drop table FACULTY;
drop table AUDITORIUM;
drop table AUDITORIUM_TYPE;

--- AUDITORIUM_TYPE ---
create table AUDITORIUM_TYPE
(   AUDITORIUM_TYPE  char(10) constraint AUDITORIUM_TYPE_PK  primary key,
    AUDITORIUM_TYPENAME  varchar2(100) not null
);
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME )
values ('ЛК', 'Лекционная');
insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME )
values ('ЛБ-К', 'Компьютерный класс');
insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME )
values ('ЛК-К',  'Лекционная с уст. проектором');
insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME )
values ('ЛБ-X', 'Химическая лаборатория');
insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME )
values ('ЛБ-СК', 'Спец. компьютерный класс');

--- AUDITORIUM ---
create table AUDITORIUM (
	AUDITORIUM   char(20)  constraint AUDITORIUM_PK  primary key,
    AUDITORIUM_TYPE     char(10) constraint  AUDITORIUM_AUDITORIUM_TYPE_FK references AUDITORIUM_TYPE(AUDITORIUM_TYPE),
    AUDITORIUM_CAPACITY  integer default 1 constraint  AUDITORIUM_CAPACITY_CHECK check (AUDITORIUM_CAPACITY between 1 and 300),
    AUDITORIUM_NAME varchar(50)
);
insert into  AUDITORIUM   (AUDITORIUM, AUDITORIUM_NAME,  AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
values  ('206-1', '206-1','ЛБ-К', 15);
insert into  AUDITORIUM   (AUDITORIUM, AUDITORIUM_NAME,  AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
values	('301-1',   '301-1', 'ЛБ-К', 15);
insert into  AUDITORIUM   (AUDITORIUM, AUDITORIUM_NAME,  AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
values	('236-1',   '236-1', 'ЛК', 60);
insert into  AUDITORIUM   (AUDITORIUM, AUDITORIUM_NAME,  AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
values	('313-1',   '313-1', 'ЛК-К', 60);
insert into  AUDITORIUM   (AUDITORIUM, AUDITORIUM_NAME,  AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
values	('324-1',   '324-1', 'ЛК-К', 50);
insert into  AUDITORIUM   (AUDITORIUM, AUDITORIUM_NAME,  AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
values	('413-1',   '413-1', 'ЛБ-К', 15);
insert into  AUDITORIUM   (AUDITORIUM, AUDITORIUM_NAME,  AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
values	('423-1',   '423-1', 'ЛБ-К', 90);
insert into  AUDITORIUM   (AUDITORIUM, AUDITORIUM_NAME,  AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)
values	('408-2',   '408-2', 'ЛК',  90);

--- FACULTY ---
create table FACULTY(
	FACULTY  char(10)   constraint  FACULTY_PK primary key,
    FACULTY_NAME  varchar2(100) default '???'
);
insert into FACULTY   (FACULTY,   FACULTY_NAME )
values  ('ХТиТ','Химическая технология и техника');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
values  ('ЛХФ',  'Лесохозяйственный факультет');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
values  ('ИЭФ',  'Инженерно-экономический факультет');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
values  ('ТТЛП', 'Технология и техника лесной промышленности');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
values  ('ТОВ',  'Технология органических веществ');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
values  ('ИДиП',  'Издательское дело и полиграфия');
insert into FACULTY   (FACULTY,   FACULTY_NAME )
values  ('ИТ',  'Факультет информационных технологий');

--- PULPIT ---
create table  PULPIT (
	PULPIT   char(20)  constraint PULPIT_PK  primary key,
    PULPIT_NAME  varchar2(200),
    FACULTY   char(10)   constraint PULPIT_FACULTY_FK references FACULTY(FACULTY)
);
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values  ('ИСиТ', 'Информационных систем и технологий ','ИТ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ЛВ', 'Лесоводства','ЛХФ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ЛУ', 'Лесоустройства','ЛХФ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ЛЗиДВ', 'Лесозащиты и древесиноведения','ЛХФ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ЛКиП', 'Лесных культур и почвоведения','ЛХФ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ТиП', 'Туризма и природопользования','ЛХФ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ЛПиСПС','Ландшафтного проектирования и садово-паркового строительства','ЛХФ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ТЛ', 'Транспорта леса', 'ТТЛП');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ЛМиЛЗ','Лесных машин и технологии лесозаготовок','ТТЛП');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ТДП','Технологий деревообрабатывающих производств', 'ТТЛП');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ТиДИД','Технологии и дизайна изделий из древесины','ТТЛП');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ОХ', 'Органической химии','ТОВ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ХПД','Химической переработки древесины','ТОВ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ТНВиОХТ','Технологии неорганических веществ и общей химической технологии ','ХТиТ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ПиАХП','Процессов и аппаратов химических производств','ХТиТ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ЭТиМ',    'Экономической теории и маркетинга','ИЭФ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('МиЭП',   'Менеджмента и экономики природопользования','ИЭФ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ТНХСиППМ',   'Технологии нефтехимического синтеза и переработки полимерных материалов','ТОВ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ПОиСОИ',   'Полиграфического оборудования и систем обработки информации','ИЭФ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ХТЭПиМЭЕ',   'Химии, технологии электрохимических производств и материалов электронной техники','ИЭФ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('ИВД',   'Информатики и веб-дизайна','ИТ');
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
values	('СБУАиА', 'Статистики, бухгалтерского учета, анализа и аудита', 'ИЭФ');

--- SUBJECT ---
create table SUBJECT(
	SUBJECT  char(20) constraint SUBJECT_PK  primary key,
    SUBJECT_NAME varchar(200) unique,
    PULPIT  char(20) constraint SUBJECT_PULPIT_FK references PULPIT(PULPIT)
);
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('СУБД',   'Системы управления базами данных', 'ИСиТ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('БД',     'Базы данных','ИСиТ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ИНФ',    'Информационные технологии','ИСиТ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ОАиП',  'Основы алгоритмизации и программирования', 'ИСиТ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ПЗ',     'Представление знаний в компьютерных системах', 'ИСиТ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ПСП',    'Программирование сетевых приложений', 'ИСиТ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('МСОИ',  'Моделирование систем обработки информации', 'ИСиТ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ПИС',     'Проектирование информационных систем', 'ИСиТ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('КГ',      'Компьютерная геометрия ','ИСиТ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ПМАПЛ',   'Полиграф. машины, автоматы и поточные линии', 'ПОиСОИ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('КМС',     'Компьютерные мультимедийные системы', 'ИСиТ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ОПП',     'Организация полиграф. производства', 'ПОиСОИ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ДМ',   'Дискретная математика', 'ИСиТ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('МП',   'Математическое программирование','ИСиТ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ЛЭВМ', 'Логические основы ЭВМ',  'ИСиТ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ООП',  'Объектно-ориентированное программирование', 'ИСиТ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ЭП', 'Экономика природопользования','МиЭП');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ЭТ', 'Экономическая теория','ЭТиМ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ОСПиЛПХ','Основы садово-паркового и лесопаркового хозяйства',  'ЛПиСПС');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ИГ', 'Инженерная геодезия ','ЛУ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ЛВ',    'Лесоводство', 'ЛЗиДВ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ОХ',    'Органическая химия', 'ОХ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ТРИ',    'Технология резиновых изделий','ТНХСиППМ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ВТЛ',    'Водный транспорт леса','ТЛ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ТиОЛ',   'Технология и оборудование лесозаготовок', 'ЛМиЛЗ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ТОПИ',   'Технология обогащения полезных ископаемых ','ТНВиОХТ');
insert into SUBJECT(SUBJECT,   SUBJECT_NAME, PULPIT )
values ('ПЭХ',    'Прикладная электрохимия','ХТЭПиМЭЕ');

--- TEACHER ---
create table TEACHER(
	TEACHER    char(20)  constraint TEACHER_PK  primary key,
    TEACHER_NAME  varchar(100),
    GENDER     char(2) CHECK (GENDER in ('м', 'ж')),
    PULPIT   char(20) constraint TEACHER_PULPIT_FK references PULPIT(PULPIT)
);
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('СМЛВ',    'Смелов Владимир Владиславович', 'м',  'ИСиТ');
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('ДТК',     'Дятко Александр Аркадьевич', 'м', 'ИВД');
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('УРБ',     'Урбанович Павел Павлович', 'м', 'ИСиТ');
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('ГРН',     'Гурин Николай Иванович', 'м', 'ИСиТ');
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('ЖЛК',     'Жиляк Надежда Александровна',  'ж', 'ИСиТ');
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('МРЗ',     'Мороз Елена Станиславовна',  'ж',   'ИСиТ');
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('БРТШВЧ',   'Барташевич Святослав Александрович', 'м','ПОиСОИ');
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('АРС',     'Арсентьев Виталий Арсентьевич', 'м', 'ПОиСОИ');
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('НВРВ',   'Неверов Александр Васильевич', 'м', 'МиЭП');
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('РВКЧ',   'Ровкач Андрей Иванович', 'м', 'ЛВ');
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('ДМДК', 'Демидко Марина Николаевна',  'ж',  'ЛПиСПС');
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('БРГ',     'Бурганская Татьяна Минаевна', 'ж', 'ЛПиСПС');
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('РЖК',   'Рожков Леонид Николаевич ', 'м', 'ЛВ');
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('ЗВГЦВ',   'Звягинцев Вячеслав Борисович', 'м', 'ЛЗиДВ');
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('БЗБРДВ',   'Безбородов Владимир Степанович', 'м', 'ОХ');
insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('НСКВЦ',   'Насковец Михаил Трофимович', 'м', 'ТЛ');

commit;