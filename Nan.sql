
--1 DDL ( Data Defination language)
create database MMA;

--Rename databae 
alter database MMA modify name=MMABook03;
alter database MMABook03 modify name= Book;

--create Table 
create table States(
 stateCode char(2) primary key,
 stateName varchar(15) not null,
)
drop database MMaBook01

select * from  Customers;
select * from Invoices
--create table Customer
create table Customers(
 customerId int primary key identity(1,1),
 customerName varchar(9) not null,
 customerAddress varchar(15) not null,
 city varchar(9) not null,
 state char(2) not null,
 constraint fk_state foreign key(state) references States(stateCode)
)
alter table Customers add customerLastName varchar(9);
select * from Customers

update Customers set customerLastName='Thy' where customerId=1;

--create table Invoices
create table Invoices(
 invoiceId int primary key identity(1,1),
 customerId int not null,
 totalProductPrice money not null,
 shipping money not null,
 totalPrice money not null,
 constraint fk_customer foreign key(customerId) references Customers(customerId)
)
select * from Invoices;

--delete column from table
ALTER TABLE Invoices DROP COLUMN totalProductPrice;

--change column name and datatype
EXEC sp_rename 'Invoices.totalProductPrice', 'totalPrice', 'COLUMN';
ALTER TABLE Invoices
ALTER COLUMN totalPrice DECIMAL(10,2) NOT NULL;

exec sp_rename 'Invoices.totalPrice','invoiceDate','column';
alter table Invoices
alter column invoiceDate datetime not null

--add one more column to table Invoices
alter table Invoices add invoiceTotal float not null
alter table Invoices add productTotalPrice float not null


--create table Product
create table Products(
 productCode varchar(4) primary key,
 productName varchar(8) not null,
 productPrice money not null,
 productQty int not null,
)
--change data type 
alter table Products 
alter column productId varchar(4);

drop table Products;

--change column name
exec sp_rename 'productId','productCode','column';


--create table InvoiceItems
create table invoiceItems(
 invoiceId int not null,
 productCode varchar(4) not null,
 productPrice money not null,
 productQty int not null,
 itemTotal money not null,
 constraint fk_invoice foreign key(invoiceId) references Invoices(invoiceId),
 constraint fk_product foreign key(productCode) references Products(productCode)
)

--insert into table State
insert into States(stateCode,stateName) values('PP','Phnom Penh')
insert into States(stateCode,stateName) values('KD','Kandal'),('KP','Kompot'),('TK','Takoe')
select * from States;

--insert into table customers
dbcc checkident('Customers',reseed,0)
insert into Customers(customerName,customerAddress,state)
values('AnNan','90KD','KD'),('leangMeng','90TK','KD');
select * from Customers;
truncate table Customers;
alter table Customers
drop column city;
--delete all data from table
delete from Customers;


--Insert data to Table Product
select * from Products;
insert into Products(productCode,productName,productPrice,productQty)
values('P003','Sting',5,1);


--Insert into Product Invoice
select * from Invoices;
INSERT INTO Invoices (customerId, invoiceDate, ProductTotal, Shipping, invoiceTotal) VALUES
(1, '2025-08-31', 20.00, 5.00, 25.00)
insert into Invoices(customerId,invoiceDate,productTotalPrice,shipping,invoiceTotal)
values(1,'2027-08-31',70.00,2.00,72.00)

select * from Products;
select * from Invoices;
--insert value into table InvoiceItem
select * from invoiceItems;
INSERT INTO InvoiceItems (invoiceId, productCode, productPrice, productQty,itemTotal) VALUES
(1, 'P003', 56.5000, 1, 56.5000)



-- DML (Data Manipulation Language)  
--1 Insert (បញ្ចូល) 
--2 Update (កែប្រែ)
--3 Delete (លុបទិន្នន័យ)
--INSERT
insert into States(stateCode,stateName) values 
('KK','Kso Kong');
select * from Customers;
insert into Customers(customerName,customerAddress,state)
values('Na','street 21','KK');

--បង្ហាញពីការបង្កើតតារាងថ្មីឈ្មោះ Beverages និងបញ្ចូលទិន្នន័យពីតារាង Products ទៅ Beverages សម្រាប់ CategoryID = 1
--it mean copy one data for stateCode of State Table insert into table Address 
--ឈ្មោះ column មិនចាំបាច់ដូចគ្នា តែត្រូវឲ្យ order និង data type ត្រូវគ្នា។
create table States(
 stateCode char(2) primary key,
 stateName varchar(15) not null,
)

create table Address(
  stateCode char(2) not null,
  stateName varchar(15) not null
)

