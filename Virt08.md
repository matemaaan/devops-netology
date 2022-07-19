# ДЗ 8  
### 1.  
> Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.  

```
version: '3.9'

services:

  db:
    image: mysql:8.0
    container_name: db
    restart: unless-stopped
    tty: true
    ports:
      - "3306:3306"
    environment:
      MYSQL_DATABASE: mysql_db
      MYSQL_ROOT_PASSWORD: password
      MYSQL_USER: db_user
      MYSQL_PASSWORD: db_user_pass
    volumes:
      - dbdata:/var/lib/mysql/

volumes:
  dbdata:
```  
> Изучите бэкап БД и восстановитесь из него.

``` docker exec -i db sh -c 'exec mysql -udb_user -p"db_user_pass" mysql_db' < test_dump.sql ```  
> Перейдите в управляющую консоль mysql внутри контейнера.

```
docker exec -it db mysql -udb_user -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
```  
> Используя команду \h получите список управляющих команд.  

```
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
```  
> Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.

``` status    (\s) Get status information from the server. ```  
```
mysql> \s
--------------
mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:		13
Current database:	
Current user:		db_user@localhost
SSL:			Not in use
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.29 MySQL Community Server - GPL
Protocol version:	10
Connection:		Localhost via UNIX socket
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	latin1
Conn.  characterset:	latin1
UNIX socket:		/var/run/mysqld/mysqld.sock
Binary data as:		Hexadecimal
Uptime:			52 min 11 sec

Threads: 2  Questions: 53  Slow queries: 0  Opens: 136  Flush tables: 3  Open tables: 54  Queries per second avg: 0.016
--------------
```  
> Подключитесь к восстановленной БД и получите список таблиц из этой БД.

```
mysql> use mysql_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+--------------------+
| Tables_in_mysql_db |
+--------------------+
| orders             |
+--------------------+
1 row in set (0.00 sec)
```

> Приведите в ответе количество записей с price > 300.

```
mysql> select * from orders where price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)
```  
В следующих заданиях мы будем продолжать работу с данным контейнером.  

### 2.  
> Создайте пользователя test в БД c паролем test-pass, используя:

  плагин авторизации mysql_native_password
  срок истечения пароля - 180 дней
  количество попыток авторизации - 3
  максимальное количество запросов в час - 100
  аттрибуты пользователя:
    Фамилия "Pretty"
    Имя "James"

```
mysql> create user 'test'@'localhost' identified with mysql_native_password by 'test-pass' password expire interval 180 day failed_login_attempts 3 attribute '{"fname": "Pretty", "lname": "James"}';
Query OK, 0 rows affected (0.00 sec)

mysql> alter user 'test'@'localhost' with max_queries_per_hour 100;
Query OK, 0 rows affected (0.00 sec)
```  
> Предоставьте привелегии пользователю test на операции SELECT базы test_db.

```
mysql> grant select on test_db.* to 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.01 sec)
```  
> Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.  

```
mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "Pretty", "lname": "James"} |
+------+-----------+---------------------------------------+
1 row in set (0.01 sec)
```  

### 3.  
> Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.

```
mysql> SET PROFILING=1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SHOW PROFILES;
Empty set, 1 warning (0.00 sec)

mysql> show tables;
+--------------------+
| Tables_in_mysql_db |
+--------------------+
| orders             |
+--------------------+
1 row in set (0.01 sec)

mysql> SHOW PROFILES;
+----------+------------+-------------+
| Query_ID | Duration   | Query       |
+----------+------------+-------------+
|        1 | 0.00073850 | show tables |
+----------+------------+-------------+
1 row in set, 1 warning (0.00 sec)
```  
> Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.

```
mysql> SHOW TABLE STATUS WHERE Name = 'orders';
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time         | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| orders | InnoDB |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2022-07-19 16:43:32 | 2022-07-19 16:43:32 | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.00 sec)
```
InnoDB  
> Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:

    на MyISAM
    
```
mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW TABLE STATUS WHERE Name = 'orders';
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time         | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| orders | MyISAM |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2022-07-19 18:21:00 | 2022-07-19 16:43:32 | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.00 sec)
```  
    на InnoDB
```
mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.01 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW TABLE STATUS WHERE Name = 'orders';
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| Name   | Engine | Version | Row_format | Rows | Avg_row_length | Data_length | Max_data_length | Index_length | Data_free | Auto_increment | Create_time         | Update_time         | Check_time | Collation          | Checksum | Create_options | Comment |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
| orders | InnoDB |      10 | Dynamic    |    5 |           3276 |       16384 |               0 |            0 |         0 |              6 | 2022-07-19 18:22:05 | 2022-07-19 16:43:32 | NULL       | utf8mb4_0900_ai_ci |     NULL |                |         |
+--------+--------+---------+------------+------+----------------+-------------+-----------------+--------------+-----------+----------------+---------------------+---------------------+------------+--------------------+----------+----------------+---------+
1 row in set (0.00 sec)
```
```
mysql> SHOW PROFILES;
+----------+------------+-----------------------------------------+
| Query_ID | Duration   | Query                                   |
+----------+------------+-----------------------------------------+
|        1 | 0.00073850 | show tables                             |
|        2 | 0.00191800 | SHOW TABLE STATUS WHERE Name = 'orders' |
|        3 | 0.00880575 | ALTER TABLE orders ENGINE = MyISAM      |
|        4 | 0.00096750 | SHOW TABLE STATUS WHERE Name = 'orders' |
|        5 | 0.01103975 | ALTER TABLE orders ENGINE = InnoDB      |
|        6 | 0.00091100 | SHOW TABLE STATUS WHERE Name = 'orders' |
+----------+------------+-----------------------------------------+
6 rows in set, 1 warning (0.00 sec)
```

### 4.  
> Изучите файл my.cnf в директории /etc/mysql.
> Измените его согласно ТЗ (движок InnoDB):
>>    Скорость IO важнее сохранности данных
>>    Нужна компрессия таблиц для экономии места на диске
>>    Размер буффера с незакомиченными транзакциями 1 Мб
>>    Буффер кеширования 30% от ОЗУ
>>    Размер файла логов операций 100 Мб
> Приведите в ответе измененный файл my.cnf.

```
bash-4.4# cat /etc/my.cnf
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.0/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password
skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql

innodb_buffer_pool_size        = 5G
innodb_log_file_size           = 100M
innodb_log_buffer_size         = 1M
innodb_file_per_table          = 1
innodb_flush_method            = O_DSYNC
innodb_flush_log_at_trx_commit = 2
query_cache_size               = 0

pid-file=/var/run/mysqld/mysqld.pid
[client]
socket=/var/run/mysqld/mysqld.sock

!includedir /etc/mysql/conf.d/

```
