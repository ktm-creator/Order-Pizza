<!doctype html>
<html>
<head>
	<title>Create a Table</title>
	<link rel="stylesheet" href="../css/style.css" />
</head>

<body>
	<?php
	$servername = "localhost";
	$dbname = "OnlinePizzeriademo";
	$username = "root";
	$password = "";

	try {
        $conn = new PDO("mysql:host=$GLOBALS[servername];dbname=$GLOBALS[dbname]", $GLOBALS['username'], $GLOBALS['password']);
		$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION); 
		echo "<p style='color:Blue'>Successfully connected</p>";
	} catch (PDOException $err) {
		echo "<p style='color:red'>Connection Failed: " . $err->getMessage() . "</p>\r\n";
	}

	$sql = "CREATE TABLE Cheese(
          CheeseID INT PRIMARY KEY,
          CheesePrice NUMERIC(4,2) NOT NULL,
          CheeseName VARCHAR(50) NOT NULL UNIQUE,
          CheeseCalory INT NOT NULL
	);";

	try {
		$conn->exec($sql);
		echo "<p style='color:blue'>Table Created Successfully</p>";
	} catch (PDOException $err) {
		echo "<p style='color:red'>Table Creation Failed: " . $err->getMessage() . "</p>\r\n";
	}

	// Close the connection
	unset($conn);

	echo "<a href='../index.html'>Back to the Homepage</a>";

	?>

</body>

</html>