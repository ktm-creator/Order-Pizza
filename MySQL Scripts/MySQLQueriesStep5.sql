USE OnlinePizzeria;
/* queries 2 and 7 do not work on mySQL as there is no function to create a pivot table in MySQL */
/* The DBMSs have Some different functions such as ISNULL, GETDATE(), TOP in MS SQL while we used IFNULL, current_date and LIMIT in MySQL */
/*----------1------------*/
/*FINDING THE COUSTOMERS THAT DID NOT ORDER IN THE LAST SIX MONTH TO SEND THEM A COUPON */
SELECT * FROM
	(SELECT c.CustomerID, C.Customer_FName, C.Customer_LName, C.Email, 
	MAX(P.DeliveryDay) AS Last_Delivery_Date, COUNT(P.OrderID) AS Number_of_Orders 
	FROM Pizza_Order AS P 
	LEFT JOIN 
	Customer AS C
	ON C.CustomerID=P.CustomerID
	GROUP BY C.CustomerID, C.Customer_FName, C.Customer_LName, C.Email
	) as f
WHERE (Last_Delivery_Date<(CURRENT_DATE()-180))
;
/*-------2---------------*/
/*--COMPARING THE EMPLOYEES PREFORMANCE BY MONTH PER SPECIFIC YEAR*/
/*-----Only In 2022------*/
	SELECT o.EmployeeID, 
	MONTH(DeliveryDay) AS MonthDelivery, 
	YEAR(DeliveryDay) AS YearDeliveryDate, 
	COUNT(OrderID) AS Number_of_Orders  
	FROM Pizza_Order o
	WHERE YEAR(DeliveryDay)=2022
	GROUP BY 
	EmployeeID, MONTH(DeliveryDay), YEAR(DeliveryDay)
    ORDER BY EmployeeID IS NULL, EmployeeID, MONTH(DeliveryDay) ;

/*--With year column*/

SELECT o.EmployeeID, 
MONTH(DeliveryDay) AS MonthDelivery, 
YEAR(DeliveryDay) AS YearDeliveryDate, 
COUNT(OrderID) AS Number_of_Orders  
FROM Pizza_Order o
GROUP BY 
EmployeeID, MONTH(DeliveryDay), YEAR(DeliveryDay)
ORDER BY YearDeliveryDate, MonthDelivery, EmployeeID 
;




/*----------3------------*/
/*--PRICE AND CALORIES PER PIZZA TYPE AND PER ORDER--*/

WITH PizzaBase as (
SELECT p.PizzaTypeID, p.NumberOfItems, p.SizeID, si.SizeCaloryPercentage, si.SizePricePercentage,
p.SauceID, sa.SauceCalory, sa.SaucePrice,
p.CrustID, c.CrustCalory, c.CrustPrice,
p.CheeseID, ch.CheeseCalory, ch.CheesePrice,
p.DoughID, d.DoughCalory, d.DoughPrice,
p.OrderID,
(SaucePrice + CrustPrice + CheesePrice + DoughPrice)*SizePricePercentage AS PricePerPizzaType,
(SauceCalory + CrustCalory + CheeseCalory + DoughCalory)*SizePricePercentage AS CaloryPerPizzaType
FROM Pizza_Type p
LEFT JOIN Size si
ON p.SizeID=si.SizeID
LEFT JOIN Sauce sa
ON sa.SauceID=p.SauceID
LEFT JOIN Crust c
ON c.CrustID=p.CrustID
LEFT JOIN Cheese ch
ON ch.CheeseID=p.CheeseID
LEFT JOIN Dough d
ON d.DoughID = p.DoughID)
, CalcTopping AS (
SELECT P.PizzaTypeID, SUM(t.ToppingPrice) AS PriceTopping, SUM(t.ToppingCalory) AS CaloryTopping FROM Pizza_Type_Topping p
LEFT JOIN Topping t
ON p.ToppingID=t.ToppingID
GROUP BY P.PizzaTypeID)
, cte AS (
SELECT pb.PizzaTypeID, pb.NumberOfItems, pb.OrderID, pb.PricePerPizzaType, pb.CaloryPerPizzaType,
IFNULL(ct.PriceTopping*SizePricePercentage,0) as toppingPrice, 
IFNULL(ct.CaloryTopping*SizePricePercentage,0) as CaloriesTopping

FROM
PizzaBase pb
LEFT JOIN CalcTopping ct
ON pb.PizzaTypeID = ct.PizzaTypeID)

