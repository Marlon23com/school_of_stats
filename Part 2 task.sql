-- -----------------------------------------------------
-- Step 1: Create a new database (optional)
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS mcdonalds;
USE mcdonalds;


-- -----------------------------------------------------
-- Step 2: Create Tables to Match CSV Files
-- -----------------------------------------------------

-- Sales Data Table
CREATE TABLE IF NOT EXISTS sales_data (
    OrderID VARCHAR(50),
    Date DATE,
    CustomerName VARCHAR(255),
    Product VARCHAR(255),
    Category VARCHAR(100),
    Quantity INT,
    UnitPrice FLOAT,
    Total FLOAT,
    Region VARCHAR(100)
);

-- Store Table
CREATE TABLE IF NOT EXISTS Store (
    StoreID VARCHAR(50),
    Country VARCHAR(50),
    Region VARCHAR(50),
    General_Mannager VARCHAR(100),
    Age INT,
    Sex VARCHAR(10),
    Tenure FLOAT
);

-- Theft Table
CREATE TABLE IF NOT EXISTS Theft (
    RecordID VARCHAR(50),
    Date DATE,
    Trans_Category VARCHAR(50),
    Amounts FLOAT,
    StoreID2 VARCHAR(50)
);


-- -----------------------------------------------------
-- Step 3: Load Data from CSV Files
-- Make sure you've imported your CSVs using LOAD DATA LOCAL INFILE
-- Replace 'C:/path/to/your/file.csv' with actual file path
-- -----------------------------------------------------

-- Load Sales Data
LOAD DATA LOCAL INFILE 'C:/path/to/week3_sales_data.csv'
INTO TABLE sales_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Load Store Data
LOAD DATA LOCAL INFILE 'C:/path/to/Store.csv'
INTO TABLE Store
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Load Theft Data
LOAD DATA LOCAL INFILE 'C:/path/to/Theft.csv'
INTO TABLE Theft
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- -----------------------------------------------------
-- Task 2.1: How much does each manager have in theft amounts?
-- -----------------------------------------------------
SELECT 
    s.General_Mannager AS ManagerName,
    SUM(t.Amounts) AS TotalTheftAmount
FROM 
    Store s
JOIN 
    Theft t ON s.StoreID = t.StoreID2
GROUP BY 
    s.General_Mannager
ORDER BY 
    TotalTheftAmount DESC;


-- -----------------------------------------------------
-- Bonus Task: Filter managers with > 10 theft amount
-- and show their age, sex, tenure, and location
-- -----------------------------------------------------
SELECT 
    s.General_Mannager AS ManagerName,
    s.Age,
    s.Sex,
    s.Tenure,
    CONCAT(s.Country, ' - ', s.Region) AS Country_Region,
    SUM(t.Amounts) AS TotalTheftAmount
FROM 
    Store s
JOIN 
    Theft t ON s.StoreID = t.StoreID2
GROUP BY 
    s.General_Mannager, s.Age, s.Sex, s.Tenure, s.Country, s.Region
HAVING 
    SUM(t.Amounts) > 10
ORDER BY 
    TotalTheftAmount DESC;


-- -----------------------------------------------------
-- Question: Which city has the highest sales by quantity?
-- Assumes CustomerName contains "Name, City"
-- -----------------------------------------------------
SELECT 
    TRIM(SUBSTRING_INDEX(CustomerName, ',', -1)) AS City,
    SUM(Quantity) AS TotalQuantitySold
FROM 
    sales_data
GROUP BY 
    TRIM(SUBSTRING_INDEX(CustomerName, ',', -1))
ORDER BY 
    TotalQuantitySold DESC
LIMIT 1;


-- -----------------------------------------------------
-- Question: List all products by quantity sold from high to low
-- -----------------------------------------------------
SELECT 
    Product,
    SUM(Quantity) AS TotalQuantitySold
FROM 
    sales_data
GROUP BY 
    Product
ORDER BY 
    TotalQuantitySold DESC;