insert into Address(stateCode,stateName)
select stateCode ,stateName from States where stateCode ='KD'

select * from Address;

--ការបង្កើតតារាងថ្មីដោយប្រើ SELECT INTO 
--នេះមានន័យថា បង្កើតតារាងថ្មីឈ្មោះ AddressTwo និងបញ្ចូលទិន្នន័យពី States ដែល CategoryID = 7។
select States.* into AddressTwo from States where stateCode='KK';
select * from AddressTwo;


--Tempory table 



--Inserting with Output


--Using Bulk Copy to insert Data
bulk insert States from 'D:\Database\State.txt'
with(
     fieldterminator='\t',
	 rowterminator='\n'
)
select * from States;
select * from Customers;

--Update
update States set stateName='Kampong Thom'
where stateCode='OO'
select * from Customers;

update States set stateCode='KT' where stateCode='OO'

update Customers set customerName='Reaksa',
customerAddress='street 6A' where customerId=5;

update States set stateName='Koh Kong' where stateCode='KK'

-- Updating from Another Tabl

select c.customerID ,c.customerName,c.state,s.stateName
from Customers c join States s on c.state=s.stateCode;
--after update already in states table value in table customer still not change and can run qury below
UPDATE Customers
SET Customers.state = States.stateName
FROM Customers
JOIN States
ON Customers.state = States.stateCode;

--updating with Top
--ពេលប្រើ TOP, SQL Server នឹងជ្រើស row ត្រូវ update តាមលំដាប់ដែលអ្នកកំណត់
--ឧទាហរណ៍ ប្រសិនបើអ្នកចង់ update 3 row ដំបូងដែលមាន customerID តិចជាងគេ, អ្នកប្រើ ORDER BY customerID
select * from Customers;
select * from States;
UPDATE TOP (2) Customers
SET customerAddress = 'pppp'
WHERE state = 'KD';


--Updating Large Value Types with UPDATE .WRITE 
select * from Customers
UPDATE Customers 
SET customerAddress .WRITE (N'd', 0, 1)
WHERE customerId = 2;--note it use only with column that have datatype varchar(max), nvarchar(max), ឬ varbinary(max) 

create table Province(
  stateCode char(2) not null,
  stateName varchar(max) not null
)

insert into Province(stateCode,stateName) values
('KK','Koh Kong')
select * from Province
update Province set
stateName .write
(N'is',0,45)
where stateCode='kk'



--Delete Date.
--លុបទិន្នន័យច្រើនជួរ
DELETE FROM Customers 
WHERE customerAddress = 'Phnom Penh';

--លុបទិន្នន័យទាំងអស់
DELETE FROM Customers;

--លុបគ្រាប់ទិន្នន័យទាំងអស់ លឿនជាង DELETE ពីព្រោះមិន log ច្រើន reset identity column ត្រឡប់ទៅតម្លៃដើម
TRUNCATE TABLE Customers;


--DQL (Data Query Language) SELECT : ស្វែងយល់/ស្វែងរកទិន្នន័យ

select * from Customers;
select * from Customers;
select customerName,customerAddress from Customers where state='KD'


--combine first name and last name with one column 
select FirstName+','+LastName as FullName from Employees;
exec sp_rename 'Customers.customerName','customerFirstName','column';
select customerLastName+' '+customerFirstName from Customers;
select fullName=customerLastName+''+customerFirstName from Customers;
--2 Method
select customerLastName+''+customerFirstName as FullName from Customers;


--បង្ហាញតែតួនាទីដែលមានតែមួយគត់ (មិនដដែល)
--បើមានបុគ្គលិក ១០នាក់ តែមានតែ ៣តួនាទីផ្សេងគ្នា → លទ្ធផលបង្ហាញតែ ៣ជួរ
select * from Customers;
select Title from Employees;
select distinct Title from Employees;
select distinct state  from Customers;

--Select with Where Clause
select CompanyName,City from Customers where City='Paris';
select * from Customers where state='KK'

--select with where with oparator
-- =>  = (Equal)
select CompanyName,City from Customers where City='Paris';
select * from Customers where customerAddress='street 6A';

--Operator <> or != (not equal)
select * from Orders where Status !='Delivered';
select * from Employees where Department <>'IT';
select * from Customers where customerFirstName!='Nan'
select * from Customers where customerAddress<>'pppp';

--Operator > and <
select * from Product where Price>100;
select * from Product where Price<100;
select * from Products;
select * from Products where productQty>1;
select * from Invoices;
select * from Invoices where invoiceTotal<72;

--Operator >= and <=
select * from Product where Price>=140;
select * from Product where Price<=130;
select * from Invoices where productTotalPrice>=70;