SELECT c.OrderID, PizzaTypeID, (c.PricePerPizzaType + c.toppingPrice) as PricePerPizzaType, 
c.NumberOfItems*(c.PricePerPizzaType + c.toppingPrice) as PricePerTotalPizzaTypeItems,
SUM(c.NumberOfItems*(c.PricePerPizzaType + c.toppingPrice)) OVER (PARTITION BY OrderID) as OrderPrice,
(c.CaloryPerPizzaType + c.CaloriesTopping) as CaloriesPizzaType, 
c.NumberOfItems*(c.CaloryPerPizzaType + c.CaloriesTopping) as CaloriesPizzaTypeItems,
SUM(c.NumberOfItems*(c.CaloryPerPizzaType + c.CaloriesTopping)) OVER(PARTITION BY OrderID) as OrderCalories
FROM 
cte c
ORDER BY OrderID
;

/*--Order total price and calories--*/
WITH PizzaBase as (
SELECT p.PizzaTypeID, p.NumberOfItems, p.SizeID, si.SizeCaloryPercentage, si.SizePricePercentage,
p.SauceID, sa.SauceCalory, sa.SaucePrice,
p.CrustID, c.CrustCalory, c.CrustPrice,
p.CheeseID, ch.CheeseCalory, ch.CheesePrice,
p.DoughID, d.DoughCalory, d.DoughPrice,
p.OrderID,
(SaucePrice + CrustPrice + CheesePrice + DoughPrice)*SizePricePercentage AS PricePerPizzaType,
(SauceCalory + CrustCalory + CheeseCalory + DoughCalory)*SizeCaloryPercentage AS CaloryPerPizzaType
FROM Pizza_Type p
LEFT JOIN Size si
ON p.SizeID=si.SizeID
LEFT JOIN Sauce sa
ON sa.SauceID=p.SauceID
LEFT JOIN Crust c
ON c.CrustID=p.CrustID
LEFT JOIN Cheese ch
ON ch.CheeseID=p.CheeseID
LEFT JOIN Dough d
ON d.DoughID = p.DoughID)
, CalcTopping AS (
SELECT P.PizzaTypeID, SUM(t.ToppingPrice) AS PriceTopping, SUM(t.ToppingCalory) AS CaloryTopping FROM Pizza_Type_Topping p
LEFT JOIN Topping t
ON p.ToppingID=t.ToppingID
GROUP BY P.PizzaTypeID)
, cte AS (
SELECT pb.PizzaTypeID, pb.NumberOfItems, pb.OrderID, pb.PricePerPizzaType, pb.CaloryPerPizzaType,
IFNULL(ct.PriceTopping*SizePricePercentage,0) as toppingPrice, 
IFNULL(ct.CaloryTopping*SizeCaloryPercentage,0) as CaloriesTopping

FROM
PizzaBase pb
LEFT JOIN CalcTopping ct
ON pb.PizzaTypeID = ct.PizzaTypeID)

SELECT c.OrderID, 
SUM(c.NumberOfItems*(c.PricePerPizzaType + c.toppingPrice)) as OrderPrice,
SUM(c.NumberOfItems*(c.CaloryPerPizzaType + c.CaloriesTopping)) as OrderCalories
FROM 
cte c
GROUP BY OrderID
ORDER BY OrderID
;


/*----------4------------*/
/*--NUMBER OF ORDERS / MAX ORDER / SUM OF ORDERS IN SPECIFIC YEAR (2022) - FOR EVALUATION THE COMPANY REVENUE--*/

