# Домашнее задание к занятию "Troubleshooting"

### Цель задания

Устранить неисправности при деплое приложения.

### Чеклист готовности к домашнему заданию

1. Кластер k8s.

### Задание. При деплое приложение web-consumer не может подключиться к auth-db. Необходимо это исправить.

1. Установить приложение по команде:
```shell
kubectl apply -f https://raw.githubusercontent.com/netology-code/kuber-homeworks/main/3.5/files/task.yaml
```  
при попытке установить приложение получаем сообщение об ошибке  
2. Выявить проблему и описать.  
из описания ошибки видим, что не хватает пространств имен web и data  
3. Исправить проблему, описать, что сделано.  
можем создать пространоство имен при помощи команд:  
```kubectl create namespace web```  
```kubectl create namespace data```  
и после чего повторить установку  
либо создать файл (напрмиер, ns.yaml) и прописать в нем создание пространтва имен:  
```
apiVersion: v1
kind: Namespace
metadata:
  name: web
---
apiVersion: v1
kind: Namespace
metadata:
  name: data
```  
после чего запустить ```kubectl create -f  ns.yaml```    
после чего повторить установку  
либо при помощи wget скачать файл и добавить создание пространства имен в нем для исключения возникновения данной ситуации в дальнейшем,что я и сделал  
после чего выполнить установку из отредактированного файла  
4. Продемонстрировать, что проблема решена.  
После внесенных изменений приложения запускаются, каждый в своем пространстве имен  

![image](https://user-images.githubusercontent.com/89702147/233573262-b2408c90-4827-4de6-b31b-9be4135a73a3.png)  
```
apiVersion: v1
kind: Namespace
metadata:
  name: web
---
apiVersion: v1
kind: Namespace
metadata:
  name: data
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-consumer
  namespace: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-consumer
  template:
    metadata:
      labels:
        app: web-consumer
    spec:
      containers:
      - command:
        - sh
        - -c
        - while true; do curl auth-db; sleep 5; done
        image: radial/busyboxplus:curl
        name: busybox
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: auth-db
  namespace: data
spec:
  replicas: 1
  selector:
    matchLabels:
      app: auth-db
  template:
    metadata:
      labels:
        app: auth-db
    spec:
      containers:
      - image: nginx:1.19.1
        name: nginx
        ports:
        - containerPort: 80
          protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: auth-db
  namespace: data
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: auth-db
```  


### Правила приема работы

1. Домашняя работа оформляется в своем Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md

