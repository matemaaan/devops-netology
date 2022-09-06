# PostgreSQL  
### 1.  
Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.  
```
version: '3.9'

services:

  postgres:
    image: postgres:13.3
    environment:
      POSTGRES_DB: "pgbase"
      POSTGRES_USER: "pguser"
      POSTGRES_PASSWORD: "pgpass"
    ports:
      - "5433:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data


volumes:
  pgdata:
```  
Подключитесь к БД PostgreSQL используя psql.  
``` psql -U pguser -h localhost -p 5433 -d pgbase ```  
Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.  

Найдите и приведите управляющие команды для:  

> вывода списка БД  

``` \l+ ```  
> подключения к БД  

``` \c ```  
> вывода списка таблиц

``` \dt+ ```  
> вывода описания содержимого таблиц

``` \dS+ ```  
> выхода из psql

``` \q ```  

### 2.  
Используя psql создайте БД test_database.
```
pgbase=# create database test_database;
CREATE DATABASE
```  
Изучите бэкап БД.

Восстановите бэкап БД в test_database.
``` psql -U pguser -h localhost -p 5433 -d test_database < test_dump.sql ```  
Перейдите в управляющую консоль psql внутри контейнера.
``` docker exec -it postgres-1 psql -U pguser -d pgbase ```  
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```
pgbase=# \c test_database 
You are now connected to database "test_database" as user "pguser".
test_database=# analyze verbose orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```  
Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.  
```
test_database=# select avg_width from pg_stats where tablename='orders';
 avg_width 
-----------
         4
        16
         4
(3 rows)
```  

### 3.  
Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.
```
test_database=# create table orders_1 (check ( price > 499 )) inherits ( orders );
CREATE TABLE
test_database=# create table orders_2 (check ( price <= 499 )) inherits ( orders );
CREATE TABLE
test_database=# create rule order_price_more_499 as on insert to orders where ( price > 499 ) do instead insert into orders_1 values (new.*);
CREATE RULE
test_database=# create rule order_price_less_499 as on insert to orders where ( price <= 499 ) do instead insert into orders_2 values (new.*);
CREATE RULE
```  
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?  
```
как вариант. использование секционированных таблиц
```

### 4.  
Используя утилиту pg_dump создайте бекап БД test_database.  
``` pg_dump -U pguser -W test_database > test_database.sql ```  
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?  
```
ALTER TABLE public.orders ADD CONSTRAINT unique_orders_title UNIQUE (title);
ALTER TABLE public.orders_1 ADD CONSTRAINT unique_orders_1_title UNIQUE (title);
ALTER TABLE public.orders_2 ADD CONSTRAINT unique_orders_2_title UNIQUE (title);
```
