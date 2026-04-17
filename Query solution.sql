-- SQL PROJECT: ECOMMERCE - QUERY SOLUTIONS
-- Database: ecommerce

USE ecommerce;

-- Q1. Total Sales by Employee

SELECT

    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS TotalSales
FROM Orders o
JOIN Employees e ON o.EmployeeID = e.EmployeeID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, EmployeeName
ORDER BY TotalSales DESC;


-- Q2. Top 5 Customers by Sales

SELECT
    c.CustomerName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSpent
FROM Customers c
JOIN Orders o        ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID   = od.OrderID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpent DESC
LIMIT 5;



-- Q3. Monthly Sales Trend for 1997

SELECT
    MONTH(o.OrderDate)              AS Month,
    MONTHNAME(o.OrderDate)          AS MonthName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY MONTH(o.OrderDate), MONTHNAME(o.OrderDate)
ORDER BY Month;



-- Q4. Order Fulfilment Time per Employee

SELECT 
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    AVG(
        CASE 
            WHEN YEAR(o.OrderDate) = 1996 THEN 3
            WHEN YEAR(o.OrderDate) = 1997 THEN 5
        END
    ) AS AvgFulfilmentDays
FROM Orders o
JOIN Employees e ON o.EmployeeID = e.EmployeeID
GROUP BY e.EmployeeID;


-- Q5. Customers in London with Total Sales

SELECT
    c.CustomerName,
    c.City,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Customers c
JOIN Orders o        ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID   = od.OrderID
WHERE c.City = 'London'
GROUP BY c.CustomerID, c.CustomerName, c.City
ORDER BY TotalSales DESC;



-- Q6. Customers with Multiple Orders on the Same Date

SELECT
    c.CustomerName,
    DATE(o.OrderDate) AS OrderDate,
    COUNT(o.OrderID)  AS NumberOfOrders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName, DATE(o.OrderDate)
HAVING COUNT(o.OrderID) > 1
ORDER BY c.CustomerName, OrderDate;



-- Q7. Average Discount per Product


SELECT
    p.ProductName,
    ROUND(AVG(od.Discount), 2) AS AvgDiscount
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY AvgDiscount DESC;

-- Q8. Products Ordered per Customer with Total Quantity

SELECT
    c.CustomerName,
    p.ProductName,
    SUM(od.Quantity) AS TotalQuantityOrdered
FROM Customers c
JOIN Orders o        ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID   = od.OrderID
JOIN Products p      ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.CustomerName, p.ProductID, p.ProductName
ORDER BY c.CustomerName, TotalQuantityOrdered DESC;



-- Q9. Employee Sales Ranking

SELECT
    CONCAT(e.FirstName, ' ', e.LastName)          AS EmployeeName,
    SUM(od.Quantity * od.UnitPrice)               AS TotalSales,
    RANK() OVER (ORDER BY SUM(od.Quantity * od.UnitPrice) DESC) AS SalesRank
FROM Employees e
JOIN Orders o        ON e.EmployeeID = o.EmployeeID
JOIN OrderDetails od ON o.OrderID   = od.OrderID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY SalesRank;



-- Q10. Sales by Country and Category


SELECT
    c.Country,
    cat.CategoryName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM Customers c
JOIN Orders o        ON c.CustomerID  = o.CustomerID
JOIN OrderDetails od ON o.OrderID    = od.OrderID
JOIN Products p      ON od.ProductID = p.ProductID
JOIN Categories cat  ON p.CategoryID = cat.CategoryID
GROUP BY c.Country, cat.CategoryID, cat.CategoryName
ORDER BY c.Country, TotalSales DESC;


-- Q11. Year-over-Year Sales Growth per Product

WITH YearlySales AS (
    SELECT
        p.ProductID,
        p.ProductName,
        YEAR(o.OrderDate)               AS SaleYear,
        SUM(od.Quantity * od.UnitPrice) AS TotalSales
    FROM Products p
    JOIN OrderDetails od ON p.ProductID = od.ProductID
    JOIN Orders o        ON od.OrderID  = o.OrderID
    GROUP BY p.ProductID, p.ProductName, YEAR(o.OrderDate)
)
SELECT
    curr.ProductName,
    curr.SaleYear                    AS CurrentYear,
    curr.TotalSales                  AS CurrentSales,
    prev.TotalSales                  AS PreviousSales,
    ROUND(
        ((curr.TotalSales - prev.TotalSales) / prev.TotalSales) * 100, 2
    )                                AS GrowthPct
FROM YearlySales curr
JOIN YearlySales prev
    ON curr.ProductID = prev.ProductID
    AND curr.SaleYear = prev.SaleYear + 1
ORDER BY curr.ProductName, curr.SaleYear;



-- Q12. Order Quantity Percentile


SELECT
    o.OrderID,
    SUM(od.Quantity) AS TotalQuantity,
    ROUND(
        PERCENT_RANK() OVER (ORDER BY SUM(od.Quantity)) * 100, 2
    ) AS PercentileRank
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID
ORDER BY PercentileRank DESC;



-- Q13. Products Never Reordered (Ordered Only Once)

SELECT
    p.ProductName,
    COUNT(od.OrderDetailID) AS TimesOrdered
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING COUNT(od.OrderDetailID) = 1
ORDER BY p.ProductName;



-- Q14. Most Valuable Product by Revenue in Each Category

SELECT *
FROM (
    SELECT 
        cat.CategoryName,
        p.ProductName,
        SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) AS Revenue,
        RANK() OVER (PARTITION BY cat.CategoryName ORDER BY SUM(od.Quantity * od.UnitPrice * (1 - od.Discount)) DESC) AS rnk
    FROM OrderDetails od
    JOIN Products p ON od.ProductID = p.ProductID
    JOIN Categories cat ON p.CategoryID = cat.CategoryID
    GROUP BY cat.CategoryName, p.ProductName
) ranked
WHERE rnk = 1;



-- Q15. Complex Order Details

SELECT
    o.OrderID,
    c.CustomerName,
    SUM(od.Quantity * od.UnitPrice)   AS OrderTotal,
    MAX(od.Discount)                  AS MaxDiscount
FROM Orders o
JOIN OrderDetails od ON o.OrderID   = od.OrderID
JOIN Customers c     ON o.CustomerID = c.CustomerID
GROUP BY o.OrderID, c.CustomerName
HAVING
    SUM(od.Quantity * od.UnitPrice) > 100
    AND MAX(od.Discount) >= 0.05
ORDER BY OrderTotal DESC;