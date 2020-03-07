#!/bin/bash
echo 'put csv files into hdfs'
hdfs dfs -put prods.csv
hdfs dfs -put category.csv
hdfs dfs -put subcategory.csv

echo 'executing init query'
beeline -u jdbc:hive2://sandbox-hdp.hortonworks.com:10000 -n hive -p hive -f init.hql
