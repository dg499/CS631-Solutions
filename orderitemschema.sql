drop table lineitem;
drop table product;
DROP INDEX ORD_CUSTOMER_IX;
drop table "ORDER";
DROP INDEX CUST_NAME_IX;
drop table customer;

drop sequence CUST_SEQ;
drop sequence ORD_SEQ;
drop sequence PROD_SEQ;
drop sequence LINEITEM_SEQ;

create sequence CUST_SEQ start with 100;
create sequence ORD_SEQ start with 100;
create sequence PROD_SEQ start with 100;
create sequence LINEITEM_SEQ start with 100;



CREATE TABLE  "CUSTOMER" (     
    "CID"          NUMBER       NOT NULL ENABLE, 
    "NAME"      VARCHAR2(20) NOT NULL ENABLE, 
    "CITY"            VARCHAR2(30), 
    "STATE"           VARCHAR2(2),
    CONSTRAINT "customer_PK" PRIMARY KEY ("CID") ENABLE
 );

CREATE INDEX  "CUST_NAME_IX" ON  "CUSTOMER" ("NAME");

CREATE OR REPLACE TRIGGER  "customer_BIU" 
  before insert or update ON customer FOR EACH ROW 
DECLARE 
  cust_id number; 
BEGIN 
  if inserting then   
    if :new.CID is null then 
      select cust_seq.nextval 
        into cust_id 
        from dual; 
      :new.CID := cust_id; 
    end if; 
  end if; 
END; 
/



CREATE TABLE  "PRODUCT" (     
    "PID"          NUMBER NOT NULL ENABLE, 
    "PRODUCTNAME"        VARCHAR2(50),
    "PRICE"          NUMBER(8,2),
    CONSTRAINT "product_PK" primary key ("PID") ENABLE, 
    CONSTRAINT "product_UK" unique ("PRODUCTNAME") ENABLE 
);

CREATE OR REPLACE TRIGGER  "product_BIU" 
  before insert or update ON product FOR EACH ROW 
DECLARE 
  prod_id number; 
BEGIN 
  if inserting then   
    if :new.PID is null then 
      select prod_seq.nextval 
        into prod_id 
        from dual; 
      :new.PID := prod_id; 
    end if; 
  end if; 
END; 
/

CREATE TABLE  "ORDER" (     
    "OID"           NUMBER NOT NULL ENABLE, 
    "CID"        NUMBER NOT NULL ENABLE, 
    "DATE"    DATE DEFAULT CURRENT_DATE, 
    CONSTRAINT "ORDER_PK" PRIMARY KEY ("OID") ENABLE, 
    CONSTRAINT "ORDER_cid_FK" FOREIGN KEY ("CID") 
    REFERENCES  "CUSTOMER" ("CID") ON DELETE CASCADE ENABLE 
);

CREATE INDEX  "ORD_CUSTOMER_IX" ON  "ORDER" ("CID");

CREATE OR REPLACE TRIGGER  "ORDER_BIU" 
  before insert or update ON "ORDER" FOR EACH ROW 
DECLARE 
  oid number; 
BEGIN 
  if inserting then   
    if :new.oid is null then 
      select ord_seq.nextval 
        INTO oid 
        FROM dual; 
      :new.oid := oid; 
    end if; 
  end if; 
 
END; 
/
CREATE TABLE  "LINEITEM" ( 
    "LID" NUMBER(3,0) NOT NULL ENABLE, 
    "OID" NUMBER NOT NULL ENABLE, 
    "PID" NUMBER NOT NULL ENABLE, 
	"NUMBER" NUMBER(8,0) NOT NULL ENABLE, 
    "totalprice" NUMBER(8,2) NOT NULL ENABLE,     
    CONSTRAINT "LINEITEM_PK" PRIMARY KEY ("LID") ENABLE, 
    CONSTRAINT "LINEITEM_UK" UNIQUE ("OID","PID") ENABLE, 
    CONSTRAINT "LINEITEM_FK" FOREIGN KEY ("OID") 
     REFERENCES  "ORDER" ("OID") ON DELETE CASCADE ENABLE, 
    CONSTRAINT "LINEITEM_PID_FK" FOREIGN KEY ("PID") 
     REFERENCES  "PRODUCT" ("PID") ON DELETE CASCADE ENABLE 
);

CREATE OR REPLACE TRIGGER  "LINEITEM_BI" 
  BEFORE insert on "LINEITEM" for each row 
declare 
  lineitem_id number; 
begin 
  if :new.lid is null then 
    select lineitem_seq.nextval  
      into lineitem_id  
      from dual; 
    :new.lid := lineitem_id; 
  end if; 
end; 
/

