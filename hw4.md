# Домашнее задание к занятию "Обновление приложений"

### Цель задания

Выбрать и настроить стратегию обновления приложения.

### Чеклист готовности к домашнему заданию

1. Кластер k8s.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Updating a Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#updating-a-deployment)
2. [Статья про стратегии обновлений](https://habr.com/ru/companies/flant/articles/471620/)

-----

### Задание 1. Выбрать стратегию обновления приложения и описать ваш выбор.

1. Имеется приложение, состоящее из нескольких реплик, которое требуется обновить.
2. Ресурсы, выделенные для приложения ограничены, и нет возможности их увеличить.
3. Запас по ресурсам в менее загруженный момент времени составляет 20%.
4. Обновление мажорное, новые версии приложения не умеют работать со старыми.
5. Какую стратегию обновления выберете и почему?

В вышеуказанных условиях подойдет несколько стратегий, все зависит от дополнительных параметров:  
1. при rolling update с ограничением на количество убиваемых нод 1 и количество новых нод 1, будет производиться попытка плавного обновления. 
Процесс займет какое-то время, но обеспечит постоянную доступность приложения. В случае ошибки обновления мы потеряем только 1 ноду, 
что не скажется на производительности, и будет возможность быстрого отката неудавшегося обновления.  
2. при recreate у нас единоразово убьются все ноды, и будет произведен запуск новых нод. В случае ошибки обновления у нас будет недоступность приложения. 
Но при данном обновлении будет задействовано меньше всего ресурсов и можно не дублировать БД и другие зависиящие от приложения сервисы.  
3. при green/blue стратегии с плавным переносом с одной версии на другию будет соблюдаться условие по ресурсам, 
но часть клиентов будет использовать старый версию, оставшиеся будут переходить на новую.


### Задание 2. Обновить приложение.

1. Создать deployment приложения с контейнерами nginx и multitool. Версию nginx взять 1.19. Кол-во реплик - 5.  
task.yaml  
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  replicas: 5
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 75%
      maxUnavailable: 75%
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.19
        ports:
        - containerPort: 80
      - name: multitool
        image: praqma/network-multitool
        env:
          - name: HTTP_PORT
            value: "1180"
          - name: HTTPS_PORT
            value: "11443"

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-srv
spec:
  selector:
    app: nginx
  ports:
  - name: nginx-srv
    protocol: TCP
    port: 1080
    targetPort: 80
```
``` 
user@master:~$ kubectl create -f task.yaml
deployment.apps/nginx created
service/nginx-srv created 
```  
```
user@master:~$ kubectl get pods
NAME                     READY   STATUS    RESTARTS   AGE
nginx-577b66ddf5-85g65   2/2     Running   0          22s
nginx-577b66ddf5-bt879   2/2     Running   0          22s
nginx-577b66ddf5-jl26k   2/2     Running   0          22s
nginx-577b66ddf5-pqzb5   2/2     Running   0          22s
nginx-577b66ddf5-vsfk8   2/2     Running   0          22s
```  
2. Обновить версию nginx в приложении до версии 1.20, сократив время обновления до минимума. Приложение должно быть доступно.
```
user@master:~$ kubectl apply -f task.yaml
Warning: resource deployments/nginx is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
deployment.apps/nginx configured
Warning: resource services/nginx-srv is missing the kubectl.kubernetes.io/last-applied-configuration annotation which is required by kubectl apply. kubectl apply should only be used on resources created declaratively by either kubectl create --save-config or kubectl apply. The missing annotation will be patched automatically.
service/nginx-srv configured
user@master:~$ kubectl get pods
NAME                     READY   STATUS              RESTARTS   AGE
nginx-577b66ddf5-bt879   2/2     Running             0          2m48s
nginx-577b66ddf5-jl26k   2/2     Running             0          2m48s
nginx-67944d9dc-68l8t    0/2     ContainerCreating   0          6s
nginx-67944d9dc-8krn2    0/2     ContainerCreating   0          6s
nginx-67944d9dc-c4sfn    0/2     ContainerCreating   0          6s
nginx-67944d9dc-dg9wg    0/2     ContainerCreating   0          6s
nginx-67944d9dc-hf4bz    0/2     ContainerCreating   0          6s
```
3. Попытаться обновить nginx до версии 1.28, приложение должно оставаться доступным.
```
user@master:~$ kubectl apply -f task.yaml
deployment.apps/nginx configured
service/nginx-srv unchanged
user@master:~$ kubectl get pods
NAME                     READY   STATUS              RESTARTS   AGE
nginx-54f88f4c99-5lp95   0/2     ContainerCreating   0          4s
nginx-54f88f4c99-7px9h   0/2     ContainerCreating   0          4s
nginx-54f88f4c99-9dgs9   0/2     ContainerCreating   0          4s
nginx-54f88f4c99-wr6f7   0/2     ContainerCreating   0          4s
nginx-54f88f4c99-xvggj   0/2     ContainerCreating   0          4s
nginx-67944d9dc-c4sfn    2/2     Running             0          105s
nginx-67944d9dc-hf4bz    2/2     Running             0          105s
user@master:~$ kubectl get pods
NAME                     READY   STATUS             RESTARTS   AGE
nginx-54f88f4c99-5lp95   1/2     ImagePullBackOff   0          16s
nginx-54f88f4c99-7px9h   1/2     ImagePullBackOff   0          16s
nginx-54f88f4c99-9dgs9   1/2     ImagePullBackOff   0          16s
nginx-54f88f4c99-wr6f7   1/2     ImagePullBackOff   0          16s
nginx-54f88f4c99-xvggj   1/2     ImagePullBackOff   0          16s
nginx-67944d9dc-c4sfn    2/2     Running            0          117s
nginx-67944d9dc-hf4bz    2/2     Running            0          117s
```  
4. Откатиться после неудачного обновления.
```
user@master:~$ kubectl rollout status deployment/nginx
Waiting for deployment "nginx" rollout to finish: 2 old replicas are pending termination...
user@master:~$ kubectl rollout undo deployment/nginx
deployment.apps/nginx rolled back
user@master:~$ kubectl rollout status deployment/nginx
Waiting for deployment "nginx" rollout to finish: 4 of 5 updated replicas are available...
deployment "nginx" successfully rolled out
user@master:~$ kubectl get pods
NAME                    READY   STATUS    RESTARTS   AGE
nginx-67944d9dc-4pwcz   2/2     Running   0          29s
nginx-67944d9dc-c4sfn   2/2     Running   0          4m56s
nginx-67944d9dc-gxwqr   2/2     Running   0          29s
nginx-67944d9dc-hf4bz   2/2     Running   0          4m56s
nginx-67944d9dc-w7bkj   2/2     Running   0          29s
```  

## Дополнительные задания (со звездочкой*)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.**   Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой дополнительные (необязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. 

### Задание 3*. Создать Canary deployment.

1. Создать 2 deployment'а приложения nginx.
2. При помощи разных ConfigMap сделать 2 версии приложения (веб-страницы).
3. С помощью ingress создать канареечный деплоймент, чтобы можно было часть трафика перебросить на разные версии приложения.

### Правила приема работы

1. Домашняя работа оформляется в своем Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md
