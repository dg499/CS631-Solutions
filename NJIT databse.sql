select * from CUSTOMER;
select * from product;
select * from "ORDER";
select * from LINEITEM;



/*
1. List the customers who ordered computers
2. List the other products bought by customers who bought computers
3. List the customers who did not place any order since January 1 2014
4. List the products bought by at least one customer of Newark
5. List the products bought by all the customers of Newark
6. List the products ordered only by the customers of Newark
7. List the products never ordered by customers of New Jersey
*/

select distinct c.name from customer c,"ORDER" o,product p,lineitem l where c.CID=o.CID and o.OID=l.OID and l.PID=p.PID and p.ProductName='Computer';

select distinct p.productname from product p ,lineitem l,"ORDER" o,customer c where c.CID in
(select c.CID from customer c,"ORDER" o,product p,lineitem l where c.CID=o.CID and o.OID=l.OID and l.PID=p.PID and p.ProductName='Computer')and c.CID=o.CID and 
p.PID=l.PId and l.OID=o.OID and p.productname!='computer';

select c.CID,c.name from customer c,"ORDER" o where c.CID=o.CID and o."DATE" < TO_DATE('01-Jan-2014','DD-MON-YYYY'); 

select p.productname from product p,"ORDER" o,lineitem l,customer c where p.PID=l.PID and l.OID=o.OID and o.CID=c.CID  and c.city='Newark';

--NOT(products that are not bought by at least one customer of Newark)
select distinct l.PID, p.productname from lineitem l,product p where p.PID=l.PID and l.PID NOT IN
(select l1.PID from "ORDER" o,customer c,lineitem l1 where o.OID=l1.OID and c.CID=o.CID  and c.city='Newark' and l1.PID NOT IN
(select l2.PID from lineitem l2 where l2.OID=l1.OID));

--NOT(products ordered by at least 1 customer not from Newark)
select p.PID,p.productname from product p where p.PID NOT IN
(select distinct p1.PID from product p1,"ORDER" o,lineitem l,customer c where p1.PID=l.PID and l.OID=o.OID and o.CID=c.CID  and c.city<>'Newark');
select p.productname from product p minus select p.productname from product p,"ORDER" o,lineitem l,customer c where p.PID=l.PID and l.OID=o.OID and o.CID=c.CID  and c.city!='Newark';


drop view productmonth;

create view productmonth as 
select p.pid, p.productname,to_char("DATE",'yyyy/mm') as "year/month",sum("NUMBER") as "quantitysold", count(distinct c.cid) as numberofcustomer, sum(l."totalprice") as revenue from customer c,"ORDER" o,product p,lineitem l where c.CID=o.CID and o.OID=l.OID and l.PID=p.PID group by p.pid, p.productname,to_char("DATE",'yyyy/mm')
order by to_char("DATE",'yyyy/mm');

select * from productmonth where "year/month"='2019/02';
--Which product is the most popular (in term of number of distinct customers it)?


select p.pid, p.productname ,  count(distinct c.cid) as numberofcustomer  from customer c,"ORDER" o,product p,lineitem l where c.CID=o.CID and o.OID=l.OID and l.PID=p.PID group by p.pid, p.productname order by count(distinct c.cid) desc fetch first 1 rows only;

drop view mostpopularproduct;
create view mostpopularproduct as
select pid,productname,numberofcustomer from
(select p.pid, p.productname ,  count(distinct c.cid) as numberofcustomer  from customer c,"ORDER" o,product p,lineitem l where c.CID=o.CID and o.OID=l.OID and l.PID=p.PID group by p.pid, p.productname order by count(distinct c.cid) desc ) fetch first 1 rows only;




select * from mostpopularproduct;





