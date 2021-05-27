create database flight;
use flight;

create table flights(
flno INT,
flfrom VARCHAR(20) NOT NULL,
flto VARCHAR(20) NOT NULL,
distance INT,
departs TIMESTAMP,
arrives TIMESTAMP,
price REAL,
PRIMARY KEY (flno));
desc flights;

create table aircraft(
aid INT,
aname VARCHAR(20),
cruisingrange INT, 
PRIMARY KEY (aid));
desc aircraft;

create table employees(
eid INT,
ename VARCHAR(20),
salary REAL,
PRIMARY KEY (eid));
desc employees;

create table certified(
eid INT,
aid INT,
PRIMARY KEY (eid,aid),
FOREIGN KEY (eid) REFERENCES employees(eid),
FOREIGN KEY (aid) REFERENCES aircraft(aid));
desc certified;

insert into flights values(101,'Bangalore','Delhi',2500,'2005-05-13 07:15:31','2005-05-13 17:15:31',5000);
insert into flights values(102,'Bangalore','Lucknow',3000,'2005-05-13 07:15:31','2005-05-13 11:15:31',6000);
insert into flights values(103,'Lucknow','Delhi',500,'2005-05-13 12:15:31','2005-05-13 17:15:31',3000);
insert into flights values(107,'Bangalore','Frankfurt',8000,'2005-05-13  07:15:31','2005-05-13 22:15:31',60000);
insert into flights values(104,'Bangalore','Frankfurt',8500,'2005-05-13 07:15:31','2005-05-13 23:15:31',75000);
insert into flights values(105,'Kolkata','Delhi',3400,'2005-05-13 07:15:31','2005-05-13 09:15:31',7000);
commit;
select * from flights;

insert into aircraft values(101,'747',3000);
insert into aircraft values(102,'Boeing',900);
insert into aircraft values(103,'647',800);
insert into aircraft values(104,'Dreamliner',10000);
insert into aircraft values(105,'Boeing',3500);
insert into aircraft values(106,'707',1500);
insert into aircraft values(107,'Dream',120000);
commit;
select * from aircraft;

insert into employees values(701,'A',50000);
insert into employees values(702,'B',100000);
insert into employees values(703,'C',150000);
insert into employees values(704,'D',90000);
insert into employees values(705,'E',40000);
insert into employees values(706,'F',60000);
insert into employees values(707,'G',90000);
commit;
select * from employees;

insert into certified values(701,101);
insert into certified values(701,102);
insert into certified values(701,106);
insert into certified values(701,105);
insert into certified values(702,104);
insert into certified values(703,104);
insert into certified values(704,104);
insert into certified values(702,107);
insert into certified values(703,107);
insert into certified values(704,107);
insert into certified values(702,101);
insert into certified values(703,105);
insert into certified values(704,105);
insert into certified values(705,103);
commit;
select * from certified;

SELECT DISTINCT a.aname
FROM aircraft a,certified c,employees e
WHERE a.aid=c.aid
AND c.eid=e.eid
AND NOT EXISTS
(SELECT * FROM employees e1
WHERE e1.eid=e.eid
AND e1.salary<80000);

SELECT c.eid,MAX(cruisingrange)
FROM certified c,aircraft a
WHERE c.aid=a.aid
GROUP BY c.eid
HAVING COUNT(*)>3;

SELECT DISTINCT e.ename
FROM employees e
WHERE e.salary<
(SELECT MIN(f.price)
FROM flights f
WHERE f.flfrom='Bangalore'
AND f.flto='Frankfurt');

SELECT a.aname,AVG(e.salary)
FROM aircraft a,certified c,employees e
WHERE a.aid=c.aid
AND c.eid=e.eid
AND a.cruisingrange>1000
GROUP BY a.aid,a.aname;

SELECT distinct e.ename
FROM employees e,aircraft a,certified c
WHERE e.eid=c.eid
AND c.aid=a.aid
AND a.aname='Boeing';

SELECT a.aid
FROM aircraft a
WHERE a.cruisingrange>
(SELECT MIN(f.distance)
FROM flights f
WHERE f.flfrom='Bangalore'
AND f.flto='Frankfurt');

SELECT f.departs
FROM flights f
WHERE f.flno IN ((SELECT f0.flno
FROM flights f0
WHERE f0.flfrom = 'Bangalore' AND f0.flto = 'Delhi'
AND extract(hour from f0.arrives) < 18 )
UNION
(SELECT f0.flno
 FROM flights f0, flights f1
 WHERE f0.flfrom = 'Bangalore' AND f0.flto <> 'Delhi'
 AND f0.flto = f1.flfrom AND f1.flto = 'Delhi'
 AND f1.departs > f0.arrives
 AND extract(hour from f1.arrives) < 18)
 UNION
(SELECT f0.flno
 FROM flights f0, flights f1, flights f2
 WHERE f0.flfrom = 'Bangalore'
 AND f0.flto = f1.flfrom
 AND f1.flto = f2.flfrom
 AND f2.flto = 'Delhi'
 AND f0.flto <> 'Delhi'
 AND f1.flto <> 'Delhi'
 AND f1.departs > f0.arrives
 AND f2.departs > f1.arrives
 AND extract(hour from f2.arrives) < 18));