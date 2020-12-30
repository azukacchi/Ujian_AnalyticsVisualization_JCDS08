USE retrowheels;

-- NOMOR 1 --
SELECT COUNT(DISTINCT(customerName)) AS 'Customers', COUNT(DISTINCT(city)) AS 'Cities', COUNT(DISTINCT(country)) AS 'Countries'
FROM customers;

-- NOMOR 2 --

SELECT
COUNT(DISTINCT(e.employeeNumber)) AS 'Employees',
COUNT(DISTINCT(o.officeCode)) AS 'Offices',
COUNT(DISTINCT(o.country)) AS 'Country',
COUNT(DISTINCT(t1.productCode)) AS 'Products',
SUM(t1.quantityInStock) AS 'StockProducts',
COUNT(DISTINCT(t1.productVendor)) AS 'Vendors'
FROM 
(
SELECT p.productCode, p.quantityInStock, od.orderNumber, p.productVendor
FROM products p
LEFT JOIN orderdetails od
ON od.productCode = p.productCode
GROUP BY productCode
) as t1
JOIN (
SELECT COUNT(DISTINCT(customerNumber)), orderNumber, salesRepEmployeeNumber
FROM (SELECT o.customerNumber, o.orderNumber, c.salesRepEmployeeNumber
FROM orders o
JOIN customers c
USING (customerNumber)) as t2) as t3
RIGHT JOIN employees e
ON e.employeeNumber = t3.salesRepEmployeeNumber
JOIN offices o
ON e.officeCode = o.officeCode;


-- coba nomor 2 yg pendek
SELECT 
	COUNT(DISTINCT(employeeNumber)) AS Employees, 
	COUNT(DISTINCT(officeCode)) AS Offices,
    COUNT(DISTINCT(country)) AS Country,
    (SELECT COUNT(DISTINCT(productCode)) FROM products) AS Products, 
	(SELECT SUM(quantityInStock) FROM products) AS StockProducts,
	(SELECT COUNT(DISTINCT(productVendor)) FROM products) AS Vendors
FROM employees
JOIN offices
	USING (officeCode);


-- coba nomor 2 lagi yg pendek
SELECT 
	(SELECT COUNT(DISTINCT(employeeNumber)) FROM employees) AS Employees, 
	(SELECT COUNT(DISTINCT(officeCode)) FROM employees) AS Offices,
    (SELECT COUNT(DISTINCT(country)) FROM offices) AS Country,
    (SELECT COUNT(DISTINCT(productCode)) FROM products) AS Products, 
	(SELECT SUM(quantityInStock) FROM products) AS StockProducts,
	(SELECT COUNT(DISTINCT(productVendor)) FROM products) AS Vendors;


-- NOMOR 3 --
SELECT * FROM products;
SELECT productLine, MIN(buyPrice) AS 'minPrice', MAX(buyPrice) AS 'maxPrice'
FROM products
GROUP BY productLine;

-- NOMOR 4 --
SELECT c.customerName, city, country, SUM(p.amount) AS 'total'
FROM customers c
JOIN payments p
USING (customerNumber)
GROUP BY customerName
ORDER BY total DESC
LIMIT 10;

-- NOMOR 5 --
SELECT
t1.customerName, -- ,
t2.productName,
t2.quantityOrdered,
t2.priceEach
FROM (
SELECT c.customerName, pay.paymentDate, c.customerNumber
FROM customers c
JOIN payments pay
USING (customerNumber)
WHERE paymentDate = '2003-06-05'
) as t1
JOIN orders o
USING (customerNumber)
JOIN (
SELECT od.orderNumber, od.productCode, od.quantityOrdered, od.priceEach, p.productName
FROM products p
JOIN orderdetails od
USING (productCode)
) as t2
USING (orderNumber)
WHERE paymentDate = '2003-06-05' AND orderDate <= '2003-06-05';

-- coba nomor 5 yg ben
SELECT 
	customerName, 
    productName, 
    quantityOrdered, 
    priceEach
FROM payments
JOIN customers
	USING (customerNumber)
JOIN orders
	USING (customerNumber)
JOIN orderdetails
	USING (orderNumber)
JOIN products
	USING (productCode)
WHERE paymentDate = '2003-06-05' AND orderDate <= '2003-06-05';


