# Kettle绑定后端服务完成ETL任务
kettle是非常常见的开源ETL工具，提供了非常丰富的ETL工具，本例以kettle和mysql、postgreSQL后端服务为例，演示如何将kettle部署到datafoundry平台中，并绑定后端服务后，通过kettle的http任务执行器执行一个简单的ETL任务
1.  构建kettle镜像
``` 
oc new-app https://github.com/datafoundry/kettle-service.git
oc expose svc kettle-service
``` 
1.  创建MYSQL后端服务实例并绑定kettle
``` 
oc new-backingserviceinstance mysqlinst \
--backingservice_name=Mysql \
--planid=56660431-6032-43D0-A114-FFA3BF521B66
oc bind mysqlinst kettle-service
``` 
1.  创建postgreSQL后端服务实例并绑定kettle
``` 
oc new-backingserviceinstance postgresqlinst  \
--backingservice_name=PostgreSQL \
--planid=bd9a94f2-5718-4dde-a773-61ff4ad9e843
oc bind postgresqlinst kettle-service
```   
1.  查看kettle镜像中的一个ETL任务
