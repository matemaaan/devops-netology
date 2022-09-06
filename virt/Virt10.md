# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [elasticsearch:7](https://hub.docker.com/_/elasticsearch) как базовый:

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib` 
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения
- обратите внимание на настройки безопасности такие как `xpack.security.enabled` 
- если докер образ не запускается и падает с ошибкой 137 в этом случае может помочь настройка `-e ES_HEAP_SIZE`
- при настройке `path` возможно потребуется настройка прав доступа на директорию

Далее мы будем работать с данным экземпляром elasticsearch.

``` 
docker run -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e "cluster.name=netology_test" elasticsearch:7.0.0
```  

```
d_shirokov@dshirokov:~/l8$ curl localhost:9200

{
  
	"name" : "0c5c343ccfe6",
  
	"cluster_name" : "netology_test",
  
	"cluster_uuid" : "WNQv_7onQqK09i9O_jp6mg",
  
	"version" : {
    
		"number" : "7.0.0",
    
		"build_flavor" : "default",
    
		"build_type" : "docker",
    
		"build_hash" : "b7e28a7",
    
		"build_date" : "2019-04-05T22:55:32.697037Z",
    
		"build_snapshot" : false,
    
		"lucene_version" : "8.0.0",
    
		"minimum_wire_compatibility_version" : "6.7.0",
    
		"minimum_index_compatibility_version" : "6.0.0-beta1"
  
	},
  
	"tagline" : "You Know, for Search"

}
```  


## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |
```
d_shirokov@dshirokov:~/l8$ curl -X PUT "localhost:9200/ind-1?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'  
{
  
	"acknowledged" : true,
  
	"shards_acknowledged" : true,
  
	"index" : "ind-1"

}
```  

```
d_shirokov@dshirokov:~/l8$ curl -X PUT "localhost:9200/ind-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 2,
    "number_of_replicas": 1
  }
}
'  

{
  
	"acknowledged" : true,
  
	"shards_acknowledged" : true,
  
	"index" : "ind-2"

}
```  

```
d_shirokov@dshirokov:~/l8$ curl -X PUT "localhost:9200/ind-3?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 4,
    "number_of_replicas": 2
  }
}
'
  
{
  
	"acknowledged" : true,
  
	"shards_acknowledged" : true,
  
	"index" : "ind-3"

}

```  

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.
```
d_shirokov@dshirokov:~/l8$ curl -X GET 'http://localhost:9200/_cat/indices?v'  

health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
  
yellow open   ind-3 vluDHmjLTuqGuPOjYyGl4g   4   2          0            0       920b           920b
  
green  open   ind-1 -bAb6voDRSavGq0CNsJZHw   1   0          0            0       230b           230b  

yellow open   ind-2 eY1C9TsVTru52QvD86VLtQ   2   1          0            0       460b           460b

```  

```
d_shirokov@dshirokov:~/l8$ curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
  
{
  
	"cluster_name" : "netology_test",
  
	"status" : "green",
  
	"timed_out" : false,
  
	"number_of_nodes" : 1,
  
	"number_of_data_nodes" : 1,
  
	"active_primary_shards" : 1,
  
	"active_shards" : 1,
  
	"relocating_shards" : 0,
  
	"initializing_shards" : 0,
  
	"unassigned_shards" : 0,
  
	"delayed_unassigned_shards" : 0,
  
	"number_of_pending_tasks" : 0,
  
	"number_of_in_flight_fetch" : 0,
  
	"task_max_waiting_in_queue_millis" : 0,
  
	"active_shards_percent_as_number" : 100.0

}
```  

```
d_shirokov@dshirokov:~/l8$ curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'  
{
  
	"cluster_name" : "netology_test",
  
	"status" : "yellow",
  
	"timed_out" : false,
  
	"number_of_nodes" : 1,
  
	"number_of_data_nodes" : 1,
  
	"active_primary_shards" : 2,
  
	"active_shards" : 2,
  
	"relocating_shards" : 0,
  
	"initializing_shards" : 0,
  
	"unassigned_shards" : 2,
  
	"delayed_unassigned_shards" : 0,
  
	"number_of_pending_tasks" : 0,
  
	"number_of_in_flight_fetch" : 0,
  
	"task_max_waiting_in_queue_millis" : 0,
  
	"active_shards_percent_as_number" : 41.17647058823529

}

```  

```
d_shirokov@dshirokov:~/l8$ curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'  

{
  
	"cluster_name" : "netology_test",
  
	"status" : "yellow",
  
	"timed_out" : false,
  
	"number_of_nodes" : 1,
  
	"number_of_data_nodes" : 1,
  
	"active_primary_shards" : 4,
  
	"active_shards" : 4,
  
	"relocating_shards" : 0,
  
	"initializing_shards" : 0,
  
	"unassigned_shards" : 8,
  
	"delayed_unassigned_shards" : 0,
  
	"number_of_pending_tasks" : 0,
  
	"number_of_in_flight_fetch" : 0,
  
	"task_max_waiting_in_queue_millis" : 0,
  
	"active_shards_percent_as_number" : 41.17647058823529

}