WITH PizzaBase as (
SELECT p.PizzaTypeID, p.NumberOfItems, p.SizeID, si.SizeCaloryPercentage, si.SizePricePercentage,
p.SauceID, sa.SauceCalory, sa.SaucePrice,
p.CrustID, c.CrustCalory, c.CrustPrice,
p.CheeseID, ch.CheeseCalory, ch.CheesePrice,
p.DoughID, d.DoughCalory, d.DoughPrice,
p.OrderID, 
(SaucePrice + CrustPrice + CheesePrice + DoughPrice)*SizePricePercentage AS PricePerPizzaType,
(SauceCalory + CrustCalory + CheeseCalory + DoughCalory)*SizeCaloryPercentage AS CaloryPerPizzaType
FROM Pizza_Type p
LEFT JOIN Size si
ON p.SizeID=si.SizeID
LEFT JOIN Sauce sa
ON sa.SauceID=p.SauceID
LEFT JOIN Crust c
ON c.CrustID=p.CrustID
LEFT JOIN Cheese ch
ON ch.CheeseID=p.CheeseID
LEFT JOIN Dough d
ON d.DoughID = p.DoughID
)
, CalcTopping AS (
SELECT P.PizzaTypeID, SUM(t.ToppingPrice) AS PriceTopping, SUM(t.ToppingCalory) AS CaloryTopping FROM Pizza_Type_Topping p
LEFT JOIN Topping t
ON p.ToppingID=t.ToppingID
GROUP BY P.PizzaTypeID)
, cte AS (
SELECT pb.PizzaTypeID, pb.NumberOfItems, pb.OrderID, pb.PricePerPizzaType, pb.CaloryPerPizzaType,
IFNULL(ct.PriceTopping*SizePricePercentage,0) as toppingPrice, 
IFNULL(ct.CaloryTopping*SizeCaloryPercentage,0) as CaloriesTopping

FROM
PizzaBase pb
LEFT JOIN CalcTopping ct
ON pb.PizzaTypeID = ct.PizzaTypeID)


SELECT SUM(PricePerTotalPizzaOrder) as SumOrders, MAX(PricePerTotalPizzaOrder) as MaxOrder, COUNT(OrderID) as NumOrders
FROM (
SELECT c.OrderID, SUM(c.NumberOfItems*(c.PricePerPizzaType + c.toppingPrice)) as PricePerTotalPizzaOrder, p.DeliveryDay
FROM 
cte c
LEFT JOIN Pizza_Order p
ON p.OrderID = c.OrderID
WHERE YEAR(p.DeliveryDay)=2022
GROUP BY c.OrderID, DeliveryDay
)b;


/*----------5------------*/
/*--FAVORITE/LEAST FAVORITE INGREDIENTES - FOR FUTURE MENU--*/

WITH cte AS (
SELECT SauceID, SauceName, COUNT(PizzaTypeID) AS NumOfPizzaType
FROM (
SELECT s.SauceID, s.SauceName, p.PizzaTypeID FROM
Sauce s
LEFT JOIN Pizza_Type p
ON s.SauceID=p.SauceID
)s
GROUP BY SauceID, SauceName
) 
SELECT CASE WHEN NumOfPizzaType = (SELECT MAX(NumOfPizzaType) FROM cte c) THEN 'Favorite' ELSE 'Least Favorite' END as Favorite_Least_Favorite,
c.* FROM
cte c 
WHERE NumOfPizzaType = (SELECT MAX(NumOfPizzaType) FROM cte)
OR NumOfPizzaType = (SELECT MIN(NumOfPizzaType) FROM cte)
;

WITH cte AS (
SELECT CheeseID, CheeseName, COUNT(PizzaTypeID) AS NumOfPizzaType
FROM (
SELECT s.CheeseID, s.CheeseName, p.PizzaTypeID FROM
Cheese s
LEFT JOIN Pizza_Type p
ON s.CheeseID=p.CheeseID
)s
GROUP BY CheeseID, CheeseName
) 
SELECT CASE WHEN NumOfPizzaType = (SELECT MAX(NumOfPizzaType) FROM cte) THEN 'Favorite' ELSE 'Least Favorite' END as Favorite_Least_Favorite,
c.* FROM
cte c
WHERE NumOfPizzaType = (SELECT MAX(NumOfPizzaType) FROM cte)
OR NumOfPizzaType = (SELECT MIN(NumOfPizzaType) FROM cte)
;

