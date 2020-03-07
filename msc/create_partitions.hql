use db;

CREATE TABLE IF NOT EXISTS prodPRC
(
  category string,
   subCategory string,
   vendorCode string,
   productName string,
   price double)
partitioned by (brand string)
row format delimited fields terminated by ','
stored as rcfile;

INSERT overwrite TABLE prodPRC
partition (brand='BRAND1')
SELECT
    category, subCategory, vendorCode, productName, price
FROM
    products
where brand='BRAND1';

INSERT overwrite TABLE prodPRC
partition (brand='BRAND2')
SELECT
    category, subCategory, vendorCode, productName, price
FROM
    products
where brand='BRAND2';

INSERT overwrite TABLE prodPRC
partition (brand='BRAND3')
SELECT
    category, subCategory, vendorCode, productName, price
FROM
    products
where brand='BRAND3';
