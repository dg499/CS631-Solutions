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

SELECT DISTINCT C.NAME FROM CUSTOMER C,"ORDER" O,PRODUCT P,LINEITEM L WHERE C.CID=O.CID AND O.OID=L.OID AND L.PID=P.PID AND P.PRODUCTNAME='Computer';

SELECT DISTINCT P.PRODUCTNAME FROM PRODUCT P ,LINEITEM L,"ORDER" O,CUSTOMER C WHERE C.CID IN
(SELECT C.CID FROM CUSTOMER C,"ORDER" O,PRODUCT P,LINEITEM L WHERE C.CID=O.CID AND O.OID=L.OID AND L.PID=P.PID AND P.PRODUCTNAME='Computer')AND C.CID=O.CID AND 
P.PID=L.PID AND L.OID=O.OID AND P.PRODUCTNAME!='Computer';

SELECT C.CID,C.NAME FROM CUSTOMER C,"ORDER" O WHERE C.CID=O.CID AND O."DATE" < TO_DATE('01-Jan-2014','DD-MON-YYYY'); 

SELECT DISTINCT P.PRODUCTNAME FROM PRODUCT P,"ORDER" O,LINEITEM L,CUSTOMER C WHERE P.PID=L.PID AND L.OID=O.OID AND O.CID=C.CID  AND C.CITY='Newark';




--NOT(products that are not bought by at least one customer of Newark)
SELECT DISTINCT L.pid, P.productname FROM lineitem L,product P WHERE P.pid=L.pid AND L.pid NOT IN
(SELECT l1.pid FROM "ORDER" o,customer C,lineitem l1 WHERE o.OID=l1.OID AND C.cid=o.cid  AND C.city='Newark' AND l1.pid NOT IN
(SELECT l2.pid FROM lineitem l2 WHERE l2.OID=l1.OID));

--NOT(products ordered by at least 1 customer not from Newark)
select p.PID,p.productname from product p where p.PID NOT IN
(select distinct p1.PID from product p1,"ORDER" o,lineitem l,customer c where p1.PID=l.PID and l.OID=o.OID and o.CID=c.CID  and c.city<>'Newark');
select p.productname from product p minus select p.productname from product p,"ORDER" o,lineitem l,customer c where p.PID=l.PID and l.OID=o.OID and o.CID=c.CID  and c.city!='Newark';


SELECT DISTINCT  P.productname FROM product P,lineitem L WHERE P.pid=L.pid  AND  L.pid NOT IN
(SELECT DISTINCT L.PID  FROM LINEITEM L, "ORDER" O,PRODUCT P, CUSTOMER C WHERE 
L.PID=P.PID AND  L.OID=O.OID AND O.CID=C.CID  AND  C.state='NJ' ) ;


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