WITH cte AS (
SELECT DoughID, DoughName, COUNT(PizzaTypeID) AS NumOfPizzaType
FROM (
SELECT s.DoughID, s.DoughName, p.PizzaTypeID FROM
Dough s
LEFT JOIN Pizza_Type p
ON s.DoughID=p.DoughID
)s
GROUP BY DoughID, DoughName
) 
SELECT CASE WHEN NumOfPizzaType = (SELECT MAX(NumOfPizzaType) FROM cte) THEN 'Favorite' ELSE 'Least Favorite' END as Favorite_Least_Favorite,
c.* FROM
cte c
WHERE NumOfPizzaType = (SELECT MAX(NumOfPizzaType) FROM cte)
OR NumOfPizzaType = (SELECT MIN(NumOfPizzaType) FROM cte)
; 

WITH cte AS (
SELECT ToppingID, ToppingName, COUNT(PizzaTypeID) AS NumOfPizzaType 
FROM (
SELECT T.ToppingID, T.ToppingName, P.PizzaTypeID FROM
Topping t
LEFT JOIN Pizza_Type_Topping p
ON P.ToppingID = T.ToppingID)N
GROUP BY ToppingID, ToppingName)
SELECT CASE WHEN NumOfPizzaType = (SELECT MAX(NumOfPizzaType) FROM cte) THEN 'Favorite' ELSE 'Least Favorite' END as Favorite_Least_Favorite,
c.* FROM
cte c
WHERE NumOfPizzaType = (SELECT MAX(NumOfPizzaType) FROM cte)
OR NumOfPizzaType = (SELECT MIN(NumOfPizzaType) FROM cte)
;


/*----------6------------*/
/*--WHAT THE GAP (IN DAYS) BETWEEN TWO ORDERS OF THE SAME CUSTOMER? WHAT THE AVERAGE NUMBER OF DAYS BETWEEN DELIVERY TO THE SAME CUSTOMER? 
--THAT INFORMATION CAN BE USED FOR PERSONALIZE DEALS--*/


WITH cte AS
(
SELECT c.CustomerID, C.Customer_FName, C.Customer_LName, C.Email, 
(P.DeliveryDay), (P.OrderID),
LEAD(DeliveryDay) OVER(PARTITION BY c.CustomerID ORDER BY DeliveryDay) as NextOrder
FROM Pizza_Order AS P 
LEFT JOIN 
Customer AS C
ON C.CustomerID=P.CustomerID
)
SELECT *, 
AVG(gap) OVER() AS AvgAllCustomers,
AVG(gap) OVER(PARTITION BY CustomerID) AS AvgPerCustomer
FROM
(
SELECT *, DATEDIFF(NextOrder,DeliveryDay) AS gap FROM
cte
WHERE NextOrder IS NOT NULL)N
ORDER BY CustomerID;


WITH cte AS
(
SELECT c.CustomerID, C.Customer_FName, C.Customer_LName, C.Email, 
(P.DeliveryDay), (P.OrderID),
LEAD(DeliveryDay) OVER(PARTITION BY c.CustomerID ORDER BY DeliveryDay) as NextOrder
FROM Pizza_Order AS P 
LEFT JOIN 
Customer AS C
ON C.CustomerID=P.CustomerID
)
SELECT DISTINCT CustomerID, 
AVG(gap) OVER() AS AvgAllCustomers,
AVG(gap) OVER(PARTITION BY CustomerID) AS AvgPerCustomer
FROM
(
SELECT *, DATEDIFF(NextOrder,DeliveryDay) AS gap FROM
cte
WHERE NextOrder IS NOT NULL)N
ORDER BY CustomerID;


/*----------7------------*/
/*--COMPANY SALES BY MONTH AND YEAR--*/

