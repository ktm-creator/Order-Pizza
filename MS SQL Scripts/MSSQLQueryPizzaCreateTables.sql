/* Difference between MYSQL and MS SQL SERVER- different data type for images */

/*CREATE TABLES SCRIPT*/

CREATE DATABASE OnlinePizzeria;

USE OnlinePizzeria;

CREATE TABLE Delivery_Employee(
EmployeeID INT PRIMARY KEY,
FName VARCHAR(25) NOT NULL,
LName VARCHAR(25) NOT NULL,
Photo VARBINARY(MAX)
);

CREATE TABLE Delivery_Employee_Area (
EmployeeID INT,
DeliveryArea VARCHAR(50)

PRIMARY KEY (EmployeeID, DeliveryArea),
CONSTRAINT fk_employee FOREIGN KEY (EmployeeID) REFERENCES Delivery_Employee(EmployeeID) ON DELETE CASCADE
);


CREATE TABLE Customer (
CustomerID INT PRIMARY KEY,
Customer_FName VARCHAR(25) NOT NULL,
Customer_LName VARCHAR(25) NOT NULL,
Email VARCHAR(50) NOT NULL
);

CREATE TABLE Customer_Address (
CustomerID INT NOT NULL, 
AddressID INT NOT NULL,
HouseNumber VARCHAR(25) NOT NULL,
Street VARCHAR(50) NOT NULL,  
City VARCHAR(50) NOT NULL,

PRIMARY KEY (CustomerID, AddressID),
CONSTRAINT fk_customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE
);

CREATE TABLE Dough ( 
DoughID INT PRIMARY KEY,
DoughPrice NUMERIC(4,2) NOT NULL, 
DoughName VARCHAR(50) NOT NULL UNIQUE,
DoughCalory INT NOT NULL,

CONSTRAINT price_dough_min_cnstr CHECK (DoughPrice >= 0),
CONSTRAINT calory_dough_min_cnstr CHECK (DoughCalory > 0)
);

CREATE TABLE Sauce (
SauceID INT PRIMARY KEY,
SaucePrice NUMERIC(4,2) NOT NULL, 
SauceName VARCHAR(50) NOT NULL UNIQUE,
SauceCalory INT NOT NULL,

CONSTRAINT price_sauce_min_cnstr CHECK (SaucePrice >= 0),
CONSTRAINT calory_sauce_min_cnstr CHECK (SauceCalory > 0)

);

CREATE TABLE Cheese (
CheeseID INT PRIMARY KEY,
CheesePrice NUMERIC(4,2) NOT NULL, 
CheeseName VARCHAR(50) NOT NULL UNIQUE,
CheeseCalory INT NOT NULL,

CONSTRAINT price_cheese_min_cnstr CHECK (CheesePrice >= 0),
CONSTRAINT calory_cheese_min_cnstr CHECK (CheeseCalory > 0)

);


CREATE TABLE Crust (
CrustID INT PRIMARY KEY,
CrustPrice NUMERIC(4,2) NOT NULL, 
CrustName VARCHAR(50) NOT NULL UNIQUE,
CrustCalory INT NOT NULL,

CONSTRAINT price_crust_min_cnstr CHECK (CrustPrice >= 0),
CONSTRAINT calory_crust_min_cnstr CHECK (CrustCalory > 0)

);

CREATE TABLE Topping (
ToppingID INT PRIMARY KEY,
ToppingPrice NUMERIC(4,2) NOT NULL, 
ToppingName VARCHAR(50) NOT NULL UNIQUE,
ToppingCalory INT NOT NULL,

CONSTRAINT price_topping_min_cnstr CHECK (ToppingPrice >= 0),
CONSTRAINT calory_topping_min_cnstr CHECK (ToppingCalory > 0)

);


CREATE TABLE Size (
SizeID INT PRIMARY KEY,
SizePricePercentage NUMERIC(3,2) NOT NULL, 
SizeName VARCHAR(25) NOT NULL UNIQUE,
SizeCaloryPercentage NUMERIC(3,2) NOT NULL,

CONSTRAINT price_percentage_min_cnstr CHECK (SizePricePercentage >= 1),
CONSTRAINT calory_percentage_min_cnstr CHECK (SizeCaloryPercentage > 0)

);

CREATE TABLE Pizza_Order (
OrderID INT PRIMARY KEY, 
DeliveryTime TIME NOT NULL, 
DeliveryDay DATE NOT NULL,
CustomerID INT NOT NULL,
AddressID INT NOT NULL,
EmployeeID INT,

CONSTRAINT fk_address FOREIGN KEY (CustomerID, AddressID) REFERENCES Customer_Address(CustomerID, AddressID),
CONSTRAINT fk_employee_pizza_order FOREIGN KEY (EmployeeID) REFERENCES Delivery_Employee(EmployeeID) ON DELETE SET NULL

);


CREATE TABLE Pizza_Type (
PizzaTypeID INT PRIMARY KEY, 
Instruction VARCHAR(150) NULL, 
NumberOfItems INT,
SizeID INT, 
SauceID INT, 
CrustID INT, 
CheeseID INT, 
DoughID INT, 
OrderID INT,

CONSTRAINT number_of_items_min_cnstr CHECK (NumberOfItems > 0),
CONSTRAINT fk_size FOREIGN KEY (SizeID) REFERENCES Size(SizeID), 
CONSTRAINT fk_sauce FOREIGN KEY (SauceID) REFERENCES Sauce(SauceID) ON DELETE SET NULL, 
CONSTRAINT fk_crust FOREIGN KEY (CrustID) REFERENCES Crust(CrustID) ON DELETE SET NULL, 
CONSTRAINT fk_cheese FOREIGN KEY (CheeseID) REFERENCES Cheese(CheeseID) ON DELETE SET NULL, 
CONSTRAINT fk_dough FOREIGN KEY (DoughID) REFERENCES Dough(DoughID) ON DELETE SET NULL, 
CONSTRAINT fk_order FOREIGN KEY (OrderID) REFERENCES Pizza_Order(OrderID) ON DELETE CASCADE

);

CREATE TABLE Pizza_Type_Topping(
PizzaTypeID INT, 
ToppingID INT,

PRIMARY KEY (PizzaTypeID, ToppingID),
CONSTRAINT fk_pizza_type FOREIGN KEY (PizzaTypeID) REFERENCES Pizza_Type(PizzaTypeID) ON DELETE CASCADE,
CONSTRAINT fk_topping FOREIGN KEY (ToppingID) REFERENCES Topping(ToppingID) ON DELETE CASCADE

);