--Operator !< and !>
SELECT * FROM Products WHERE Price !< 50;
SELECT * FROM Orders WHERE Total !> 1000;


--Operator Like
-- Wildcard Characters សម្រាប់ LIKE %,-,[],[^]
--query to show a list of customers whose names start with "N" note it work both of small and big charecter
select CompanyName from Customers where CompanyName like 'N%';
select * from Customers;
select * from Customers where customerAddress like 'S%'
select * from Customers where customerFirstName like 'r%';

--This query will display companies whose names end in “S”: 
select CompanyName from Customers where CompanyName like '%S';
select * from Customers where customerFirstName like '%g'


--And this one will display customers who have an “z” anywhere in their names: 
SELECT CompanyName FROM dbo.Customers WHERE CompanyName LIKE '%z%' 
select * from Customers where customerFirstName like '%a%'


--ត្រូវចាប់ផ្តើមដោយអក្សរ B and ត្រូវបញ្ចប់ដោយអក្សរ P and  មាន អក្សរចំនួន 3 តួ នៅចន្លោះ (ដែលតំណាងដោយសញ្ញា _ 3 ដង)
SELECT CustomerID FROM dbo.Customers
WHERE CustomerID LIKE 'B___P';
select * from Customers where customerFirstName like 'A___n';

--ត្រូវចាប់ផ្តើមដោយពាក្យ FRAN and ត្រូវបញ្ចប់ដោយ អក្សរ R ឬ K (តែមួយតួប៉ុណ្ណោះ)
SELECT CustomerID FROM dbo.Customers WHERE CustomerID LIKE 'FRAN[RK]';


--ត្រូវចាប់ផ្តើមដោយពាក្យ FRAN and ត្រូវបញ្ចប់ដោយ អក្សរតែមួយតួ ពី A ដល់ S (A,B,C,...,R,S)
SELECT CustomerID FROM dbo.Customers WHERE CustomerID LIKE 'FRAN[A-S]'; 

--ត្រូវចាប់ផ្តើមដោយពាក្យ FRAN and ត្រូវបញ្ចប់ដោយ អក្សរតែមួយតួ ណាមួយ លើកលែងតែ R
SELECT CustomerID FROM dbo.Customers WHERE CustomerID LIKE 'FRAN[^R]'; 



--Operator Between
-- ជ្រើសបុគ្គលិកដែលមានប្រាក់ខែពី 500 ដល់ 1000
SELECT * FROM Employees WHERE Salary BETWEEN 500 AND 1000;
select LastName,FirstName ,PostalCode from Employees where PostalCode between '98103' and '98999';
select * from Orders where OrderDate between '2023-01-01' and '2023-12-31';
select * from Products;
select * from Products where productPrice between '10.00' and '12.00';
select * from Invoices;
select * from Invoices where invoiceTotal between 23 and 72;


--Operator  IS Null  and IS NOT NULL
select * from Employees where Region is null;
select * from Customers;
select * from Customers where customerLastName is null
select * from Customers where customerLastName is not null



--Multiple Condition with and , or , not 
--AND
select * from Employees where Department ='IT' and Salary>1000;
select * from Customers where state='KK' and customerAddress='90TK';
--OR
SELECT LastName, City, PostalCode FROM dbo.Employees
WHERE City = 'Seattle' OR PostalCode LIKE '9%'
select * from Customers where state='KK' or customerLastName like 'T%'

--NOT
select LastName,City from Employees;
select LastName,City from Employees where not City like 'Seattle';
select * from Customers where not customerLastName is null;


--Operator Precedence (លំដាប់អាទិភាពនៃ Operator)
--នៅពេលអ្នកប្រើ Operator ច្រើនក្នុង WHERE (NOT, AND, OR)​ SQL នឹងដំណើរការតាមលំដាប់អាទិភាព
SELECT LastName, FirstName, City
FROM dbo.Employees WHERE LastName LIKE '%s'
AND City NOT LIKE 'Seattle';


--Using the IN Operator (ប្រើ IN Operator) is use like when we use where condition or condition
SELECT CustomerID, Country
FROM dbo.Customers
WHERE Country IN ('France', 'Spain');
-- both of this method are same  just deffrent method
SELECT CustomerID, Country
FROM dbo.Customers
WHERE Country IN ('France', 'Spain');


--Using ORDER BY to Sort Data
--រៀបឈ្មោះនិងទីក្រុងនៃបុគ្គលិកតាមលំដាប់ឡើងពី A-Z នៃទីក្រុង
select lastName ,City from Employees order by City;
select * from Customers;
select * from Customers order by state;

