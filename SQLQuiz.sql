--1
CREATE DATABASE Store

USE Store

--2
CREATE TABLE Categories (
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(255) UNIQUE
)

CREATE TABLE Products(
	Id INT PRIMARY KEY IDENTITY,
	ProductCode INT UNIQUE,
	CategoriesId INT FOREIGN KEY REFERENCES Categories(Id)
)

CREATE TABLE Stock(
	Id INT PRIMARY KEY IDENTITY,
	ProductId INT FOREIGN KEY REFERENCES Products(Id),
	CreatedDate datetime2 default GETDATE(),
	Count INT
)

CREATE TABLE Sizes(
	Id INT PRIMARY KEY IDENTITY,
	Letter NVARCHAR(10),
	Min INT,
	Max INT
)

select * from Stock
--3
ALTER TABLE Stock
ADD Size INT

--4
INSERT INTO Categories
VALUES('T-shirt'),
	('Jeans'),
	('Shoes'),
	('Jacket')

INSERT INTO Products
VALUES(12, 1),
	(13, 1),
	(25, 2),
	(26, 2),
	(33, 3),
	(32, 3),
	(48, 4),
	(49, 4)

INSERT INTO Stock
VALUES(1, '2023-04-19', 5, 34),
	(1, '2023-04-19', 6, 36),
	(2, '2023-04-19', 6, 36),
	(2, '2023-04-19', 3, 42),
	(3, '2023-04-19', 2, 40),
	(3, '2023-04-19', 4, 44),
	(4, '2023-04-19', 3, 42),
	(4, '2023-04-19', 6, 40),
	(5, '2023-04-19', 3, 32),
	(5, '2023-04-19', 5, 34),
	(6, '2023-04-19', 4, 36),
	(6, '2023-04-19', 3, 38),
	(7, '2023-04-19', 4, 44),
	(7, '2023-04-19', 7, 40),
	(8, '2023-04-19', 9, 44),
	(8, '2023-04-19', 3, 34)

INSERT INTO Sizes
VALUES('XS', 30, 32),
	('S', 33, 34),
	('M', 35, 38),
	('L', 39, 42),
	('XL', 43, 44)
	

--5
CREATE VIEW StoreInfo
AS
SELECT Products.ProductCode, Categories.Name, Stock.CreatedDate, Stock.Count, Stock.Size, Sizes.Letter FROM Categories
JOIN Products
ON Categories.Id = Products.CategoriesId
JOIN Stock
ON Stock.ProductId = Products.Id
JOIN Sizes
ON Stock.Size >= Sizes.Min AND Stock.Size <= Sizes.Max

--6 
CREATE PROCEDURE prosedStore @size NVARCHAR(10)
AS
BEGIN 
	Select * From StoreInfo
	WHERE Letter = @size
END

--7
CREATE FUNCTION functionStore (@categorie NVARCHAR(20))
RETURNS INT
BEGIN
	DECLARE @result INT
	Select @result=Count(*) From StoreInfo
	WHERE Name = @categorie
	RETURN @result
END

--8
CREATE TRIGGER triggerStore
ON Products
AFTER INSERT 
AS
BEGIN
	SELECT * Products
END

--9
SELECT * FROM Stock 
WHERE Count > (SELECT AVG(Count) FROM Stock)