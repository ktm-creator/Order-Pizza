/*INSERT DATA */

USE OnlinePizzeria;

/*-----Table Size-----*/
INSERT INTO Size
VALUES
(1,1,'Small',1),
(2,1.3,'Medium',1.5),
(3,1.5,'Large',1.75);
/*Select * from Size;*/


/*-----Table Crust------*/
INSERT INTO Crust
VALUES 
(1,5,'Regular',360),
(2,5,'Thin Crust',300),
(3,5.5,'Cheese Crust',400),
(4,5.5,'Thick Crust',380);
/*Select * from Crust;*/


/*-----Table Dough------*/
INSERT INTO Dough
VALUES
(1,5,'Regular',720),
(2,5,'Thin',480),
(3,5.5,'Whole grain',600),
(4,5.5,'Whole grain thin',420),
(5,10,'Keto',480);
/*Select * from Dough;*/

/*-----Table Topping------*/
INSERT INTO Topping
VALUES
(1,1.5,'Olive',90),
(2,1.5,'Mushrooms',50),
(3,2,'Arugala',20),
(4,3.5,'Extra Cheese',150),
(5,3.5,'Pepperoni',150);
/*Select * from Topping*/

/*-----Table Sauce------*/
INSERT INTO Sauce
VALUES
(2,1,'Tomato',60),
(3,2,'Garlic',360),
(4,2,'Pesto',210),
(5,2,'Chili',150);
/*Select * From sauce*/

/*-----Table Cheese-----*/
INSERT INTO Cheese
VALUES
(1,0,'Mozzarella',300),
(2,1,'Dairy Free',300),
(3,1,'Six Cheese Base',360);
/*Select * From Cheese*/

/*-----Table Customer------*/
INSERT INTO Customer
VALUES
(1,'Jason','Alyokhin','jalyokhin0@blogspot.com'),
(2,'Marjy','McInnerny','mmcinnerny1@reddit.com'),
(3,'Roy','Raith','rraith2@skype.com'),
(4,'Sam','Lack','slack3@utexas.edu'),
(5,'Adi','Murkin','amurkin4@hud.gov'),
(6,'La verne','Bache','lbache5@gizmodo.com'),
(7,'Clair','Solly','csolly6@yandex.ru'),
(8,'Obidiah','Mathew','omathew7@europa.eu'),
(9,'Dorey','Ower','dower8@canalblog.com'),
(10,'Calley','Boswood','cboswood9@newyorker.com'),
(11,'Obidiah','Abethell','oabethella@ftc.gov'),
(12,'Amandy','Bonnin','abonninb@amazonaws.com'),
(13,'Thorny','Vieyra','tvieyrac@wufoo.com'),
(14,'Guinevere','Lieb','gliebd@lycos.com'),
(15,'Filip','Merrigan','fmerrigane@nature.com'),
(16,'Carrol','Milmore','cmilmoref@lulu.com'),
(17,'Erskine','Syne','esyneg@google.cn'),
(18,'Godwin','Smyth','gsmythh@joomla.org'),
(19,'Halsy','Hast','hhasti@weibo.com'),
(20,'Bianca','MacGiolla','bmacgiollaj@instagram.com'),
(21,'Danette','Rykert','drykertk@t-online.de'),
(22,'Thomasina','Rubie','trubiel@theglobeandmail.com'),
(23,'Way','Headan','wheadanm@newyorker.com'),
(24,'Poppy','Godwin','pgodwinn@yahoo.com'),
(25,'Asa','Wedlake','awedlakeo@hhs.gov');
/*select * from Customer */

