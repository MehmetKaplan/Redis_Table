# Redis_Table

For relational database guys, Redis' data structure is strange at first.
But with 6 simple tricks you can get the most from Redis:

1. The most important thing is that, don't be afraid to generate lots of key-value pairs. So feel free to store each row of the table in a different row.
2. Use Redis' hash map data type
3. Form key name from primary key values of the table by a seperator (such as ":")
4. Store the remaining fields as a hash
5. When you want to query a single row, directly form the key and retrieve its results
6. When you want to query a range, use wild char "*" towards your key.

With that knowledge you can model a database table as follows in Redis:

Assume your table and its values are as follows:
```SQL
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
```

Now, as stated in (i) we are not afraid to generate new keys for each row. (OK this was super easy. :-) )
Next, as stated in (ii) we'll use hashmap data type of redis. The related commands are HMSET and HMGET.
Next, for step (iii), lets decide the key format. For our table, I decide to use format "my_table:[field1]:[field2]:[field3]" where square braces indicate values coming from related columns.
Next, for step (iv), lets insert our values as hashes.
```Redis
HMSET my_table:1:a:1 field4 'Redis is easy' field5 'SQL is powerful'
```
```Redis
HMSET my_table:1:a:2 field4 'Redis is easy' field5 'SQL is powerful'
```
```Redis
HMSET my_table:1:a:3 field4 'Redis is easy' field5 'SQL is powerful'
```
```Redis
HMSET my_table:1:b:1 field4 'Redis is easy' field5 'SQL is powerful'
```
```Redis
HMSET my_table:1:b:2 field4 'Redis is easy' field5 'SQL is powerful'
```
```Redis
HMSET my_table:1:b:3 field4 'Redis is easy' field5 'SQL is powerful'
```
```Redis
HMSET my_table:2:a:1 field4 'Redis is easy' field5 'SQL is powerful'
```
```Redis
HMSET my_table:2:b:1 field4 'Redis is easy' field5 'SQL is powerful'
```
```Redis
HMSET my_table:2:c:1 field4 'Redis is easy' field5 'SQL is powerful'
```
Now, for step (v), if we want to query ```1:b:2``` it is queried and returned values are as follows. (Remember, those fields are interpreted as a JSON object by the libraries of frequently used frameworks.)
```Redis
127.0.0.1:6379> HGETALL my_table:1:b:2
1) "field4"
2) "Redis is easy"
3) "field5"
4) "SQL is powerful"
```
And now, the fun part, if you want to query a range:
```Redis
127.0.0.1:6379> scan 0 MATCH my_table:2:*:1 count 10000000000
1) "0"
2) 1) "my_table:2:c:1"
	2) "my_table:2:b:1"
	3) "my_table:2:a:1"
```
At this moment, we can go the related data by direct access as step 5.

Remember, normally each framework has its own Redis library to use above keys in a cursor fashion.