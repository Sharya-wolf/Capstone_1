-- =========================================================================================================================================== --
USE sample_sales;
-------------------------------------------------------------------
-- Sha'Rya Weaver
-- 4/27/2026
-------------------------------------------------------------------
-- Manager: Bo Heap
-- Territory: Northeast, Massachusetts
SELECT SalesManager, Region, State
FROM management
WHERE SalesManager = 'Bo Heap';
-- =========================================================================================================================================== --
--                      Questions:
-- -----------------------------------------------------------------
-- 1. What is the total revenue overall for sales in the assigned territory?
-- the start and end date that tell you what period the data covers?
--------------------------------------------------------------------
--        Store_Sales
SELECT Region, State,
 ROUND(SUM(Revenue), 2) AS TotalRevenue, 
	   MIN(SaleDate) AS StartDate,
	   MAX(SaleDate) AS EndDate
FROM (SELECT m.Region, m.State,
      ss.Sale_Amount AS Revenue,
	  ss.Transaction_Date AS SaleDate
	   FROM store_sales ss
INNER JOIN management m
        ON m.id = ss.id
WHERE m.Region = 'Northeast' AND m.State = 'Massachusetts'
UNION ALL
SELECT m.Region, m.State, 
       os.SalesTotal AS Revenue,
       os.Date AS SaleDate
	FROM online_sales os
    INNER JOIN management m
        ON m.id = os.id
WHERE m.Region = 'Northeast' AND m.State = 'Massachusetts') AS CombinedSales GROUP BY Region, State;

-- Northeast Massachusetts total revenue for stores and online combined is $641.85.
-- Start and end sate is 2022-01-01.
-- =========================================================================================================================================== --

-- 2. What is the month by month revenue breakdown for the sales territory?
----------------------------------------------------------------------------------------------------------------------------------------------
SELECT Region, State, YEAR(SaleDate) AS YEAR, 
		             MONTH(SaleDate) AS Month, 
                      Round(SUM(Revenue), 2) AS MonthlyRevenue
FROM (SELECT m.Region, m.State, 
      ss.Transaction_Date AS SaleDate, 
      ss.Sale_Amount AS Revenue
FROM store_sales ss
INNER JOIN management m 
       ON m.id = ss.id
WHERE m.Region = 'Northeast' AND m.State = 'Massachusetts'
UNION ALL
SELECT m.Region, m.State, 
	  os.Date AS SaleDate, 
	  os.SalesTotal AS Revenue
FROM online_sales os 
INNER JOIN management m 
ON  m.id = os.id
WHERE Region = 'Northeast' AND State = 'Massachusetts') AS AllSales
GROUP BY Region, State, YEAR(SaleDate), MONTH(SaleDate) ORDER BY Year, Month;

SELECT SUM(os.SalesTotal), MONTH(os.Date), YEAR(os.Date), m.State, m.Region
FROM online_sales os 
INNER JOIN management m
ON os.id = m.id
 WHERE m.Region = 'Northeast' AND m.State = 'Massachusetts';
SELECT 
    YEAR(SaleDate) AS Year,
    MONTH(SaleDate) AS Month,
    ROUND(SUM(Revenue), 2) AS MonthlyTotal
FROM
(
    SELECT 
        ss.Transaction_Date AS SaleDate,
        ss.Sale_Amount AS Revenue
    FROM store_sales ss

    UNION ALL

    SELECT 
        os.Date AS SaleDate,
        os.SalesTotal AS Revenue
    FROM online_sales os
) AS AllSales
GROUP BY 
    YEAR(SaleDate),
    MONTH(SaleDate)
ORDER BY 
    Year,
    Month;
    
 SELECT 
    Region,
    State,
    YEAR(SaleDate) AS Year,
    MONTH(SaleDate) AS Month,
    ROUND(SUM(Revenue), 2) AS MonthlyTotal
FROM
(
    SELECT 
        m.Region,
        m.State,
        ss.Transaction_Date AS SaleDate,
        ss.Sale_Amount AS Revenue
    FROM store_sales ss
    INNER JOIN management m
        ON ss.id = m.id
    WHERE m.Region = 'Northeast'
      AND m.State = 'Massachusetts'

    UNION ALL

    SELECT 
        m.Region,
        m.State,
        os.Date AS SaleDate,
        os.SalesTotal AS Revenue
    FROM online_sales os
    INNER JOIN management m
        ON os.id = m.id
    WHERE m.Region = 'Northeast'
      AND m.State = 'Massachusetts'
) AS TerritorySales
GROUP BY 
    Region,
    State,
    YEAR(SaleDate),
    MONTH(SaleDate)
ORDER BY 
    Year,
    Month;   