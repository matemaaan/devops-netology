# ДЗ 7  
### 1.  
> Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.  
> Приведите получившуюся команду или docker-compose манифест.  

```
version: "3.9"
services: 
    postgres:
        image: postgres:13
        environment:
            POSTGRES_DB: "pgdb"
            POSTGRES_USER: "pguser"
            POSTGRES_PASSWORD: "pgpass"
            PGDATA: "/var/lib/postgresql/data/pgdata"
        volumes:
            - data:/var/lib/postgresql/data/
            - backup:/backups
        ports:
            - "5433:5432"
volumes:
    data:
    backup:
```  

### 2.  
> В БД из задачи 1:  
>> создайте пользователя test-admin-user и БД test_db  

``` CREATE USER "test-admin-user" WITH PASSWORD 'test-admin-user'; ```  
``` create database test_db; ```  
>> в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
>> Таблица orders:
>>> id (serial primary key)
>>> наименование (string)
>>> цена (integer)
>> Таблица clients:
>>> id (serial primary key)
>>> фамилия (string)
>>> страна проживания (string, index)
>>> заказ (foreign key orders)

``` CREATE TABLE orders  (id SERIAL CONSTRAINT id_pk PRIMARY KEY ,  наименование character varying(100) ,  цена INT); ```  
``` CREATE TABLE clients  (id SERIAL CONSTRAINT id_cl_pk PRIMARY KEY ,  фамилия character varying(100) ,  "страна проживания" character varying(100) , заказ int REFERENCES orders (id)); ```  
``` CREATE INDEX idx_country ON clients("страна проживания"); ```  
>> предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db

``` GRANT ALL ON All Tables In Schema public TO "test-admin-user"; ```  
>> создайте пользователя test-simple-user

``` CREATE USER "test-simple-user" WITH PASSWORD 'test-simple-user'; ```  
>> предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

``` GRANT UPDATE, SELECT, insert, delete ON All Tables In Schema public TO "test-simple-user"; ```  
> Приведите:
>> итоговый список БД после выполнения пунктов выше,  

``` pgdb=# SELECT datname FROM pg_database WHERE datistemplate = false;
 datname  
----------
 postgres
 pgdb
 test_db
(3 rows)
```  
>> описание таблиц (describe)  

```
pgdb=# SELECT table_catalog, table_schema, table_name, column_name, column_default, is_nullable, data_type FROM information_schema.columns WHERE table_name in ('clients', 'orders');
 table_catalog | table_schema | table_name |    column_name    |           column_default            | is_nullable |     data_type     
---------------+--------------+------------+-------------------+-------------------------------------+-------------+-------------------
 pgdb          | public       | orders     | id                | nextval('orders_id_seq'::regclass)  | NO          | integer
 pgdb          | public       | orders     | наименование      |                                     | YES         | character varying
 pgdb          | public       | orders     | цена              |                                     | YES         | integer
 pgdb          | public       | clients    | id                | nextval('clients_id_seq'::regclass) | NO          | integer
 pgdb          | public       | clients    | фамилия           |                                     | YES         | character varying
 pgdb          | public       | clients    | страна проживания |                                     | YES         | character varying
 pgdb          | public       | clients    | заказ             |                                     | YES         | integer
(7 rows)
```  
>> SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
>> список пользователей с правами над таблицами test_db  

