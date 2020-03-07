
create table if not exists tmp(
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
load data inpath "prods_full.csv" into table tmp;

create table if not exists db.prods as
select
 prod.brand as brand,
 categ.id as categ_id,
 subcateg.id as subcateg_id,
 prod.vendorcode as vendorcode,
 prod.productname as productname,
 cast(prod.price as double) as price
    from db.tmp as prod
    join db.categories as categ on (categ.name = prod.category)
    join db.subcategories as subcateg on (subcateg.name = prod.subcategory);


-- beeline -u jdbc:hive2://sandbox-hdp.hortonworks.com:10000 -n hive -p hive --outputformat=csv2 -e "select * from db.prods" > prods.csv