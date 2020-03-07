use db;

CREATE TABLE IF NOT EXISTS prodBPRC(
   categ_id int,
   subcateg_id int,
   vendorCode string,
   productName string,
   price double
   )
partitioned by (brand string)
clustered by (category) into 16 buckets
row format delimited fields terminated by ','
stored as rcfile;

INSERT overwrite TABLE prodBPRC
partition (brand='BRAND1')
SELECT
    categ_id, subcateg_id, vendorCode, productName, price
FROM
    products
where brand='BRAND1';

INSERT overwrite TABLE prodBPRC
partition (brand='BRAND2')
SELECT
    categ_id, subcateg_id, vendorCode, productName, price
FROM
    products
where brand='BRAND2';

INSERT overwrite TABLE prodBPRC
partition (brand='BRAND3')
SELECT
    categ_id, subcateg_id, vendorCode, productName, price
FROM
    products
where brand='BRAND3';
