CREATE DATABASE book_dealer;
USE book_dealer;

CREATE TABLE author(
      author_id INT,
      author_name VARCHAR(20),
      author_city VARCHAR(20),
      author_country VARCHAR(20),
      PRIMARY KEY(author_id));
      DESC author;

CREATE TABLE publisher(
      publisher_id INT,
      publisher_name VARCHAR(20),
      publisher_city VARCHAR(20),
      publisher_country VARCHAR(20),
      PRIMARY KEY(publisher_id));
      DESC publisher;
      
CREATE TABLE category(
      category_id INT,
      category_desc VARCHAR(30),
      PRIMARY KEY(category_id));
      DESC category;
      
CREATE TABLE catalog(
      book_id INT,
      book_title VARCHAR(30),
      author_id INT,
      publisher_id INT,
      category_id INT,
      year INT,
      price INT,
      PRIMARY KEY(book_id),
      FOREIGN KEY(author_id) REFERENCES author(author_id),
      FOREIGN KEY(publisher_id) REFERENCES publisher(publisher_id),
      FOREIGN KEY(category_id) REFERENCES category(category_id));
      DESC catalog;
      
CREATE TABLE order_details(
      order_id INT,
      book_id INT,
      quantity INT,
      PRIMARY KEY(order_id),
      FOREIGN KEY(book_id) REFERENCES catalog(book_id));
      DESC order_details;
      
INSERT INTO author VALUES(1001,'JK Rowling','London','England');
INSERT INTO author VALUES(1002,'Chetan Bhagat','Delhi','India');
INSERT INTO author VALUES(1003,'John McCarthy','Chicago','USA');
INSERT INTO author VALUES(1004,'Dan Brown','California','USA');
COMMIT;
SELECT * FROM author;

INSERT INTO publisher VALUES(2001,'Bloomsbury','London','England');
INSERT INTO publisher VALUES(2002,'Scholastic','Washington','USA');          
INSERT INTO publisher VALUES(2003,'Pearson','London','England');        
INSERT INTO publisher VALUES(2004,'Rupa','Delhi','India') ;        
COMMIT;
SELECT * FROM publisher;

INSERT INTO category VALUES(3001,'Fiction');
INSERT INTO category VALUES(3002,'Non-Fiction');
INSERT INTO category VALUES(3003,'Thriller');
INSERT INTO category VALUES(3004,'Action');
INSERT INTO category VALUES(3005,'Fiction');
COMMIT;
SELECT * FROM category;

INSERT INTO catalog VALUES(4001,'HP and Goblet Of Fire',1001,2001,3001,2002,600);
INSERT INTO catalog VALUES(4002,'HP and Order Of Phoenix',1001,2002,3001,2005,650);
INSERT INTO catalog VALUES(4003,'Two States',1002,2004,3001,2009,65);
INSERT INTO catalog VALUES(4004,'3 Mistakes of my life',1002,2004,3001,2007,55);
INSERT INTO catalog VALUES(4005,'Da Vinci Code',1004,2003,3001,2004,450);
INSERT INTO catalog VALUES(4006,'Angels and Demons',1004,2003,3001,2003,350);
INSERT INTO catalog VALUES(4007,'Artificial Intelligence',1003,2002,3002,1970,500);
COMMIT;
SELECT * FROM catalog;

INSERT INTO order_details VALUES(5001,4001,5);
INSERT INTO order_details VALUES(5002,4002,7);
INSERT INTO order_details VALUES(5003,4003,15);
INSERT INTO order_details VALUES(5004,4004,11);
INSERT INTO order_details VALUES(5005,4005,9);
INSERT INTO order_details VALUES(5006,4006,8);
INSERT INTO order_details VALUES(5007,4007,2);
INSERT INTO order_details VALUES(5008,4004,3);
COMMIT;
SELECT * FROM order_details;

SELECT * FROM author
WHERE author_id IN
(SELECT author_id FROM catalog 
WHERE year>2000 AND price>(SELECT AVG(price) FROM catalog)
GROUP BY author_id HAVING COUNT(*)>1);

SELECT a.author_name FROM author a,catalog c WHERE a.author_id=c.author_id AND book_id IN (SELECT book_id FROM order_details WHERE quantity = (SELECT MAX(quantity) FROM order_details));

SET SQL_SAFE_UPDATES = 0;
UPDATE catalog SET price=1.1*price
WHERE publisher_id IN
(SELECT publisher_id FROM publisher WHERE publisher_name='pearson');
SELECT * FROM catalog;
SET SQL_SAFE_UPDATES = 1;