--រៀបឈ្មោះនិងទីក្រុងនៃបុគ្គលិកតាមលំដាប់ឡើងពី Z-A នៃទីក្រុង
--noted asc # desc
select lastName ,City from Employees order by City desc;
select * from Customers order by state desc;
select * from Customers order by state,customerFirstName asc;


-- រៀបតាមប្រាក់ខែចុះពីខ្ពស់ទៅទាប បើប្រាក់ខែដូចគ្នារៀបតាមឈ្មោះត្រកូល ហើយបើឈ្មោះត្រកូលដូចគ្នាទៀត រៀបតាមឈ្មោះខ្លួន។
select FirstName,LastName ,Salary from Employees 
order by Salary desc,LastName asc;


--រៀបចំទិន្នន័យតាម ចំនួនអក្សរ នៃនាមត្រកូល (ខ្លីទៅវែង)
select LastName from Employees order by len(LastName);
select * from Customers order by len(customerFirstName);



--Aggregate Function
create table Exam(
	resultId int identity(1,1) primary key,
	studentId int not null,
	subjectName varchar(10) not null,
	score int
)
insert into Exam(studentId,subjectName,score) values 
(1, 'Math', 85),
(1, 'English', 78),
(2, 'Math', 90),
(2, 'English', 88),
(3, 'Math', 60),
(3, 'English', 70),
(4, 'Math', 95),
(4, 'English', 82);

select * from Exam;


--count tatal row 
select count(*) as tatalRow from Exam;


--Count Total Student
select count(distinct studentId) as totalStudent from Exam;


--calculate total score
select sum(score) as totalScore from Exam;

--calculate score of each student
select studentId,sum(distinct score) as totalScoreOfEachStudent from Exam group by studentId;

--calculate only school Math 
select sum(score) as totalScoreMath from Exam where subjectName='Math';


--calculate Average
select avg(score) as AverageScore from Exam;

--calculate Average of Each Student Score
select studentId,avg(score) as AverageOfEachStudent from Exam group by studentId;


--Finding Min Score
select min(score) as LowerScore from Exam;

--finding min score with column student
--it not work it using with sub Query
select studentId score,min(score) as LowerScore from Exam group by studentId order by score desc;.

--using with subquery
select studentId,subjectName ,score from Exam where score=(select min(score) from Exam);
select * from Exam;

--using with order by + Top
select top 1 studentId,subjectName,score from Exam order by score asc;

--finding Higher Score 
select Max(score) as HigherScore from Exam;

--finding who have Higher score and name of higher subject with Subquery
select studentId,subjectName,score from Exam where score=(select max(score) as higherScore from Exam)

--finding who have Higher score and name of higher subject with Top and Order by
select Top 1 studentId ,subjectName,score from Exam order by score desc;

--finding higher score of each Subject
select subjectName,max(score) as higherScore from Exam group by subjectName;

--Group By Clause គឺជាឃ្លា (clause)នៅក្នុង SQL ដែលអនុញ្ញាតឱ្យយើងធ្វើការបូកសរុបទិន្នន័យតាមក្រុម។ វាត្រូវបានប្រើជាមួយនឹងអនុគមន៍បូកសរុប (aggregate functions)
--ដូចជា COUNT, SUM, AVG, MAX, MIN។
--Counting row 
select count(*) as TotalRowOfEmployeeTable from employees;
select count(*) as TotalRowOfCustomerTable from Customers;

--counting num of employee and num of Region
select * from Employees
select count(*) as numOfEmployee ,count(Region) as numOfRegion from Employees;
select count(*) as numOfCustomer ,count(customerLastName) as numOfCustomerLastNmae from Customers;

--counting num of employee that from Seattle City
select count(City) as numOfEmpoyeeFromSeattle from Employees  where City ='Seattle';
select count(state) as numOfStateFromKokKong from 
Customers where state='KK';

--counting number of Empoyee from each City using with group by
select City, count(*) as NumOfEmployee from Employees group by City;
select state,count(*) as numOfEachState from Customers group by state;
select * from Customers;

--use Group by with Order By 
select City ,Count(*) as NumOfEmployee from Employees 
group by City order by count(*) desc, City;
select state,count(*) as numOfeachState from Customers
group by state order by state desc;


--use having with Group by
--note having only use with Group by and អាចប្រើ WHERE និង HAVING ជាមួយគ្នាក្នុង query តែមួយ
select City ,Count(*)As numOfEmployee from Employees 
group by City having count(*)>1 order by Count(*) desc;
select state,count(*) as numOfEachState from Customers group by state having count(*)>1;
select * from customers;
select state,count(*) as numOfEachstate from Customers group by state having count(*)>2;