INSERT INTO customer (cid, name, city, state) VALUES(1, 'John Dulles', 'Sterling', 'VA');
INSERT INTO customer (cid, name, city, state) VALUES(2, 'William Hartsfield', 'Atlanta', 'GA');
INSERT INTO customer (cid, name, city, state) VALUES(3, 'Edward Logan', 'Newark', 'NJ');
INSERT INTO customer (cid, name, city, state) VALUES(4, 'Frank OHare', 'Chicago', 'IL');
INSERT INTO customer (cid, name, city, state) VALUES(5, 'Fiorello LaGuardia','Flushing', 'NY');
INSERT INTO customer (cid, name, city, state) VALUES(6, 'Albert Lambert', 'St. Louis', 'MO');
INSERT INTO customer (cid, name, city, state) VALUES(7, 'Eugene Bradley','Windsor Locks', 'CT');
INSERT INTO customer (cid, name, city, state) VALUES(8, 'Ruther Ford','Seattle', 'WA');
INSERT INTO customer (cid, name, city, state) VALUES(9, 'Martin Jackob','Newark', 'NJ');
INSERT INTO customer (cid, name, city, state) VALUES(10,'Erwin Ira','Newark', 'NJ');

INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(1, 7, sysdate-360);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(2, 1, sysdate-720);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(3, 2, sysdate-969);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(4, 5, sysdate-120);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(5, 6, sysdate-1020);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(6, 3, sysdate-564);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(7, 3, sysdate-1400);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(8, 4, sysdate-1600);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(9, 2, sysdate-1800);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(10,8, sysdate-1700);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(11,10, sysdate-2300);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(12,10, sysdate-35);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(13,3, sysdate-3);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(14,3, sysdate-360);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(15, 7, sysdate-720);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(16,4, sysdate-360);
INSERT INTO "ORDER" (oid, cid, "DATE") VALUES(17,5, sysdate-360);

INSERT INTO product (PID, PRODUCTNAME,  PRICE) VALUES(1, 'Computer', 50);
INSERT INTO product (PID, PRODUCTNAME,  PRICE) VALUES(2, 'Trousers',  80);
INSERT INTO product (PID, PRODUCTNAME,  PRICE) VALUES(3, 'Jacket', 150);
INSERT INTO product (PID, PRODUCTNAME,  PRICE) VALUES(4, 'Blouse',  60);
INSERT INTO product (PID, PRODUCTNAME,  PRICE) VALUES(5, 'Skirt', 80);
INSERT INTO product (PID, PRODUCTNAME,  PRICE) VALUES(6, 'Ladies Shoes', 120);
INSERT INTO product (PID, PRODUCTNAME,  PRICE) VALUES(7, 'Belt', 30);
INSERT INTO product (PID, PRODUCTNAME,  PRICE) VALUES(8, 'Bag', 125);
INSERT INTO product (PID, PRODUCTNAME,  PRICE) VALUES(9, 'Mens Shoes', 110);
INSERT INTO product (PID, PRODUCTNAME,  PRICE) VALUES(10, 'Wallet', 50);
INSERT INTO product (PID, PRODUCTNAME,  PRICE) VALUES(11, 'Pencil', 10);
INSERT INTO product (PID, PRODUCTNAME,  PRICE) VALUES(12, 'Book', 20);

INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 1, 1, 500, 10);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 1, 2, 640, 8);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 1, 3, 750, 5);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 2, 1, 150, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 2, 2, 240, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 2, 3, 450, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 2, 4, 180, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 2, 5, 240, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 2, 6, 240, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 2, 7, 60, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 2, 8, 500, 4);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 2, 9, 220, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 2, 10, 100, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 3, 4, 240, 4);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 3, 5, 320, 4);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 3, 6, 480, 4);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 3, 8, 500, 4);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 3, 10, 100, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 4, 6, 240, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 4, 7, 180, 6);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 4, 8, 250, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 4, 9, 220, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 4, 10, 200, 4);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 5, 1, 150, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 5, 2, 160, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 5, 3, 300, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 5, 4, 180, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 5, 5, 160, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 6, 3, 450, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 6, 6, 360, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 6, 8, 375, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 6, 9, 330, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 7, 1, 100, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 7, 2, 160, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 7, 4, 120, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 7, 5, 160, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 7, 7, 90, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 7, 8, 125, 1);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 7, 10, 150, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 8, 2, 160, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 8, 3, 450, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 8, 6, 120, 1);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 8, 9, 330, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 9, 4, 240, 4);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 9, 5, 240, 3);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 9, 8, 250, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 10, 1, 250, 5);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 10, 2, 320, 4);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 10, 3, 300, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 11, 1, 250, 5);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 12, 2, 320, 4);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 12, 3, 300, 2);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 13, 12, 200, 10);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 14, 1, 1000, 20);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 15, 1, 1000, 20);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 16, 1, 1000, 20);
INSERT INTO LINEITEM (LID, OID, PID, "totalprice", "NUMBER") VALUES(null, 17, 1, 100, 2);
select count(*) CUSTOMER_count from CUSTOMER;
select count(*) product_count from product;
select count(*) ORDER_count from "ORDER";
select count(*) order_item_count from LINEITEM;
