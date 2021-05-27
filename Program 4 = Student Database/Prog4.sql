create database student;
use student;

create table student(
snum int,
sname varchar(10),
major varchar(2),
lvl varchar(2),
age int,
primary key(snum));
desc student;

create table faculty(
fid int,
fname varchar(20),
deptid int,
primary key(fid));
desc faculty;

create table class(
cname varchar(20),
meets_at timestamp,
room varchar(10),
fid int,
primary key(cname),
foreign key(fid) references faculty(fid));
desc class;

create table enrolled(
snum int,
cname varchar(20),
primary key(snum,cname),
foreign key(snum) references student(snum),
foreign key(cname) references class(cname));
desc enrolled;

insert into student values(1,'John','CS','Sr',19);
insert into student values(2,'Smith','CS','Jr',20);
insert into student values(3,'Jacob','CV','Sr',20);
insert into student values(4,'Tom','CS','Jr',20);
insert into student values(5,'Rahul','CS','Jr',20);
insert into student values(6,'Rita','CS','Sr',21);
commit;
select * from student;

insert into faculty values(11,'Harish',1000);
insert into faculty values(12,'MV',1000);
insert into faculty values(13,'Mira',1001);
insert into faculty values(14,'Shiva',1002);
insert into faculty values(15,'Nupur',1000);
commit;
select * from faculty;

insert into class values('class1','12/11/15 10:15:16','R1',14);
insert into class values('class10','12/11/15 10:15:16','R128',14);
insert into class values('class2','12/11/15 10:15:20','R2',12);
insert into class values('class3','12/11/15 10:15:25','R3',11);
insert into class values('class4','12/11/15 20:15:20','R4',14);
insert into class values('class5','12/11/15 20:15:20','R3',15);
insert into class values('class6','12/11/15 13:20:20','R2',14);
insert into class values('class7','12/11/15 10:10:10','R3',14);
commit;
select * from class;

insert into enrolled values(1,'class1');
insert into enrolled values(2,'class1');
insert into enrolled values(3,'class3');
insert into enrolled values(4,'class3');
insert into enrolled values(5,'class4');
insert into enrolled values(1,'class5');
insert into enrolled values(2,'class5');
insert into enrolled values(3,'class5');
insert into enrolled values(4,'class5');
insert into enrolled values(5,'class5');
commit;
select * from enrolled;
select distinct S.sname from student S, class C, enrolled E, faculty F 
where S.snum = E.snum and E.cname = C.cname and C.fid = F.fid and F.fname = 'Harish' and S.lvl = 'Jr';
select C.cname from class C where C.room ='R128' 
or C.cname in (select E.cname from enrolled E group by E.cname having count(*)>=5);
select distinct S.sname from student S where S.snum in (select E1.snum from enrolled E1, enrolled E2, class C1, class C2 where E1.snum = E2.snum and E1.cname != E2.cname and E1.cname = C1.cname and E2.cname = C2.cname and C1.meets_at = C2.meets_at);
select f.fname,f.fid from faculty f where f.fid in (select fid from class
group by fid  having count(*)=(select count(distinct room) from class) );
select distinct F.fname from faculty F 
where 5 > (select count(E.snum) from class C,enrolled E where C.cname = E.cname and C.fid = F.fid);
select distinct S.sname from student S where S.snum not in (select E.snum from enrolled E);
select S.age, S.lvl from student S group by S.age,S.lvl 
having S.lvl in(select S1.lvl from student S1 where S1.age = S.age group by S1.lvl,S1.age having count(*) >= all (select count(*) from student S2 where S1.age = S2.age group by S2.lvl,S2.age));
 