--Top Value Query
--TOP តែងតែត្រូវបានប្រើជាមួយ ORDER BY
SELECT TOP
 City, COUNT(*) AS NumEmployees
FROM dbo.Employees
GROUP BY City
ORDER BY COUNT(*) DESC; 

--use With Ties
--WITH TIES អនុញ្ញាតឱ្យបង្ហាញគ្រប់ជួរដេកដែលមានតម្លៃស្មើគ្នានៅលំដាប់ចុងក្រោយ
--WITH TIES មានន័យថា បើមានទីក្រុងផ្សេងទៀតដែលមានចំនួនបុគ្គលិកស្មើនឹងទីក្រុងទី 3 SQL នឹងបន្ថែមជួរទាំងអស់នោះចូលក្នុងលទ្ធផលផងដែរ។
SELECT TOP 3 WITH TIES
 City, COUNT(*) AS NumEmployees
FROM dbo.Employees
GROUP BY City
ORDER BY COUNT(*) DESC; 


--Percent with ties===========================================================================
--TOP 25 PERCENT មានន័យថា៖ Query នេះជ្រើសយក 25% ជួរដេកកំពូល (top 25 percent) នៃលទ្ធផលបន្ទាប់ពី GROUP BY ហើយតម្រៀបតាមចំនួនបុគ្គលិក (COUNT(*) DESC)។
--WITH TIES មានន័យថា៖ បើមានទីក្រុងផ្សេងទៀតមានចំនួនបុគ្គលិកស្មើនឹងជួរដេកចុងក្រោយក្នុង 25% SQL នឹងបន្ថែមជួរទាំងនោះចូលផងដែរ។
SELECT TOP 25 PERCENT WITH TIES
 City, COUNT(*) AS NumEmployees
FROM dbo.Employees
GROUP BY City
ORDER BY COUNT(*) DESC; 




--============  Join  Table  ============
--មូលដ្ឋានគ្រឹះសំខាន់នៃ​ Database គឺការបែងចែកទិន្នន័យជាតារាង (Tables) ដើម្បីរក្សាទុកព័ត៌មានជាប្រភេទផ្សេងៗ។ ឧទាហរណ៍៖
--ព័ត៌មានបុគ្គលិករក្សាទុកក្នុងតារាង Employees
--ព័ត៌មានការបញ្ជាទិញរក្សាទុកក្នុងតារាង Orders
--ការបែងចែកនេះហៅថា Normalization ដែលជួយឲ្យទិន្នន័យមិនស្ទួន និងងាយស្រួលក្នុងការគ្រប់គ្រង។
--តែអ្វីដែលខ្វះគឺពេលចង់បង្ហាញព័ត៌មានជាភាពចម្រុះ ត្រូវតភ្ជាប់ (Join) តារាងច្រើន។

--============== Cross Join ===============
--Cross Join គឺជា join មួយប្រភេទដែលយក រាល់ជួរដេក (rows) ពីតារាងទី១ បង្កើតជាគូ (pair) ជាមួយ រាល់ជួរដេក ពីតារាងទី២។
--លទ្ធផលនឹងទទួលបាន Cartesian Product មានន័យថា៖
--ចំនួន row = (ចំនួន row តារាងទី១) × (ចំនួន row តារាងទី២)។
--វាមិនមាន condition ឬ ON clause ដូចជា INNER JOIN ឬ LEFT JOIN ទេ។

create table student(
	stuId int primary key identity(1,1),
	stuName varchar(10) not null
)
insert into student(stuName) values('Nan'),('reaksa'),('Ka');
select s.stuName,e.subjectName from student s cross join Exam e;

--or use where cluse instead of join
SELECT ProductName, CategoryName
FROM dbo.Products, dbo.Categories
WHERE Products.CategoryID = Categories.CategoryID;


--==============  Inner Join វានឹងភ្ជាប់ទិន្នន័យពីតារាងពីរ ដោយយកតែលេខជួរដេកដែលមានតម្លៃសមគ្នានៅក្នុង Key ដែលភ្ជាប់ ប្រសិនបើជួរដេកណាមួយមិនមានតម្លៃសមគ្នា វានឹងមិនបង្ហាញទេ
select c.customerFirstName,s.stateName from Customers c 
inner  join States s on c.state=s.stateCode;

--using with Where and order by
SELECT Products.ProductName,
       Categories.CategoryName,
       Products.UnitPrice
FROM Products INNER JOIN Categories
ON Products.CategoryID = Categories.CategoryID
WHERE UnitPrice > 50
ORDER BY ProductName;


