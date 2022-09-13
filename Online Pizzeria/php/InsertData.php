<!doctype html>
<html>
<head>
	<title>Insert Data Into a Database</title>
	<link rel="stylesheet" href="../css/style.css" />
</head>
<body>

<?php
$servername ="localhost";
$dbname = "OnlinePizzeriademo";
$username = "root";
$password = "";

try {
	$conn = new PDO("mysql:host=$servername;dbname=$dbname",$username, $password );
	$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); 
	echo "<p style='color:Blue'>Successfully connected</p>";
}
catch (PDOException $err) {
	echo "<p style='color:red'>Connection Failed: " . $err->getMessage() . "</p>\r\n";
}

try {
	$sql="INSERT INTO Cheese (CheeseID,CheesePrice ,CheeseName, CheeseCalory) 
	VALUES (:CheeseID, :CheesePrice, :CheeseName, :CheeseCalory);";   
	$stmnt = $conn->prepare($sql);    
	$stmnt->bindParam(':CheeseID', $_POST['cheeseID']);  
	$stmnt->bindParam(':CheesePrice', $_POST['cheesePrice']);   
	$stmnt->bindParam(':CheeseName', $_POST['cheeseName']);
	$stmnt->bindParam(':CheeseCalory', $_POST['cheeseCalory']);


	$stmnt->execute();

	echo "<p style='color:green'>Data Inserted Into Table Successfully</p>";
}
catch (PDOException $err ) {
	echo "<p style='color:red'>Data Insertion Failed: " . $err->getMessage() . "</p>\r\n";
}
// Close the connection
unset($conn);

echo "<a href='../insertData.html'>Insert More Values</a> <br />";

echo "<a href='../index.html'>Back to the Homepage</a>";

?>

</body>
</html>