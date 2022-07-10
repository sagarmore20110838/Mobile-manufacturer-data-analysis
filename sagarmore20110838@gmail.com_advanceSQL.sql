--SQL Advance Case Study
USE db_SQLCaseStudies

SELECT *   from DIM_MANUFACTURER
SELECT * from DIM_MODEL
SELECT * from DIM_CUSTOMER
SELECT * from DIM_LOCATION
SELECT  * from DIM_DATE
SELECT * from FACT_TRANSACTIONS

--Q1--BEGIN (List all the states in which we have customers who have bought cellphones from 2005 till today.)

SELECT DISTINCT T1.State from 
DIM_LOCATION T1 INNER JOIN 	FACT_TRANSACTIONS T2
ON T1.IDLocation = T2.IDLocation
WHERE T2.Date> '2005-01-01' ; 





--Q1--END

--Q2--BEGIN (2.	What state in the US is buying the most 'Samsung' cell phones?)
	
SELECT TOP 1 T4.State , SUM(T3.Quantity) TOTAL_QTY FROM 
DIM_MANUFACTURER T1  INNER JOIN DIM_MODEL T2
ON T1.IDManufacturer = T2.IDManufacturer INNER JOIN 
FACT_TRANSACTIONS T3 ON T2.IDModel = T3.IDModel INNER JOIN 
DIM_LOCATION T4 ON T3.IDLocation = T4.IDLocation
WHERE T4.Country = 'US' AND T1.Manufacturer_Name= 'Samsung'
GROUP BY T4.State
ORDER BY SUM(T3.Quantity) DESC; 

--ARIZONA



--Q2--END

--Q3--BEGIN(3.Show the number of transactions for each model per zip code per state.)     
	
	SELECT  T2.State , T2.ZipCode , T3.Model_Name , COUNT(T3.Model_Name) NO_TRANSACTION FROM 
	FACT_TRANSACTIONS T1 INNER JOIN DIM_LOCATION T2 
	ON T1.IDLocation = T2.IDLocation INNER JOIN DIM_MODEL T3 
	ON T1.IDModel = T3.IDModel 
	GROUP BY T2.State , T2.ZipCode , T3.Model_Name ; 




--Q3--END

--Q4--BEGIN(4.Show the cheapest cellphone (Output should contain the price also))

SELECT TOP 1 Model_Name , Unit_price
FROM DIM_MODEL
ORDER BY Unit_price ;





--Q4--END

--Q5--BEGIN(5.Find out the average price for each model in the top5 manufacturers in terms of sales quantity and order by average price.)


SELECT T1.Manufacturer_Name , T2.Model_Name , SUM(T3.Quantity)TOTAL_QTY , AVG(T3.TotalPrice) AVG_PRICE , AVG(T2.Unit_price) AVG_UNIT_PRICE  FROM 
DIM_MANUFACTURER T1 INNER JOIN DIM_MODEL T2
ON T1.IDManufacturer = T2.IDManufacturer INNER JOIN 
FACT_TRANSACTIONS T3 
ON T2.IDModel = T3.IDModel
GROUP BY T1.Manufacturer_Name , T2.Model_Name 
ORDER BY SUM(T3.Quantity) DESC , AVG(T3.TotalPrice) DESC;




--Q5--END

--Q6--BEGIN (6.List the names of the customers and the average amount spent in 2009, where the average is higher than 500)

SELECT T1.Customer_Name , AVG(T2.TotalPrice) AVG_SPEND FROM 
DIM_CUSTOMER T1 INNER JOIN  FACT_TRANSACTIONS T2
ON T1.IDCustomer = T2.IDCustomer
WHERE Date BETWEEN '2009-1-1' AND '2009-12-31' 
GROUP BY T1.Customer_Name
HAVING AVG(T2.TotalPrice) > 500 ; 
 



--Q6--END
	
--Q7--BEGIN (7.List if there is any model that was in the top 5 in terms of quantity, simultaneously in 2008, 2009 and 2010) 

