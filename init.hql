-- create db
create database if not exists db;

-- use db;
use db;

-- create tmp table
create temporary table if not exists tmp_categ(id string, name string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   'separatorChar' = ',',
   'quoteChar' = '"',
   'escapeChar' = '\\'
   )
STORED AS TEXTFILE;
load data inpath "category.csv" into table tmp_categ;

-- create categories
drop table if exists categories;
create table if not exists categories
STORED AS TEXTFILE
AS SELECT
    cast(id as int), name
FROM
    tmp_categ;

-- create tmp table
create temporary table if not exists tmp_subcateg(id string, name string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   'separatorChar' = ',',
   'quoteChar' = '"',
   'escapeChar' = '\\'
   )
STORED AS TEXTFILE;
load data inpath "subcategory.csv" into table tmp_subcateg;

-- create subCategories
drop table if exists subcategories;
create table if not exists subcategories
STORED AS TEXTFILE
AS SELECT
    cast(id as int), name
FROM
    tmp_subcateg;

-- create tmp table
create temporary table if not exists tmp_prods(
    brand string,
    categ_id string,
    subcateg_id string,
    vendorcode string,
    name string,
    price string)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   'separatorChar' = ',',
   'quoteChar' = '"',
   'escapeChar' = '\\'
   )
STORED AS TEXTFILE
TBLPROPERTIES ('skip.header.line.count'='1');
load data inpath "prods.csv" into table tmp_prods;

-- create products
drop table if exists products;
CREATE TABLE IF NOT EXISTS products(
   categ_id int,
   subcateg_id int,
   vendorCode string,
   name string,
   price double
   )
partitioned by (brand string)
clustered by (categ_id) into 16 buckets
row format delimited fields terminated by ','
stored as rcfile;

INSERT overwrite TABLE products
partition (brand='BRAND1')
SELECT
    cast(categ_id as int),
    cast(subcateg_id as int),
    vendorcode,
    name,
    cast(price as double)
FROM tmp_prods
where brand='BRAND1';

INSERT overwrite TABLE products
partition (brand='BRAND2')
SELECT
    cast(categ_id as int),
    cast(subcateg_id as int),
    vendorcode,
    name,
    cast(price as double)
FROM tmp_prods
where brand='BRAND2';

INSERT overwrite TABLE products
partition (brand='BRAND3')
SELECT
    cast(categ_id as int),
    cast(subcateg_id as int),
    vendorcode,
    name,
    cast(price as double)
FROM tmp_prods
where brand='BRAND3';