WITH PizzaBase as (
SELECT p.PizzaTypeID, p.NumberOfItems, p.SizeID, si.SizePricePercentage,
p.SauceID, sa.SaucePrice,
p.CrustID, c.CrustPrice,
p.CheeseID, ch.CheesePrice,
p.DoughID, d.DoughPrice,
p.OrderID, o.DeliveryDay,
(SaucePrice + CrustPrice + CheesePrice + DoughPrice)*SizePricePercentage AS PricePerPizzaType

FROM Pizza_Type p
LEFT JOIN Size si
ON p.SizeID=si.SizeID
LEFT JOIN Sauce sa
ON sa.SauceID=p.SauceID
LEFT JOIN Crust c
ON c.CrustID=p.CrustID
LEFT JOIN Cheese ch
ON ch.CheeseID=p.CheeseID
LEFT JOIN Dough d
ON d.DoughID = p.DoughID
LEFT JOIN Pizza_Order o
ON O.OrderID=P.OrderID)
, CalcTopping AS (
SELECT P.PizzaTypeID, SUM(t.ToppingPrice) AS PriceTopping FROM Pizza_Type_Topping p
LEFT JOIN Topping t
ON p.ToppingID=t.ToppingID
GROUP BY P.PizzaTypeID)
, cte AS (
SELECT pb.PizzaTypeID, pb.OrderID, MONTH(DeliveryDay) as MonthOrder, YEAR(DeliveryDay) AS YearOrder,
NumberOfItems*(pb.PricePerPizzaType +
IFNULL(ct.PriceTopping*SizePricePercentage,0)) as PizzaPriceWithToppings

FROM
PizzaBase pb
LEFT JOIN CalcTopping ct
ON pb.PizzaTypeID = ct.PizzaTypeID

)
SELECT YearOrder, MonthOrder,
SUM(PizzaPriceWithToppings) AS PizzaPriceWithToppings
FROM cte
GROUP BY YearOrder, MonthOrder
;



/*----------8------------*/
/*----FINDING THE TOP CUSTOMERS BY THE COMPANY PARAMETERS (NUMBER OF ORDERS, TOTAL AND AVERAGE PRICE PER CUSTOMER)--*/
WITH PizzaBase as (
SELECT p.PizzaTypeID, p.NumberOfItems, p.SizeID, si.SizePricePercentage,
p.SauceID, sa.SaucePrice,
p.CrustID, c.CrustPrice,
p.CheeseID, ch.CheesePrice,
p.DoughID, d.DoughPrice,
p.OrderID, o.CustomerID,
(SaucePrice + CrustPrice + CheesePrice + DoughPrice)*SizePricePercentage AS PricePerPizzaType

FROM Pizza_Type p
LEFT JOIN Size si
ON p.SizeID=si.SizeID
LEFT JOIN Sauce sa
ON sa.SauceID=p.SauceID
LEFT JOIN Crust c
ON c.CrustID=p.CrustID
LEFT JOIN Cheese ch
ON ch.CheeseID=p.CheeseID
LEFT JOIN Dough d
ON d.DoughID = p.DoughID
LEFT JOIN Pizza_Order o
ON O.OrderID=P.OrderID)
, CalcTopping AS (
SELECT P.PizzaTypeID, SUM(t.ToppingPrice) AS PriceTopping FROM Pizza_Type_Topping p
LEFT JOIN Topping t
ON p.ToppingID=t.ToppingID
GROUP BY P.PizzaTypeID)
, cte AS (
SELECT pb.PizzaTypeID, pb.NumberOfItems, pb.OrderID, CustomerID, pb.PricePerPizzaType,
IFNULL(ct.PriceTopping*SizePricePercentage,0) as toppingPrice

FROM
PizzaBase pb
LEFT JOIN CalcTopping ct
ON pb.PizzaTypeID = ct.PizzaTypeID)

SELECT CustomerID, MAX(rnk) as NumOfOrders, SUM(OrderPrice) as totalPriceOrdersPerCustomer, 
AVG(OrderPrice) AS AvgPriceOrdersPerCustomer
FROM (
SELECT DISTINCT c.OrderID, CustomerID, 
SUM(c.NumberOfItems*(c.PricePerPizzaType + c.toppingPrice)) OVER (PARTITION BY OrderID) as OrderPrice,
DENSE_RANK() over(PARTITION BY CustomerID ORDER BY OrderID) as rnk 
FROM 
cte c)B
GROUP BY CustomerID
ORDER BY totalPriceOrdersPerCustomer DESC
LIMIT 3
;

