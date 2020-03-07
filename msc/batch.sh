#!/bin/bash
echo 'put prods.csv into hdfs'
hdfs dfs -put prods.csv

echo 'executing query - create table'
beeline -u jdbc:hive2://sandbox-hdp.hortonworks.com:10000 -n hive -p hive -f create_table.hql

echo 'executing query - create partitions'
beeline -u jdbc:hive2://sandbox-hdp.hortonworks.com:10000 -n hive -p hive -f create_partitions.hql

