# Kettle绑定后端服务完成ETL任务
kettle是非常常见的开源ETL工具，提供了非常丰富的ETL组件，本例以kettle和mysql、postgreSQL后端服务为例，演示如何将kettle部署到datafoundry平台中，并绑定后端服务后，通过kettle的http任务执行器执行一个简单的ETL任务
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
trans1.ktr总体流程   
![总体流程](img/flow.png)   
data_source节点配置   
![](img/mysql.png)    
data_dest节点配置   
![](img/postgreSQL.png)    
1.  通过kettle http任务执行器执行ETL任务
``` 
curl http://<kettle-service>.app.dataos.io/kettle/executeTrans/?trans=/trans1.ktr
``` 
从容器中可以看到ETL任务执行情况
```
datagrid@datagrid-MacBookPro:~/Downloads$ oc logs -f kettle-service1-5-ri04y
/data-integration
2016/05/21 12:18:59 - Carte - Installing timer to purge stale objects after 1440 minutes.
2016-05-21 12:18:59.131::INFO:  Logging to STDERR via org.mortbay.log.StdErrLog
2016/05/21 12:18:59 - Carte - Created listener for webserver @ address : 0.0.0.0:8181
2016-05-21 12:18:59.191::INFO:  jetty-6.1.21
2016-05-21 12:19:23.533::INFO:  Started SocketConnector@0.0.0.0:8181
2016/05/21 12:19:40 - trans1 - Dispatching started for transformation [trans1]
2016/05/21 12:19:42 - data_dest.0 - Connected to database [postgresql] (commit=1000)
2016/05/21 12:19:43 - prepare_data.0 - Finished reading query, closing connection.
2016/05/21 12:19:43 - prepare_data.0 - Finished processing (I=0, O=0, R=0, W=1, U=0, E=0)
2016/05/21 12:19:43 - data_source.0 - Finished reading query, closing connection.
2016/05/21 12:19:43 - data_source.0 - Finished processing (I=9, O=0, R=0, W=9, U=0, E=0)
2016/05/21 12:19:43 - Get Variables.0 - Finished processing (I=0, O=0, R=1, W=1, U=0, E=0)
2016/05/21 12:19:43 - create_dest_table.0 - Finished reading query, closing connection.
2016/05/21 12:19:43 - create_dest_table.0 - Finished processing (I=0, O=0, R=9, W=9, U=0, E=0)
2016/05/21 12:19:44 - data_dest.0 - Finished processing (I=0, O=9, R=9, W=9, U=0, E=0)
2016/05/21 12:19:44 - waiting_for_create_source_data.0 - Finished processing (I=0, O=0, R=1, W=1, U=0, E=0)
```