/*----------9------------*/
/*---DOES THERE IS A WEAK/STRONG DAY IN THE WEEK? FOR FUTURE DEALS---*/

/*--DROP VIEW OrderPanel;--*/

CREATE VIEW OrderPanel AS 

SELECT P.PizzaTypeID, NumberOfItems, 
OrderID, DeliveryDay,
(PricePerPizzaType + IFNULL(PriceTopping*SizePricePercentage,0)) AS PricePizzaTypeWithToppings
FROM (
SELECT p.PizzaTypeID, p.NumberOfItems, p.SizeID, si.SizePricePercentage,
p.SauceID, sa.SaucePrice,
p.CrustID, c.CrustPrice,
p.CheeseID, ch.CheesePrice,
p.DoughID, d.DoughPrice,
p.OrderID, o.DeliveryDay,
(SaucePrice + CrustPrice + CheesePrice + DoughPrice)*SizePricePercentage AS PricePerPizzaType

FROM Pizza_Type p
LEFT JOIN Size si
ON p.SizeID=si.SizeID
LEFT JOIN Sauce sa
ON sa.SauceID=p.SauceID
LEFT JOIN Crust c
ON c.CrustID=p.CrustID
LEFT JOIN Cheese ch
ON ch.CheeseID=p.CheeseID
LEFT JOIN Dough d
ON d.DoughID = p.DoughID
LEFT JOIN Pizza_Order o
ON O.OrderID=P.OrderID) P
LEFT JOIN (
SELECT P.PizzaTypeID, SUM(t.ToppingPrice) AS PriceTopping FROM Pizza_Type_Topping p
LEFT JOIN Topping t
ON p.ToppingID=t.ToppingID
GROUP BY P.PizzaTypeID)T ON T.PizzaTypeID = P.PizzaTypeID 
;


SELECT dayOfTheWeek, COUNT(DISTINCT OrderID) as NumOfOrders 
FROM
(
SELECT *, DAYNAME(DeliveryDay) as dayOfTheWeek 
FROM OrderPanel)N
GROUP BY dayOfTheWeek
ORDER BY NumOfOrders DESC;

/*----------10------------*/
-- WHAT IS THE BUSIEST HOUR? FOR SCHEDULING THE EMPLOYEES SHIFTS

WITH cte AS (
SELECT *, FORMAT(DeliveryTime, 'hh') as hourDelivery 
FROM Pizza_Order
) 
SELECT hourDelivery as hourDeliveryStartRange, 
CASE WHEN ((hourDelivery)!=23) THEN hourDelivery+1 ELSE 0 END as hourDeliveryEndRange, COUNT(OrderID) AS NumOfOrders 
FROM cte
GROUP BY hourDelivery;


/*----------11------------*/
/*---TO WHICH CITY MOST OF THE CUSTOMERS ORDER DELIVERY?--*/

SELECT City, YearDelivery, MonthDelivery, COUNT(OrderID) AS NumOfOrders
FROM
(
SELECT p.OrderID, YEAR(p.DeliveryDay) AS YearDelivery, MONTH(p.DeliveryDay) AS MonthDelivery, p.AddressID, c.City  
FROM
Pizza_Order p
LEFT JOIN
Customer_Address c 
ON c.AddressID=p.AddressID)N
GROUP BY City,YearDelivery, MonthDelivery
Order by YearDelivery, MonthDelivery;

SELECT City, COUNT(OrderID) AS NumOfOrders
FROM
(
SELECT p.OrderID, p.AddressID, c.City  
FROM
Pizza_Order p
LEFT JOIN
Customer_Address c 
ON c.AddressID=p.AddressID)N
GROUP BY City;


/*----------12------------*/
/*--Assuming that in 01/01/22 there was a free delivery / deal- comparing the deal day with the avg in other days*/

WITH cte AS (
SELECT op.OrderID, op.DeliveryDay, Sum(op.NumberOfItems*PricePizzaTypeWithToppings) as PriceOrder 
FROM OrderPanel op
WHERE YEAR(DeliveryDay)=2022
GROUP BY op.OrderID, op.DeliveryDay
)
,cte1 AS (
SELECT DeliveryDay, COUNT(OrderID) AS cnt, SUM(PriceOrder) AS totalPriceOrders
FROM cte
GROUP BY DeliveryDay)

