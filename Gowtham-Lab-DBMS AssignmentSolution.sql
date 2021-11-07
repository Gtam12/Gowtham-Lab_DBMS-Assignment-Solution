-- An E-commerce website manages its data in the form of various tables.

create database if not exists `order-directory` ;

use `order-directory`;

-- 1)	
create table if not exists `supplier`(
	`SUPP_ID` int primary key,
    `SUPP_NAME` varchar(50) ,
	`SUPP_CITY` varchar(50),
	`SUPP_PHONE` varchar(10)
);


create table if not exists `customer` (
	`CUS_ID` int not null,
	`CUS_NAME` varchar(20) null default null,
	`CUS_PHONE` varchar(10),
	`CUS_CITY` varchar(30) ,
	`CUS_GENDER` CHAR,
	primary key (`CUS_ID`)
);


create table if not exists `category` (
	`CAT_ID` int not null,
	`CAT_NAME` varchar(20) null default null,
	primary key (`CAT_ID`)
);


create table if not exists `product` (
	`PRO_ID` int not null,
	`PRO_NAME` varchar(20) null default null,
	`PRO_DESC` varchar(60) null default null,
	`CAT_ID` int not null,
	primary key (`PRO_ID`),
	foreign key (`CAT_ID`) references category(`CAT_ID`)
);



 create table if not exists `product_details` (
	`PROD_ID` int not null,
	`PRO_ID` int not null,
	`SUPP_ID` int not null,
	`PROD_PRICE` int not null,
	primary key (`PROD_ID`),
	foreign key (`PRO_ID`) references product(`PRO_ID`),
	foreign key (`SUPP_ID`) references supplier(`SUPP_ID`)
);



create table if not exists `order` (
  `ORD_ID` int not null,
  `ORD_AMOUNT` int not null,
  `ORD_DATE` date,
  `CUS_ID` int not null,
  `PROD_ID` int not null,
  primary key (`ORD_ID`),
  foreign key (`CUS_ID`) references customer(`CUS_ID`),
  foreign key (`PROD_ID`) references product_details(`PROD_ID`)
);



create table if not exists `rating` (
	`RAT_ID` int not null,
	`CUS_ID` int not null,
	`SUPP_ID` int not null,
	`RAT_RATSTARS` int not null,
	primary key (`RAT_ID`),
	foreign key (`SUPP_ID`) references supplier(`SUPP_ID`),
	foreign key (`CUS_ID`) references customer(`CUS_ID`)
  );



insert into `supplier` values(1,"Rajesh Retails","Delhi",'1234567890');
insert into `supplier` values(2,"Appario Ltd.","Mumbai",'2589631470');
insert into `supplier` values(3,"Knome products","Banglore",'9785462315');
insert into `supplier` values(4,"Bansal Retails","Kochi",'8975463285');
insert into `supplier` values(5,"Mittal Ltd.","Lucknow",'7898456532');

insert into `CUSTOMER` values(1,"AAKASH",'9999999999',"DELHI",'M');
insert into `CUSTOMER` values(2,"AMAN",'9785463215',"NOIDA",'M');
insert into `CUSTOMER` values(3,"NEHA",'9999999999',"MUMBAI",'F');
insert into `CUSTOMER` values(4,"MEGHA",'9994562399',"KOLKATA",'F');
insert into `CUSTOMER` values(5,"PULKIT",'7895999999',"LUCKNOW",'M');

insert into `CATEGORY` values(1,"BOOKS");
insert into `CATEGORY` values(2,"GAMES");
insert into `CATEGORY` values(3,"GROCERIES");
insert into `CATEGORY` values(4,"ELECTRONICS");
insert into `CATEGORY` values(5,"CLOTHES");

insert into `PRODUCT` values(1,"GTA V","DFJDJFDJFDJFDJFJF",2);
insert into `PRODUCT` values(2,"TSHIRT","DFDFJDFJDKFD",5);
insert into `PRODUCT` values(3,"ROG LAPTOP","DFNTTNTNTERND",4);
insert into `PRODUCT` values(4,"OATS","REURENTBTOTH",3);
insert into `PRODUCT` values(5,"HARRY POTTER","NBEMCTHTJTH",1);

insert into `PRODUCT_DETAILS` values(1,1,2,1500);
insert into `PRODUCT_DETAILS` values(2,3,5,30000);
insert into `PRODUCT_DETAILS` values(3,5,1,3000);
insert into `PRODUCT_DETAILS` values(4,2,3,2500);
insert into `PRODUCT_DETAILS` values(5,4,1,1000);

insert into `ORDER` values (50,2000,"2021-10-06",2,1);
insert into `ORDER` values(20,1500,"2021-10-12",3,5);
insert into `ORDER` values(25,30500,"2021-09-16",5,2);
insert into `ORDER` values(26,2000,"2021-10-05",1,1);
insert into `ORDER` values(30,3500,"2021-08-16",4,3);

insert into `RATING` values(1,2,2,4);
insert into `RATING` values(2,3,4,3);
insert into `RATING` values(3,5,1,5);
insert into `RATING` values(4,1,3,2);
insert into `RATING` values(5,4,5,4);




-- 3

select count(*),cus_gender from customer c join `order` o on
c.CUS_ID = o.cus_id where o.ord_amount>=3000 group by c.cus_gender;

-- 4

select * from `order` o inner join product_details pd
on o.prod_id = pd.PROD_ID
inner join product p on pd.PRO_ID = p.PRO_ID
where o.CUS_ID=2;

-- 5

select * from supplier where supp_id in(select supp_id from product_details group by supp_id having count(*)>1);

-- 6
select cat_name from category c join product p on 
c.cat_id= p.cat_id where p.PRO_ID = (select pro_id from product_Details where prod_id=(
select PROD_ID from `order` where ORD_AMOUNT = (select min(ORD_AMOUNT) from `order`)));

-- 7


select p.pro_name, p.PRO_ID from product_details pd inner join `order` o 
on pd.PROD_ID=o.PROD_ID inner join 
product p on pd.PRO_id = p.pro_id where o.ord_date > '2021-10-05';

-- 8

select  s.supp_name, s.supp_id, r.RAT_RATSTARS from rating r inner join supplier s on
r.SUPP_ID = s.SUPP_ID 
inner join customer c on r.CUS_ID = c.cus_id order by r.RAT_RATSTARS desc limit 3;

-- 9

select cus_name, cus_gender
from customer
where cus_name like 'A%' or cus_name like '%A';

-- 10

select SUM(o.ord_amount) from `order` o join customer c on
o.CUS_ID = c.cus_id 
where c.CUS_GENDER = 'M';


-- 11

explain
select * from `order` o left outer join customer c on
o.CUS_ID = c.CUS_ID;


-- 12

DELIMITER //
CREATE PROCEDURE `SupplierRating`()
BEGIN
	select supplier.supp_id, supp_name, rat_ratstars, 
    case
		when rat_ratstars > 4 then "Genuine Supplier"
        when rat_ratstars > 2 then "Average Supplier"
        else "Supplier should not be considered"
	end
    from rating inner join supplier on rating.supp_id = supplier.supp_id; END  //
    DELIMITER ;
    
    
    
    