```
pgdb=# SELECT table_name, grantee, privilege_type FROM information_schema.role_table_grants WHERE table_name in ('clients', 'orders');
 table_name |     grantee      | privilege_type 
------------+------------------+----------------
 orders     | pguser           | INSERT
 orders     | pguser           | SELECT
 orders     | pguser           | UPDATE
 orders     | pguser           | DELETE
 orders     | pguser           | TRUNCATE
 orders     | pguser           | REFERENCES
 orders     | pguser           | TRIGGER
 orders     | test-admin-user  | INSERT
 orders     | test-admin-user  | SELECT
 orders     | test-admin-user  | UPDATE
 orders     | test-admin-user  | DELETE
 orders     | test-admin-user  | TRUNCATE
 orders     | test-admin-user  | REFERENCES
 orders     | test-admin-user  | TRIGGER
 orders     | test-simple-user | INSERT
 orders     | test-simple-user | SELECT
 orders     | test-simple-user | UPDATE
 orders     | test-simple-user | DELETE
 clients    | pguser           | INSERT
 clients    | pguser           | SELECT
 clients    | pguser           | UPDATE
 clients    | pguser           | DELETE
 clients    | pguser           | TRUNCATE
 clients    | pguser           | REFERENCES
 clients    | pguser           | TRIGGER
 clients    | test-admin-user  | INSERT
 clients    | test-admin-user  | SELECT
 clients    | test-admin-user  | UPDATE
 clients    | test-admin-user  | DELETE
 clients    | test-admin-user  | TRUNCATE
 clients    | test-admin-user  | REFERENCES
 clients    | test-admin-user  | TRIGGER
 clients    | test-simple-user | INSERT
 clients    | test-simple-user | SELECT
 clients    | test-simple-user | UPDATE
 clients    | test-simple-user | DELETE
(36 rows)
```  

### 3.  
> Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:  

``` INSERT INTO orders ("наименование", "цена") VALUES ('Шоколад', 10), ('Принтер', 3000), ('Книга', 500), ('Монитор', 7000), ('Гитара', 4000); ```  
> Таблица clients  

``` INSERT INTO clients ("фамилия", "страна проживания") VALUES ('Иванов Иван Иванович', 'USA'), ('Петров Петр Петрович', 'Canada'), ('Иоганн Себастьян Бах', 'Japan'), ('Ронни Джеймс Дио', 'Russia'), ('Ritchie Blackmore', 'Russia'); ```  

> Используя SQL синтаксис:
> вычислите количество записей для каждой таблицы
> приведите в ответе:
>> запросы
>> результаты их выполнения.

```
pgdb=# SELECT COUNT(*) FROM orders;
 count 
-------
     5
(1 row)

```  
```
pgdb=# SELECT COUNT(*) FROM clients;
 count 
-------
     5
(1 row)
```  

### 4.  
> Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.
> Используя foreign keys свяжите записи из таблиц, согласно таблице:  
> Приведите SQL-запросы для выполнения данных операций.
> Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
> Подсказк - используйте директиву UPDATE.  

``` 
update clients set заказ = 3 where фамилия = 'Иванов Иван Иванович'; 
UPDATE 1
```  
``` 
update clients set заказ = 4 where фамилия = 'Петров Петр Петрович'; 
UPDATE 1
```  
``` 
update clients set заказ = 5 where фамилия = 'Иоганн Себастьян Бах'; 
UPDATE 1
```  
```
select cl.фамилия, o.наименование from clients cl join orders o on o.id = cl.заказ;
       фамилия        | наименование 
----------------------+--------------
 Иванов Иван Иванович | Книга
 Петров Петр Петрович | Монитор
 Иоганн Себастьян Бах | Гитара
(3 rows)
```

### 5.  
> Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).
> Приведите получившийся результат и объясните что значат полученные значения.  

```
explain select cl.фамилия, o.наименование from clients cl join orders o on o.id = cl.заказ;
                               QUERY PLAN                                
-------------------------------------------------------------------------
 Hash Join  (cost=17.20..29.36 rows=170 width=436)
   Hash Cond: (cl."заказ" = o.id)
   ->  Seq Scan on clients cl  (cost=0.00..11.70 rows=170 width=222)
   ->  Hash  (cost=13.20..13.20 rows=320 width=222)
         ->  Seq Scan on orders o  (cost=0.00..13.20 rows=320 width=222)
(5 rows)
```  
seq scan - последовательный проход таблицы.  
cost - оценка затратности операции, первое значение - на получение первой строки, второе - на получение всех строк.  
rows - приблизительное кол-во возвращаемых строк.  
width - средний размер одной строки в байтах.  

### 6.  
> Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
> Остановите контейнер с PostgreSQL (но не удаляйте volumes).
> Поднимите новый пустой контейнер с PostgreSQL.
> Восстановите БД test_db в новом контейнере.
> Приведите список операций, который вы применяли для бэкапа данных и восстановления.  

``` pg_dump -U pguser -W test_db > /backup/test_db.dump ```
``` psql -U pguser -W test_db < /backup/test_db.dump ```