/*-----Table Customer address------*/
INSERT INTO Customer_address
VALUES
(1,1,'5','Redwing Circle','Coquitlam'),
(1,2,'50123','Oak Valley Trail','Coquitlam'),
(2,3,'50123','Oak Valley Trail','Coquitlam'),
(3,4,'33888','Garrison Point','Port Coquitlam'),
(4,5,'751','Chinook Trail','Port Coquitlam'),
(5,6,'3','Continental Point','Coquitlam'),
(6,7,'4903','Surrey Drive','Coquitlam'),
(7,8,'82','Oxford Alley','Port Moody'),
(8,9,'434','Oxford Street','Port Moody'),
(9,10,'5','Granby Hill','Port Moody'),
(10,11,'86','Hayes Lane','Coquitlam'),
(11,12,'555','Barnet Hwy','Coquitlam'),
(12,13,'1209','Lincoln','Coquitlam'),
(13,14,'33888','Schoolhouse Street','Port Coquitlam'),
(14,15,'751','Texada Street','Coquitlam'),
(15,16,'3','Barnet Hwy','Coquitlam'),
(16,17,'4903','Barnet Hwy','Coquitlam'),
(17,18,'82','Lincoln','Port Coquitlam'),
(18,19,'434','Schoolhouse Street','Port Coquitlam'),
(19,20,'5','Lincoln','Port Coquitlam'),
(20,21,'86','Ioco','Port Moody'),
(21,22,'555','Newport Dr.','Port Moody'),
(22,23,'122','Ioco','Port Moody'),
(23,24,'34','Barnet Hwy','Port Coquitlam'),
(24,25,'6668','Schoolhouse Street','Port Coquitlam');

/*select * from customer_address*/

/*-----Table Delivery_Employee------*/
INSERT INTO Delivery_Employee
VALUES 
(1, 'Carlen','Bristowe', NULL),
(4, 'Mathias','Nassy', null),
(3,'King','Shillitto',NULL),
(5, 'John','Smith',NULL);

 INSERT INTO Delivery_Employee
SELECT 2,'Arvie', 'Beetham', 
	LOAD_FILE('E:\DataBase\employee1.jpg');

/*select * from Delivery_Employee;*/

/*-----Table Delivery_Employee_Area------*/
INSERT INTO Delivery_Employee_Area
VALUES
(1, 'Coquitlam - Downtown'),
(1, 'Coquitlam - North'),
(2, 'Coquitlam - Central'),
(2, 'Coquitlam - West'),
(3, 'Port Coquitlam'),
(4, 'Coquitlam - South'),
(4, 'Port Moody'),
(5, 'Port Coquitlam');

/*Select * from Delivery_Employee_area;*/

/*-----Table Pizza_Order------*/
INSERT INTO Pizza_Order
VALUES
(1,'1:24','2021-04-10',1,1,1),
(2,'17:10','2021-05-22',1,1,1),
(3,'19:35','2021-03-18',3,4,3),
(4,'20:58','2021-06-06',9,10,4),
(5,'16:47','2021-09-01',7,8,4),
(6,'9:06','2021-10-23',6,7,2),
(7,'19:00','2022-01-01',1,1,1),
(8,'18:00','2022-01-01',1,1,1),
(9,'18:30','2022-01-01',3,4,3),
(10,'18:00','2022-01-01',9,10,4),
(11,'18:00','2022-01-01',7,8,4),
(12,'19:00','2022-01-01',6,7,2),
(13,'19:00','2022-01-01',10,11,1),
(14,'18:00','2022-01-01',2,3,4),
(15,'18:30','2022-01-01',7,8,3),
(16,'18:00','2022-01-01',6,7,2),
(17,'18:00','2022-01-12',11,12,4),
(18,'19:00','2022-01-12',1,1,1),
(19,'20:00','2022-01-12',3,4,3),
(20,'20:00','2022-01-12',13,14,4),
(21,'20:00','2022-01-12',2,3,4),
(22,'20:00','2022-01-12',17,18,2),
(23,'19:00','2022-02-01',10,11,1),
(24,'18:00','2022-02-01',2,3,4),
(25,'18:30','2022-02-01',7,8,3),
(26,'18:00','2022-02-01',6,7,2),
(27,'18:00','2022-02-01',11,12,4),
(28,'19:00','2022-02-02',1,1,1),
(29,'19:00','2022-02-02',3,4,3),
(30,'19:00','2022-02-02',9,10,4),
(31,'19:00','2022-02-02',7,8,4),
(32,'19:00','2022-02-02',13,14,4),
(33,'19:00','2022-02-02',2,3,4),
(34,'18:00','2022-02-03',14,15,2),
(35,'18:00','2022-02-03',15,16,1),
(36,'18:00','2022-02-03',16,17,3),
(37,'18:00','2022-03-03',17,18,1),
(38,'18:00','2022-03-03',3,4,3),
(39,'18:00','2022-03-03',9,10,4),
(40,'19:00','2021-03-03',18,19,4),
(41,'00:15','2022-03-04',19,20,5);
Select * from Pizza_Order;