select * from Products;
select * from Invoices;
select * from invoiceItems

--Multiple Inner Join
-- Create Customers table
-- Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CompanyName NVARCHAR(100)
);

-- Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- OrderDetails table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    UnitPrice DECIMAL(10,2),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);


-- Customers
INSERT INTO Customers (CustomerID, CompanyName) VALUES
(1, 'Hungry Owl All Night Grocers'),
(2, 'Sparrowes delicacies'),
(3, 'Blondelssdd père et fils');

-- Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(1001, 1, '1996-09-03'),
(1002, 2, '1996-09-04'),
(1003, 3, '1996-09-05'),
(1004, 1, '1996-09-04');

-- OrderDetails
INSERT INTO OrderDetails (OrderDetailID, OrderID, UnitPrice, Quantity) VALUES
(1, 1001, 30.00, 10),
(2, 1002, 40.00, 5),
(3, 1003, 50.00, 4),
(4, 1004, 20.00, 6);

-- Now run the multiple INNER JOIN query
SELECT OrderID, convert(varchar(10), OrderDate, 101) AS Date, CompanyName, LastName
FROM dbo.Orders
INNER JOIN dbo.Customers
    ON Orders.CustomerID = Customers.CustomerID
INNER JOIN Employees
    ON Orders.EmployeeID = Employees.EmployeeID
WHERE OrderDate BETWEEN '1996-09-01' AND '1996-09-10'
ORDER BY OrderDate;


--- ======= Inner Join + Aggregate function + Group by  ========
SELECT 
    Customers.CompanyName,
    SUM(OrderDetails.UnitPrice * OrderDetails.Quantity) AS TotalSold
FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
WHERE Orders.OrderDate BETWEEN '1996-09-01' AND '1996-09-10'
GROUP BY Customers.CompanyName
ORDER BY TotalSold DESC;

--================= Outer Join ======================
create table Students(
	stuId int primary key identity(1,1),
	stuName varchar(10) not null,
)
create table Score(
	scoreId char(3) primary key not null,
	stuId int,
	score int not null,
)
alter table Score add constraint fk_stuId foreign key(stuId) references Students(stuId);
ALTER TABLE Score ADD CONSTRAINT PK_Score PRIMARY KEY (scoreId);
alter table Score add constraint pk_score primary key(scoreId);
alter table Score alter column scoreId char(3) not null;
ALTER TABLE Score DROP CONSTRAINT PK_Score;
drop table Score;
insert into Students(stuName) values('Dara'),('Sopheak'),('Vanna');
insert into Score(scoreId,stuId,score) values(101,1,85),(102,2,90),(103,5,75);
--======== Left Join ===========
--LEFT OUTER JOIN នឹងបង្ហាញជួរដេកទាំងអស់ពី Table ខាងឆ្វេង (Customers), បើមាន Order សមគ្នានឹងបង្ហាញតម្លៃ, បើគ្មាន Order នឹងបង្ហាញ NULL។
select s.stuId,s.stuName,e.score from Students s left join Score e on s.stuId=e.stuId;

SELECT CompanyName, MIN(Orders.OrderDate) AS FirstOrder
FROM dbo.Customers LEFT JOIN dbo.Orders
ON Customers.CustomerID = Orders.CustomerID
GROUP BY CompanyName
ORDER BY CompanyName;
--អាចប្រើសម្រាប់ស្វែងរកអតិថិជនទាំងអស់ រួមទាំងអ្នកមិនធ្វើការបញ្ជាទិញ។
--Query បន្ថែម៖ ស្វែងរកអតិថិជនដែលមិនមាន Order ដោយប្រើ
SELECT CompanyName AS [No Orders]
FROM dbo.Customers LEFT JOIN dbo.Orders
ON Customers.CustomerID = Orders.CustomerID
WHERE Orders.OrderID IS NULL
ORDER BY CompanyName;

--=================== Right Full Join =========
select s.stuId,s.stuName,e.score from Students s right join Score e on s.stuId=e.stuId;

--=================== Full Outer Join = Right Join + Left Join ==========
select s.stuId,s.stuName,e.score from Students s full join Score e on s.stuId=e.stuId;

