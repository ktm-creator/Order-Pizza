<!doctype html>
<html>
<head>
    <title>Update a record of a table</title>
    <link rel="stylesheet" href="../css/style.css" />
</head>

<body>

    <?php
    $servername = "localhost";
    $dbname = "OnlinePizzeriademo";
    $username = "root";
    $password = "";

    try {
        $conn = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
        $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        echo "<p style='color:blue'>Successfully connected</p>";
    } catch (PDOException $err) {
        echo "<p style='color:red'> Connection Failed: " . $err->getMessage() . "</p>\r\n";
    }

    try {
        $sql = "UPDATE $dbname.cheese SET cheeseCalory = :cheeseCalory WHERE cheeseID = :cheeseID";
        $stmnt = $conn->prepare($sql);        
        $stmnt->bindParam(':cheeseID', $_POST['cheeseId']);
        $stmnt->bindParam(':cheeseCalory', $_POST['cheeseCalory']);

        $stmnt->execute();
        echo "<p style='color:green'>Record Updated Successfully</p>";
    } catch (PDOException $err) {
        echo "<p style='color:red'>Record Update Failed: " . $err->getMessage() . "</p>\r\n";
    }
    // Close the connection
    unset($conn);

    echo "<a href='../index.html'>Back to the Homepage</a>";

    ?>
</body>

</html>