/*-----Table Pizza_Type------*/
INSERT INTO Pizza_Type
VALUES
(1,'Well Done',1,2,1,1,2,1,2),
(2,'Regular',2,3,1,1,3,1,1),
(3,null,3,2,3,3,2,2,3),
(4,'Well Done',1,2,1,1,2,1,1),
(5,null,2,3,1,1,3,1,1),
(6,null,3,2,3,3,2,2,1),
(7,'Regular',1,4,1,1,1,3,2),
(8,'Regular',1,5,2,2,2,4,1),
(9,null,2,2,3,3,3,5,3),
(10,'Regular',3,3,4,1,4,6,2),
(11,'Regular',1,2,1,1,5,6,2),
(12,null,2,4,1,1,1,7,3),
(13,'Regular',2,2,2,2,1,8,1),
(14,'Regular',3,2,3,3,1,9,1),
(15,null,2,2,4,3,2,10,5),
(16,'Regular',2,2,2,1,4,10,4),
(17,'Regular',2,4,1,2,1,11,2),
(18,null,2,4,1,3,2,11,3),
(19,'Regular',2,2,1,1,3,11,3),
(20,'Regular',2,2,1,1,3,12,2),
(21,'Well Done',1,2,1,1,2,13,2),
(22,'Regular',2,3,1,1,3,14,2),
(23,null,3,2,3,3,2,15,2),
(24,'Regular',1,4,1,1,1,16,2),
(25,'Regular',1,5,2,2,2,17,2),
(26,'Well Done',1,2,1,1,2,18,2),
(27,'Regular',2,3,1,1,3,19,1),
(28,null,3,2,3,3,2,20,3),
(29,'Regular',1,4,1,1,1,21,1),
(30,'Regular',1,5,2,2,2,22,1),
(31,'Regular',1,4,1,1,1,23,1),
(32,'Regular',1,5,2,2,2,24,3),
(33,'Well Done',1,2,1,1,2,25,1),
(34,'Regular',2,3,1,1,3,26,1),
(35,'Regular',3,2,3,3,2,27,1),
(36,'Regular',1,4,1,1,1,28,5),
(37,'Regular',1,5,2,2,2,29,1),
(38,'Regular',1,2,1,1,2,30,1),
(39,'Regular',2,3,1,1,3,31,1),
(40,'Regular',3,2,3,3,2,32,1),
(41,'Regular',1,4,1,1,1,33,1),
(42,'Well Done',1,2,1,1,2,34,2),
(43,'Regular',2,3,1,1,3,35,2),
(44,'Regular',3,2,3,3,2,36,2),
(45,'Regular',1,4,1,1,1,37,2),
(46,'Regular',1,5,2,2,2,38,2),
(47,'Regular',1,2,1,1,2,39,2),
(48,'Regular',2,3,1,1,3,40,2),
(49,'Regular',2,3,1,1,3,41,1);

/*select * from pizza_type;*/

/*-----Table Pizza_Type_Topping------*/
INSERT INTO Pizza_Type_Topping
VALUES
(1,1), 
(1,4),
(2,3),
(3,1),
(6,2),
(6,4),
(7,1), 
(7,4),
(7,3),
(8,1),
(9,2),
(10,4);

/*SELECT * FROM Pizza_Type_Topping;*/