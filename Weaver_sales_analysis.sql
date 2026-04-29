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
SELECT sl.State,
 ROUND(SUM(ss.Sale_Amount), 2) AS TotalRevenue, 
	   MIN(ss.Transaction_Date) AS StartDate,
	   MAX(ss.Transaction_Date) AS EndDate
FROM store_sales ss
INNER JOIN store_locations sl
        ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Massachusetts' GROUP BY State;
-- Northeast Massachusetts total revenue for stores is $5,733,256.
-- Start date is 2022-01-01 and end date is 2025-12-31.
-- =========================================================================================================================================== --
--                       Question:2
-- 2. What is the month by month revenue breakdown for the sales territory?
----------------------------------------------------------------------------------------------------------------------------------------------
SELECT State, YEAR(SaleDate) AS YEAR, 
			  MONTH(SaleDate) AS Month, 
			  Round(SUM(Revenue), 2) AS MonthlyRevenue
FROM (SELECT sl.State, 
      ss.Transaction_Date AS SaleDate, 
      ss.Sale_Amount AS Revenue
FROM store_sales ss
INNER JOIN store_locations sl 
       ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Massachusetts') AS AllSales
GROUP BY YEAR(SaleDate), MONTH(SaleDate), State ORDER BY Year DESC, Month DESC;
-- =========================================================================================================================================== --
--                         Question:3
-- 3. Provide a comparison of total revenue for the specific sales territory and region it belongs to.
----------------------------------------------------------------------------------------------------------------------------------------------
 SELECT 'Massachusetts' AS Territory, 
 (SELECT ROUND(SUM(ss.Sale_Amount),2) FROM store_sales ss
 INNER JOIN store_locations sl ON ss.Store_ID = sl.StoreId
 WHERE sl.State = 'Massachusetts') AS TerritoryRevenue, -- Territory revenue is 5,733,256.27
 'Northeast' AS Region,
 (SELECT ROUND(SUM(ss.Sale_Amount),2) FROM store_sales ss 
 INNER JOIN store_locations sl ON ss.Store_ID = sl.StoreId
 INNER JOIN management m ON sl.State = m.State
 WHERE m.Region = 'Northeast') AS RegionRevenue; -- Region revenue is 24,237,526.98
 -- For this query I used subqueries and put in an order so it's easy to ready and understand. 
 -- ========================================================================================================================================== --
 --                          Question:4
 -- 4. What is the number of transaction per month and average transaction size by product category for the sales territory?
 ---------------------------------------------------------------------------------------------------------------------------------------------
 SELECT sl.State, COUNT(*) AS Transaction_Count, 
		ROUND(AVG(Sale_Amount), 2) AS Average_TransactionSize,
		ic.Category AS ProductCategory, 
        YEAR(ss.Transaction_Date) AS Year, MONTH(ss.Transaction_Date) AS Month
 FROM store_sales ss
INNER JOIN store_locations sl ON ss.Store_ID = sl.StoreId
INNER JOIN products p ON ss.Prod_Num = p.ProdNum
INNER JOIN inventory_categories ic ON  ic.Categoryid = p.Categoryid
WHERE sl.State = 'Massachusetts' 
    GROUP BY sl.State, ic.Category, YEAR(ss.Transaction_Date), MONTH(ss.Transaction_Date)
    ORDER BY Year DESC, Month DESC, Transaction_Count DESC, ProductCategory;
 -- ========================================================================================================================================== --
 -- 					Question: 5
 -- Can you provide a ranking of in-store sales performance by each store in the sales territory, 
 -- or a ranking of online sales performance by state within an online sales territory?
----------------------------------------------------------------------------------------------------------------------------------------------
 -- The in-store sales performance can be ranked. Here shows the top five store 
 -- ranked by total sales. From most to least. The top stores in Massachusetts is 
 -- first, store 817 in Worcester, second, store 807 in Leominster, third, store 810 in Nantucket,
 -- fourth, store 814 in Provincetown and lastly in fifth is store 812 in Northampton. 
 
 -- Using the ROUND function for easier reading of the calculated amount. The SUM function was used to calculate the of each store using
 -- an alias to label it as the TotalStoreSales. Using the INNER JOIN function to combine the table store locations to add the columns
 -- state, storeid and storelocation. These help to filter and data to make sure we are only geting the data for the correct territory, 
 -- identifying which store and for knowing where exactly each store is coming from in the territory. The WHERE function was used to 
 -- filter the state column so it goes to that territory and the GROUP BY function was used to group the data makking it more readable
 -- The ORDER BY table helps to order it by the sales while using DESC and LIMIT functions to rank the data from highest to lowest and 
 -- top five. 
 SELECT sl.StoreId, sl.State, sl.StoreLocation, ROUND(SUM(ss.Sale_Amount), 2) AS TotalStoreSales
 FROM store_sales ss
 INNER JOIN store_locations sl
        ON ss.Store_ID = sl.StoreId
WHERE sl.State = 'Massachusetts'
GROUP BY sl.StoreId, sl.State, sl.StoreLocation ORDER BY TotalStoreSales DESC LIMIT 5;
-- =========================================================================================================================================== --
 --                    Question: 6
 -- What is your recommendation for where to focus sales attention in the next quarter?
----------------------------------------------------------------------------------------------------------------------------------------------
-- From what we have found our total sales in Massachusetts is $5,733,256 as of 2025-12-31. 
-- As of this year our monthly sales increase from month one however it decrease after hinting it's peak at month 10 and continues to decrease. 
-- As of 2025-12 our top category is Technology & Accessories. Based on our top stores  I would recommend we do a deeper dive in on top selling 
-- products from the top store 817 in Worcester. Based on that we can the incorporate that into the other stores to raise sells back up.
-- Another recommendation is we can look at our sales form month 11 of 2025 which is where our monthly sales dropped and see what has changed in
-- products to make our sells drop. We can look at the amount that was being ordered of that product to find the cause. Finally we can send 
-- out surveys to get our customers opinions on that product to see if more are still interested in that product. If interests has decreased
-- then we can store up less on  that product and more on the product the customers want. 