---=================== Self Join =======
--Self Join គឺជាវិធី JOIN តារាងតែមួយទៅលើខ្លួនឯង។ ប្រើសម្រាប់ករណីដែលទិន្នន័យជួរឈរច្រើនកំពុងត្រូវការភ្ជាប់គ្នា (ឧ. បុគ្គលិក report ទៅកាន់អ្នកគ្រប់គ្រង)។
--ក្នុងតារាង Employees មានជួរឈរ ReportTo (ID នៃអ្នកគ្រប់គ្រង) និង EmployeeID (ID នៃបុគ្គលិក)។
--Query នេះ JOIN តារាង Employees ទៅលើខ្លួនឯង ដើម្បីបង្ហាញឈ្មោះបុគ្គលិក និងឈ្មោះអ្នកគ្រប់គ្រង។
--still not run
create table Employees(
	empId int primary key identity(1,1),
	empName varchar(10) not null,
	ManegerId int,
)
insert into Employees(empName,ManegerId) values('Dara',null),('Sopheak',1),('Vanna',1),('Lina',3);
select * from Employees
select e.empName as Employee,M.empName as Maneger from Employees e
left join Employees M on e.ManegerId=M.empId;


SELECT Employees.FirstName + ' ' + Employees.LastName AS EmployeeName,
       Managers.FirstName + ' ' + Managers.LastName AS ManagerName
FROM dbo.Employees
INNER JOIN dbo.Employees AS Managers
    ON Employees.ReportTo = Managers.EmployeeID;
--លទ្ធផល៖ បង្ហាញតែបុគ្គលិកដែលមានអ្នកគ្រប់គ្រង។


--Left Join (បង្ហាញបុគ្គលិកទាំងអស់ មានអ្នកគ្រប់គ្រង ឬអត់):
SELECT Employees.FirstName + ' ' + Employees.LastName AS EmployeeName,
       Managers.FirstName + ' ' + Managers.LastName AS ManagerName
FROM dbo.Employees
LEFT JOIN dbo.Employees AS Managers
    ON Employees.ReportTo = Managers.EmployeeID;
--លទ្ធផល៖ បង្ហាញបុគ្គលិកទាំងអស់ (បើមិនមានអ្នកគ្រប់គ្រង ManagerName = NULL) ។

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    ReportTo INT
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, ReportTo) VALUES
(1, 'Nancy', 'Davolio', 2),
(2, 'Andrew', 'Fuller', NULL),
(3, 'Janet', 'Leverling', 2),
(4, 'Margaret', 'Peacock', 2),
(5, 'Steven', 'Buchanan', 2),
(6, 'Michael', 'Suyama', 5),
(7, 'Robert', 'King', 5),
(8, 'Laura', 'Callahan', 5),
(9, 'Anne', 'Dodsworth', 5);

SELECT Employees.FirstName + ' ' + Employees.LastName AS EmployeeName,
       Managers.FirstName + ' ' + Managers.LastName AS ManagerName
FROM dbo.Employees
INNER JOIN dbo.Employees AS Managers
    ON Employees.ReportTo = Managers.EmployeeID;

--and about left join
SELECT Employees.FirstName + ' ' + Employees.LastName AS EmployeeName,
       Managers.FirstName + ' ' + Managers.LastName AS ManagerName
FROM dbo.Employees
LEFT JOIN dbo.Employees AS Managers
    ON Employees.ReportTo = Managers.EmployeeID;


--===========  Join With Aggrate Function && Group by && Order By ========
--រាប់ចំនួនពិន្ទុសិស្សនីមួយៗ
SELECT S.StudentName, COUNT(E.Score) AS TotalExams
FROM Students S
LEFT JOIN ExamResults E
ON S.StudentID = E.StudentID
GROUP BY S.StudentName;

--គណនាពិន្ទុមធ្យមសិស្សនីមួយៗ
SELECT S.StudentName, AVG(E.Score) AS AverageScore
FROM Students S
LEFT JOIN ExamResults E
ON S.StudentID = E.StudentID
GROUP BY S.StudentName;

--គណនាពិន្ទុសរុបនៃសិស្សនីមួយៗ
SELECT S.StudentName, SUM(E.Score) AS TotalScore
FROM Students S
LEFT JOIN ExamResults E
ON S.StudentID = E.StudentID
GROUP BY S.StudentName;

--រកពិន្ទុ អតិផរណា និងអប្បបរមា របស់សិស្សនីមួយៗ
SELECT S.StudentName, MIN(E.Score) AS LowestScore, MAX(E.Score) AS HighestScore
FROM Students S
LEFT JOIN ExamResults E
ON S.StudentID = E.StudentID
GROUP BY S.StudentName;

--រាប់ចំនួនសិស្សដែលមានពិន្ទុ (StudentID ផ្ទាល់ខ្លួន)
SELECT COUNT(DISTINCT E.StudentID) AS TotalStudentsWithScore
FROM ExamResults E;


