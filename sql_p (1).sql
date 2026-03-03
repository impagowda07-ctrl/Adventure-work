CREATE DATABASE analytics_db;
USE analytics_db;

Show tables;

#1 Total Sales And Profit
SELECT
    SUM(COALESCE(SalesAmount, 0)) AS Total_Sales,
    SUM(COALESCE(SalesAmount, 0)) 
      - SUM(COALESCE(TotalProductCost, 0)) AS Total_Profit
FROM Sales;

#2 Products that Generate the Highest Revenue AND Highest Profit?
SELECT
    p.EnglishProductName,
    SUM(COALESCE(f.SalesAmount, 0)) AS Total_Revenue,
    SUM(COALESCE(f.SalesAmount, 0))
      - SUM(COALESCE(f.TotalProductCost, 0)) AS Total_Profit
FROM Sales f
INNER JOIN DimProduct p
    ON f.ProductKey = p.ProductKey
GROUP BY p.EnglishProductName
ORDER BY Total_Revenue DESC, Total_Profit DESC
LIMIT 10;

#3  Top 10 customers by Sales
SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS Customer_Name,
    SUM(f.SalesAmount) AS Total_Sales
FROM Sales f
JOIN dimcustomer c
    ON f.CustomerKey = c.CustomerKey
GROUP BY Customer_Name
ORDER BY Total_Sales DESC
LIMIT 10;

#4 Sales by Year
SELECT 
    YEAR(OrderDate) AS Sales_Year,
    SUM(SalesAmount) AS Total_Sales
FROM Sales
GROUP BY Sales_Year
ORDER BY Sales_Year;

SET SQL_SAFE_UPDATES = 0;


#5 Sales by Product Category
SELECT 
    pc.EnglishProductCategoryName AS Product_Category,
    SUM(f.SalesAmount) AS Total_Sales
FROM Sales f
JOIN dimproduct p
    ON f.ProductKey = p.ProductKey
JOIN dimproductcategory pc
    ON p.ProductCategoryKey = pc.ProductCategoryKey
GROUP BY Product_Category
ORDER BY Total_Sales DESC;

#6 Which Sales Territories Are the Most Profitable?
SELECT 
    t.SalesTerritoryRegion,
    SUM(f.SalesAmount) AS Total_Sales,
    SUM(f.SalesAmount - f.TotalProductCost) AS Total_Profit
FROM Sales f
JOIN salesterritory t 
    ON f.SalesTerritoryKey = t.SalesTerritoryKey
GROUP BY t.SalesTerritoryRegion
ORDER BY Total_Profit DESC;

#7 Total Sales & Total Orders by Year
SELECT 
    d.CalendarYear,
    SUM(f.SalesAmount) AS Total_Sales,
    SUM(f.OrderQuantity) AS Total_Orders
FROM Sales f
JOIN dimdates d 
    ON f.OrderDateKey = d.DateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;

#8 Count Total Customers
SELECT COUNT(*) AS Total_Customers
FROM dimcustomer;

#9 Quarterwise Sales
select quarter,concat(round(sum(salesamount)/1000000,2),'M') as
sales from Sales
group by quarter
order by quarter;

#10  Top 5 Products by sales
SELECT 
    p.EnglishProductName AS Product_Name,
    SUM(f.SalesAmount) AS Total_Sales
FROM Sales f
JOIN dimproduct p 
    ON f.ProductKey = p.ProductKey
GROUP BY p.EnglishProductName
ORDER BY Total_Sales DESC
LIMIT 5;



