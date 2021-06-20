---- CASE STUDY 1: -----------
-- Sellers table
CREATE TABLE sellers
(
id INTEGER PRIMARY KEY IDENTITY(1,1),
[name] VARCHAR(30) NOT NULL,
rating INTEGER NOT NULL
)

-- items table
CREATE TABLE items
(
id INTEGER PRIMARY KEY IDENTITY(1,1),
[name] VARCHAR(30) NOT NULL,
sellerId INTEGER REFERENCES sellers(id)
)

-- INSERT VALUES IN Sellers
INSERT INTO sellers 
VALUES
('seller A', 5),
('seller B', 5),
('seller C', 5),
('seller D', 3),
('seller E', 2.7)

-- INSERT VALUES IN ITEMS
INSERT INTO items
VALUES
('item A', 1),
('item B', 2),
('item C', 1),
('item D', 3),
('item E', 4),
('item F', 5),
('item G', 5)



SELECT * FROM items
SELECT * FROM sellers

/*
: Write a query that selects the item name and the name of its seller for each item that belongs to a seller with a rating greater than 4. 
The query should return the name of the item as the first column and name of the seller as the second column
*/

SELECT i.name AS ItemName, s.name AS SellerName
FROM items i
INNER JOIN sellers s
ON i.sellerId = s.id
WHERE s.rating > 4


----------CASE STUDY 2-----------------------------------------------------------

CREATE TABLE employees
(
id INTEGER NOT NULL PRIMARY KEY,
managerId INTEGER REFERENCES employees(id),
[name] VARCHAR(30) NOT NULL
)

INSERT INTO employees
VALUES
(1, NULL, 'Emp 1'),
(2, NULL, 'Emp 2'),
(3, 1, 'Emp 3'),
(4, 1, 'Emp 4'),
(5, 2, 'Emp 5'),
(6, NULL, 'Emp 6')


select * FROM employees

/*
Q: Write a query that selects only the names of employees who are not managers.
*/



SELECT emp.name FROM employees emp
WHERE emp.id NOT IN (
        SELECT DISTINCT 
		man.managerId 
		FROM employees man 
		WHERE man.managerId IS NOT NULL
)




----CASE STUDY 3----------------------------------------------------------
-- As we already have a employee table for case study 2, so i am dropping that table first

drop table if exists employees


CREATE TABLE regions(
id INTEGER PRIMARY KEY IDENTITY(1,1),
name VARCHAR(50) NOT NULL
)

INSERT INTO regions
(name)
VALUES
('region 1'),
('region 2'),
('region 3'),
('region 4'),
('region 5'),
('region 6'),
('region 7')

CREATE TABLE states(
id INTEGER PRIMARY KEY IDENTITY(1,1),
name VARCHAR(50) NOT NULL,
regionId INTEGER NOT NULL REFERENCES regions(id)
)

INSERT INTO states
(name, regionId)
VALUES
('state 1', 1),
('state 2', 1),
('state 3', 2),
('state 4', 3),
('state 5', 3),
('state 6', 5),
('state 6', 4),
('state 6', 6),
('state 6', 7)


CREATE TABLE employees(
id INTEGER PRIMARY KEY IDENTITY(1,1),
name VARCHAR(50) NOT NULL,
stateId INTEGER NOT NULL REFERENCES states(id)
)

INSERT INTO employees
(name, stateId)
VALUES
('Emp 1', 1),
('Emp 2', 1),
('Emp 3', 2),
('Emp 4', 2),
('Emp 5', 3),
('Emp 6', 4),
('Emp 7', 5),
('Emp 8', 6)


CREATE   TABLE sales(
id INTEGER PRIMARY KEY IDENTITY(1,1),
amount INTEGER NOT NULL,
employeeId INTEGER NOT NULL REFERENCES employees(id)
)

INSERT INTO sales
(amount, employeeid)
VALUES
(20000, 1),
(26000, 1),
(40000, 2),
(10000, 2),
(24000, 3),
(26400, 4),
(27600, 5),
(78600, 6),
(26800, 7),
(29800, 8)


/*
Management requires a comparative region sales analysis report. Write a query that returns:
• The region name. 
• Average sales per employee for the region (Average sales = Total sales made for the region / Number of employees in the region).
• The difference between the average sales of the region with the highest average sales, and the average sales per employee for the region (average sales to be calculated as explained above). 

Employees can have multiple sales. A region with no sales should be also returned. Use 0 for average sales per employee for such a region when calculating the 2nd and the 3rd column.
*/
select * from regions
select * from states
select * from employees
select * from sales
-- drop table sales
-- drop table employees
-- drop table states
-- drop table regions


with sales_final AS (
	select r.name as region, 
    case when sum(isnull(s.amount,0)) = 0 then 0
    else sum(isnull(s.amount,0))/count(distinct e.id) end as average


	from regions r
	left join states st on r.id = st.regionid
	left join employees e on st.id = e.stateid
	left join sales s on e.id = s.employeeid
	group by r.id, r.name)

 
 select region, average
 , (select max(average) from sales_final) - average as diff
 from sales_final

 -- FINISH