--សិស្សនីមួយៗ និងចំនួនពិន្ទុដែលលើស 80
SELECT S.StudentName, COUNT(E.Score) AS HighScores
FROM Students S
LEFT JOIN ExamResults E ON S.StudentID = E.StudentID
WHERE E.Score >= 80
GROUP BY S.StudentName;


--សិស្សនីមួយៗ និងពិន្ទុមធ្យម បើចុះក្រោម 85
SELECT S.StudentName, AVG(E.Score) AS AvgScore
FROM Students S
LEFT JOIN ExamResults E ON S.StudentID = E.StudentID
GROUP BY S.StudentName
HAVING AVG(E.Score) < 85;

--បង្ហាញសិស្ស និងចំនួនពិន្ទុទាំងអស់ ហើយកំណត់ថាមានឬគ្មានពិន្ទុ
SELECT S.StudentName, COUNT(E.Score) AS TotalExams,
       CASE WHEN COUNT(E.Score) = 0 THEN 'No Exam' ELSE 'Has Exam' END AS ExamStatus
FROM Students S
LEFT JOIN ExamResults E ON S.StudentID = E.StudentID
GROUP BY S.StudentName;

--បង្ហាញ Score មធ្យមរបស់សិស្ស និងបង្ហាញថាលើស ឬក្រោម 85
SELECT S.StudentName, AVG(E.Score) AS AverageScore,
       CASE WHEN AVG(E.Score) >= 85 THEN 'Good' ELSE 'Need Improvement' END AS Performance
FROM Students S
LEFT JOIN ExamResults E ON S.StudentID = E.StudentID
GROUP BY S.StudentName;


--សិស្ស និងពិន្ទុមធ្យម បង្ហាញថា "Pass/Fail" (>=80 = Pass)
SELECT S.StudentName, AVG(E.Score) AS AvgScore,
       CASE WHEN AVG(E.Score) >= 80 THEN 'Pass' ELSE 'Fail' END AS Status
FROM Students S
LEFT JOIN ExamResults E ON S.StudentID = E.StudentID
GROUP BY S.StudentName;


--Rank សិស្សតាមពិន្ទុសរុប (Ranking by SUM)
SELECT S.StudentName, SUM(E.Score) AS TotalScore,
       RANK() OVER (ORDER BY SUM(E.Score) DESC) AS RankPosition
FROM Students S
LEFT JOIN ExamResults E ON S.StudentID = E.StudentID
GROUP BY S.StudentName;



--សិស្ស និងពិន្ទុជាមធ្យម បង្ហាញថា លើស/ក្រោមលទ្ធផលទាំងសាលា
WITH Overall AS (
  SELECT AVG(Score) AS SchoolAvg FROM ExamResults
)
SELECT S.StudentName, AVG(E.Score) AS AvgScore,
       CASE WHEN AVG(E.Score) >= (SELECT SchoolAvg FROM Overall)
            THEN 'Above School Average'
            ELSE 'Below School Average' END AS CompareStatus
FROM Students S
LEFT JOIN ExamResults E ON S.StudentID = E.StudentID
GROUP BY S.StudentName;


--=========== Sub Query ==================
--Subquery (សំណួររង) គឺជា SQL Query ដែលស្ថិតនៅក្នុង Query ធំមួយទៀត។ ប្រើសម្រាប់យកលទ្ធផលពី Query រងមកប្រើក្នុង Query មេ (ដូចជា SELECT, WHERE, FROM, ...):
--Subquery ជួយអោយអាចចាប់យកទិន្នន័យពី Query មួយទៅប្រើក្នុង Query មួយទៀត។
SELECT column1, column2
FROM Table1
WHERE column1 = (SELECT columnX FROM Table2 WHERE condition);


--រកសិស្សដែលមានពិន្ទុច្រើនជាង 90
SELECT StudentName
FROM Students
WHERE StudentID IN (
    SELECT StudentID
    FROM ExamResults
    WHERE Score > 90
);

--បង្ហាញ StudentName និង Average Score របស់គាត់
SELECT S.StudentName,
       (SELECT AVG(E.Score)
        FROM ExamResults E
        WHERE E.StudentID = S.StudentID) AS AverageScore
FROM Students S;

-- រក SStudentID និង TotalScore (SUM) តាមសិស្ស
SELECT T.StudentID, T.TotalScore
FROM (
    SELECT StudentID, SUM(Score) AS TotalScore
    FROM ExamResults
    GROUP BY StudentID
) T
WHERE T.TotalScore > 150;


--បង្ហាញ StudentName និង Highest Score របស់គាត់
SELECT StudentName,
       (SELECT MAX(Score) 
        FROM ExamResults E 
        WHERE E.StudentID = S.StudentID) AS MaxScore
FROM Students S;







