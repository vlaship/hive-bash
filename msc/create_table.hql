-- create db
create database if not exists company_db;

-- use db;
use db;

-- create tmp table
drop table if exists tmp_prod;

create temporary table if not exists tmp_prod(
   brand string,
   category string,
   subCategory string,
   vendorCode string,
   productName string,
   price double
   )
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   'separatorChar' = ';',
   'quoteChar' = '"',
   'escapeChar' = '\\'
   )
STORED AS TEXTFILE
TBLPROPERTIES ('skip.header.line.count'='1');
load data inpath "prods.csv" into table tmp_prod;

-- create products
drop table if exists products;
create table if not exists products
STORED AS TEXTFILE
AS SELECT
    brand, category, subCategory, vendorCode, productName, cast(price as double)
FROM
    tmp_prod;