SELECT Model_Name FROM 	
(SELECT TOP 5 T1.Model_Name , SUM(T2.Quantity) TOTAL_QTY , YEAR(T2.DATE) TRANS_YEAR FROM 
DIM_MODEL T1 INNER JOIN FACT_TRANSACTIONS T2 
ON T1.IDModel = T2.IDModel
GROUP BY  T1.Model_Name ,  YEAR(T2.DATE) 
HAVING  YEAR(T2.DATE) = 2008 
ORDER BY SUM(T2.Quantity) DESC ) AS D1
INTERSECT
SELECT Model_Name FROM 
(SELECT TOP 5  T1.Model_Name , SUM(T2.Quantity) TOTAL_QTY , YEAR(T2.DATE) TRANS_YEAR FROM 
DIM_MODEL T1 INNER JOIN FACT_TRANSACTIONS T2 
ON T1.IDModel = T2.IDModel
GROUP BY  T1.Model_Name ,  YEAR(T2.DATE) 
HAVING  YEAR(T2.DATE) = 2009
ORDER BY SUM(T2.Quantity) DESC) AS D2
INTERSECT 
SELECT Model_Name FROM 
(SELECT TOP 5 T1.Model_Name , SUM(T2.Quantity) TOTAL_QTY , YEAR(T2.DATE) TRANS_YEAR FROM 
DIM_MODEL T1 INNER JOIN FACT_TRANSACTIONS T2 
ON T1.IDModel = T2.IDModel
GROUP BY  T1.Model_Name ,  YEAR(T2.DATE) 
HAVING  YEAR(T2.DATE) = 2010 
ORDER BY SUM(T2.Quantity) DESC ) AS D3 


--Q7--END	
--Q8--BEGIN(8.Show the manufacturer with the 2nd top sales in the year of 2009 and the manufacturer with the 2nd top sales in the year of 2010.)
SELECT * FROM
(SELECT TOP 2  T1.Manufacturer_Name, SUM(T3.TotalPrice) TOTAL_SALES,  YEAR(T3.Date) TRANS_YEAR FROM 
DIM_MANUFACTURER T1 INNER JOIN DIM_MODEL T2 
ON T1.IDManufacturer = T2.IDManufacturer INNER JOIN 
FACT_TRANSACTIONS T3 
ON T2.IDModel = T3.IDModel
GROUP BY T1.Manufacturer_Name ,YEAR(T3.Date) 
HAVING  YEAR(T3.Date) IN (2009)
ORDER BY SUM(T3.TotalPrice) DESC ) AS D1
UNION 
SELECT * FROM 
(SELECT TOP 2  T1.Manufacturer_Name, SUM(T3.TotalPrice) TOTAL_SALES,  YEAR(T3.Date) TRANS_YEAR FROM 
DIM_MANUFACTURER T1 INNER JOIN DIM_MODEL T2 
ON T1.IDManufacturer = T2.IDManufacturer INNER JOIN 
FACT_TRANSACTIONS T3 
ON T2.IDModel = T3.IDModel
GROUP BY T1.Manufacturer_Name ,YEAR(T3.Date) 
HAVING  YEAR(T3.Date) IN (2010)
ORDER BY SUM(T3.TotalPrice) DESC ) AS D2 
 

--Q8--END
--Q9--BEGIN (9.Show the manufacturers that sold cellphones in 2010 but did not in 2009.)
SELECT T1.Manufacturer_Name  FROM 
DIM_MANUFACTURER T1 INNER JOIN DIM_MODEL T2 
ON T1.IDManufacturer = T2.IDManufacturer INNER JOIN 
FACT_TRANSACTIONS T3 
ON T2.IDModel = T3.IDModel
WHERE YEAR(T3.Date) = 2010
GROUP BY T1.Manufacturer_Name  
EXCEPT 
SELECT T1.Manufacturer_Name FROM 
DIM_MANUFACTURER T1 INNER JOIN DIM_MODEL T2 
ON T1.IDManufacturer = T2.IDManufacturer INNER JOIN 
FACT_TRANSACTIONS T3 
ON T2.IDModel = T3.IDModel
WHERE YEAR(T3.Date) = 2009  
GROUP BY T1.Manufacturer_Name ;

--Q9--END

--Q10--BEGIN (10.Find top 100 customers and their average spend, average quantity by each year.)

SELECT  TOP 100 YEAR(T2.Date) YEAR_TRANS ,T1.Customer_Name , AVG(T2.TotalPrice) AVG_SPEND ,AVG(T2.Quantity) AVG_QTY FROM 
DIM_CUSTOMER T1 INNER JOIN FACT_TRANSACTIONS T2 
ON T1.IDCustomer=T2.IDCustomer 
GROUP BY T1.Customer_Name ,YEAR(T2.Date)
ORDER BY  YEAR(T2.Date), T1.Customer_Name , AVG(T2.TotalPrice) DESC , AVG(T2.Quantity) DESC  ; 

--Q10--END
	