```  
Получите состояние кластера `elasticsearch`, используя API.
```
d_shirokov@dshirokov:~/l8$ curl -XGET localhost:9200/_cluster/health/?pretty=true  

{
  
	"cluster_name" : "netology_test",
  
	"status" : "yellow",
  
	"timed_out" : false,
  
	"number_of_nodes" : 1,
  
	"number_of_data_nodes" : 1,
  
	"active_primary_shards" : 7,
  
	"active_shards" : 7,
  
	"relocating_shards" : 0,
  
	"initializing_shards" : 0,
  
	"unassigned_shards" : 10,
  
	"delayed_unassigned_shards" : 0,
  
	"number_of_pending_tasks" : 0,
  
	"number_of_in_flight_fetch" : 0,
  
	"task_max_waiting_in_queue_millis" : 0,
  
	"active_shards_percent_as_number" : 41.17647058823529

}
```
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?  
``` часть индексов и кластер в состоянии yellow, т.к. им не хватает node чтобы развернуть все реплики ```  
Удалите все индексы.
```
d_shirokov@dshirokov:~/l8$ curl -X DELETE 'http://localhost:9200/ind-1?pretty'  

{
  
	"acknowledged" : true

}  
```  

```
d_shirokov@dshirokov:~/l8$ curl -X DELETE 'http://localhost:9200/ind-2?pretty'  

{
  
	"acknowledged" : true

}  
```  

```
d_shirokov@dshirokov:~/l8$ curl -X DELETE 'http://localhost:9200/ind-3?pretty'  

{
  
	"acknowledged" : true

}

```  
**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.
```  
docker run -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -e "cluster.name=netology_test" -e "path.repo=/usr/share/elasticsearch/snapshots" elasticsearch:7.0.0
```  

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.
```
d_shirokov@dshirokov:~/l8$ curl -XPOST localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { 

"location":"/usr/share/elasticsearch/snapshots" }}'
  
{
  
	"acknowledged" : true

}
 
```

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.
```
d_shirokov@dshirokov:~/l8$ curl -X PUT "localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'
  
{
  
	"acknowledged" : true,
  
	"shards_acknowledged" : true,
  
	"index" : "test"

}
```  

```
d_shirokov@dshirokov:~/l8$ curl -X GET 'http://localhost:9200/_cat/indices?v'
  
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
  
green  open   test  zOY2cFAaTUySyt_d9Zk8bg   1   0          0            0       230b           230b

```    

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.
```
d_shirokov@dshirokov:~/l8$ curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true  

{"snapshot":{"snapshot":"elasticsearch","uuid":"NrsHqIRJT2KnIHoUlyYbaw","version_id":7000099,"version":"7.0.0","indices":["test"],"include_global_state":true,"state":"SUCCESS","start_time":"2022-08-04T06:35:41.827Z","start_time_in_millis":1659594941827,"end_time":"2022-08-04T06:35:41.943Z","end_time_in_millis":1659594941943,"duration_in_millis":116,"failures":[],"shards":{"total":1,"failed":0,"successful":1}}}
```  

**Приведите в ответе** список файлов в директории со `snapshot`ами.
```
[root@b66528e4618d elasticsearch]# ll snapshots/  

total 40

-rw-rw-r-- 1 elasticsearch root   172 Aug  4 06:35 index-0

-rw-rw-r-- 1 elasticsearch root     8 Aug  4 06:35 index.latest

drwxrwxr-x 3 elasticsearch root  4096 Aug  4 06:35 indices

-rw-rw-r-- 1 elasticsearch root 21328 Aug  4 06:35 meta-NrsHqIRJT2KnIHoUlyYbaw.dat

-rw-rw-r-- 1 elasticsearch root   244 Aug  4 06:35 snap-NrsHqIRJT2KnIHoUlyYbaw.dat
```  
Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.
```
d_shirokov@dshirokov:~/l8$ curl -X DELETE 'http://localhost:9200/test?pretty'ttp://localhost:9200/test?pretty'
  
{
  
	"acknowledged" : true

}

```  
```
d_shirokov@dshirokov:~/l8$ curl -X PUT "localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 0
  }
}
'
  
{
  
	"acknowledged" : true,
  
	"shards_acknowledged" : true,
  
	"index" : "test-2"

}

```  
```
d_shirokov@dshirokov:~/l8$ curl -X GET 'http://localhost:9200/_cat/indices?v'  

health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
  
green  open   test-2 egYhkrrrTNKzcyMHMdfRAg   1   0          0            0       230b           230b

```  
[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 
```
d_shirokov@dshirokov:~/l8$ curl -X POST "localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty" -H 'Content-Type: application/json' -d'
{
  "indices": "test"
}
'
  
{
  
	"accepted" : true

}

```  
**Приведите в ответе** запрос к API восстановления и итоговый список индексов.
```
d_shirokov@dshirokov:~/l8$ curl -X GET 'http://localhost:9200/_cat/indices?v'
  
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size  

green  open   test   lDqJu5teQiGPCKzpmrGc4A   1   0          0            0       230b           230b  

green  open   test-2 egYhkrrrTNKzcyMHMdfRAg   1   0          0            0       283b           283b

```  
Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
