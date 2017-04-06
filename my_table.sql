create table my_table
(
	field1 integer,
	field2 varchar(10),
	field3 integer,
	field4 varchar(128),
	field5 varchar(128),
	primary key (field1, field2, field3)
);
insert into my_table values(1, 'a', 1, 'Redis is easy', 'SQL is powerful');
insert into my_table values(1, 'a', 2, 'Redis is easy', 'SQL is powerful');
insert into my_table values(1, 'a', 3, 'Redis is easy', 'SQL is powerful');
insert into my_table values(1, 'b', 1, 'Redis is easy', 'SQL is powerful');
insert into my_table values(1, 'b', 2, 'Redis is easy', 'SQL is powerful');
insert into my_table values(1, 'b', 3, 'Redis is easy', 'SQL is powerful');
insert into my_table values(2, 'a', 1, 'Redis is easy', 'SQL is powerful');
insert into my_table values(2, 'b', 1, 'Redis is easy', 'SQL is powerful');
insert into my_table values(2, 'c', 1, 'Redis is easy', 'SQL is powerful');
