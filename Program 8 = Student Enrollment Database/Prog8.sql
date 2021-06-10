CREATE DATABASE student_enroll;
USE student_enroll;

CREATE TABLE student(
     regno VARCHAR(15),
     name VARCHAR(20),
     major VARCHAR(20),
     bdate DATE,
     PRIMARY KEY (regno));
DESC student;
     
CREATE TABLE course(
     courseno INT,
     cname VARCHAR(20),
     dept VARCHAR(20),
     PRIMARY KEY (courseno));
DESC course;

CREATE TABLE enroll(
     regno VARCHAR(15),
     courseno INT,
     sem INT,
     marks INT,
     PRIMARY KEY (regno,courseno),
     FOREIGN KEY (regno) REFERENCES student(regno),
     FOREIGN KEY (courseno) REFERENCES course(courseno));
DESC enroll;

CREATE TABLE textbook(
     book_isbn INT,
     book_title VARCHAR(20),
     publisher VARCHAR(20),
     author VARCHAR(20),
     PRIMARY KEY (book_isbn));
DESC textbook;

CREATE TABLE book_adoption(
     courseno INT,
     sem INT,
     book_isbn INT,
     PRIMARY KEY (courseno,book_isbn),
     FOREIGN KEY (courseno) REFERENCES course (courseno),
     FOREIGN KEY (book_isbn) REFERENCES textbook(book_isbn));
DESC book_adoption;

INSERT INTO student VALUES('1BM11CS001','A','Sr','19931230');
INSERT INTO student VALUES('1BM11CS002','B','Sr','19930924');
INSERT INTO student VALUES('1BM11CS003','C','Sr','19931127');
INSERT INTO student VALUES('1BM11CS004','D','Sr','19930413');
INSERT INTO student VALUES('1BM11CS005','E','Jr','19940824');
COMMIT;
SELECT * FROM student;

INSERT INTO course VALUES(111,'OS','CSE');
INSERT INTO course VALUES(112,'EC','ECE');
INSERT INTO course VALUES(113,'SS','ISE');
INSERT INTO course VALUES(114,'DBMS','CSE');
INSERT INTO course VALUES(115,'SIGNALS','ECE');
COMMIT;
SELECT * FROM course;

INSERT INTO textbook VALUES(10,'DATABASE SYSTEMS','PEARSON','SCHIELD');
INSERT INTO textbook VALUES(900,'OPERATING SYSTEMS','PEARSON','LELAND');
INSERT INTO textbook VALUES(901,'CIRCUITS','HALL INDIA','BOB');
INSERT INTO textbook VALUES(902,'SYSTEM SOFTWARE','PETERSON','JACOB');
INSERT INTO textbook VALUES(903,'SCHEDULING','PEARSON','PATIL');
INSERT INTO textbook VALUES(904,'DATABASE SYSTEMS','PEARSON','JACOB');
INSERT INTO textbook VALUES(905,'DATABASE MANAGER','PEARSON','BOB');
INSERT INTO textbook VALUES(906,'SIGNALS','HALL INDIA','SUMIT');
COMMIT;
SELECT * FROM textbook;

INSERT INTO enroll VALUES('1BM11CS001',115,3,100);
INSERT INTO enroll VALUES('1BM11CS002',114,5,100);
INSERT INTO enroll VALUES('1BM11CS003',113,5,100);
INSERT INTO enroll VALUES('1BM11CS004',111,5,100);
INSERT INTO enroll VALUES('1BM11CS005',112,3,100);
COMMIT;
SELECT * FROM enroll;

INSERT INTO book_adoption VALUES(111,5,900);
INSERT INTO book_adoption VALUES(111,5,903);
INSERT INTO book_adoption VALUES(111,5,904);
INSERT INTO book_adoption VALUES(112,3,901);
INSERT INTO book_adoption VALUES(113,3,10);
INSERT INTO book_adoption VALUES(114,5,905);
INSERT INTO book_adoption VALUES(113,5,902);
INSERT INTO book_adoption VALUES(115,3,906);
COMMIT;
SELECT * FROM book_adoption;

INSERT INTO textbook VALUES(908,'UNIX CONCEPTS','TATA MCGRAW HILL','SUMITABHA DAS');
INSERT INTO book_adoption VALUES(113,4,908);
SELECT * FROM textbook;
SELECT * FROM book_adoption;

SELECT c.courseno,t.book_isbn,t.book_title
FROM course c,book_adoption ba,textbook t
WHERE c.courseno=ba.courseno
AND ba.book_isbn=t.book_isbn
AND c.dept='CSE'
AND 2<(SELECT COUNT(book_isbn)
FROM book_adoption b
WHERE c.courseno=b.courseno)
ORDER BY t.book_title;

SELECT DISTINCT c.dept
     FROM course c
     WHERE c.dept IN
     (SELECT c.dept
     FROM course c,book_adoption b,textbook t
     WHERE c.courseno=b.courseno
     AND t.book_isbn=b.book_isbn
     AND t.publisher='PEARSON')
     AND c.dept NOT IN
     (SELECT c.dept
     FROM course c,book_adoption b,textbook t
     WHERE c.courseno=b.courseno
     AND t.book_isbn=b.book_isbn
     AND t.publisher != 'PEARSON');