SELECT 'Day without deal' AS "DAY", (CAST(SUM(cnt) as decimal(4,2) )/COUNT(DeliveryDay)) AS AvgOrdersPerDay,
SUM(totalPriceOrders)/COUNT(DeliveryDay) as totalPriceOrders
FROM cte1
WHERE DeliveryDay!= '2022-01-01'
UNION 
SELECT '2022-01-01', cnt, totalPriceOrders 
FROM cte1
WHERE DeliveryDay= '2022-01-01'

;

/*----------13------------*/
/*--DELETE EMPLOYEE WITH ID 5 FROM DB--*/

DELETE FROM Delivery_Employee WHERE EmployeeID=5;

/*--order 41 still in the DB with employeeID NULL--*/
SELECT * FROM Pizza_Order; 
SELECT * FROM Delivery_Employee;
SELECT * FROM Delivery_Employee_Area;



/*----------14------------*/
/*--UPDATE MOZZARELLA CHEESE CALORY, FROM 300 TO 320--*/

UPDATE Cheese
SET CheeseCalory = 320 
WHERE CheeseID = 1;


/*----------15------------*/
/*--THE POPULAR COMBINATION (SAUCE, CRUST, CHEESE, DOUGH)--*/

SELECT N.SauceID, SauceName, n.CrustID, CrustName, n.CheeseID, ch.CheeseName, n.DoughID, d.DoughName, CountPizzaType FROM
(SELECT SauceID, CrustID, CheeseID, DoughID, COUNT(PizzaTypeID) AS CountPizzaType 
FROM 
Pizza_Type
GROUP BY SauceID, CrustID, CheeseID, DoughID
ORDER BY CountPizzaType DESC
LIMIT 3)n
LEFT JOIN
Sauce s ON s.SauceID=n.SauceID
LEFT JOIN
Crust c ON c.CrustID=n.CrustID
LEFT JOIN
Cheese ch ON ch.CheeseID=n.CheeseID
LEFT JOIN
Dough d ON d.DoughID=n.DoughID
ORDER BY CountPizzaType;


/*----------16------------*/
/*--UPDATE CUSTOMER EMAIL--*/

UPDATE Customer
SET Email='awedlakeo@gmail.com'
WHERE CustomerID=25;


/*----------17------------*/
/*--FINDING ADDRESS OF NEW CUSTOMERS FROM LAST 45 DAYS--*/

SELECT f.*, a.HouseNumber, a.Street, a.City FROM
	(SELECT c.CustomerID, C.Customer_FName, C.Customer_LName, C.Email, 
	MIN(P.DeliveryDay) AS First_Delivery_Date, COUNT(P.OrderID) AS Number_of_Orders 
	FROM Pizza_Order AS P 
	LEFT JOIN 
	Customer AS C
	ON C.CustomerID=P.CustomerID
	GROUP BY C.CustomerID, C.Customer_FName, C.Customer_LName, C.Email
	HAVING MIN(P.DeliveryDay)>(current_date()-45)
	) as f
LEFT JOIN
Customer_Address a ON a.CustomerID=f.CustomerID
;
/*---------18-------------*/
/*USING LIKE: for example, we have an order with the Initials C.S. and we want to find the customer full name;*/

SELECT * FROM Customer c WHERE c.Customer_FName LIKE 'c%' AND c.Customer_LName LIKE 's%';

/*---------19------------*/
/* Retrieve the employees whose photo is not updated*/

SELECT * 
FROM delivery_employee AS d
where d.photo IS NULL;

/*---------20------------*/

SELECT o.EmployeeID ,a.FName,a.LName, 
	MAX(DeliveryDay) AS max_d  
	FROM Pizza_Order o
    LEFT JOIN 
    delivery_employee as a ON a.EmployeeID=o.EmployeeID
		GROUP BY 
    o.EmployeeID, a.FName,a.LName
	HAVING MAX(DeliveryDay)<(Current_Date()-30)
    ORDER BY o.EmployeeID IS NULL
    ;