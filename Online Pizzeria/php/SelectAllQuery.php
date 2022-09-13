<!doctype html>
<html>
<head>
    <title>Display Records of a table</title>
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
        $sql = "SELECT  CheeseID,CheesePrice,CheeseName,CheeseCalory FROM Cheese";
        $stmnt = $conn->prepare($sql);   

        $stmnt->execute();

        $row = $stmnt->fetch();  
        if ($row) {      
            echo '<table>';
            echo '<tr> <th>Cheese ID</th> <th>Cheese Price</th> <th>Cheese Name</th> <th>Cheese Calory</th> </tr>';
            do {
                echo "<tr><td>$row[cheeseID]</td><td>$row[cheesePrice]</td><td>$row[cheeseName]</td><td>$row[cheeseCalory]</td></tr>";
            } while ($row = $stmnt->fetch());     
            echo '</table>';
        } else {
            echo "<p> No Record Found!</p>";
        }
    } catch (PDOException $err) {
        echo "<p style='color:red'>Record Retrieval Failed: " . $err->getMessage() . "</p>\r\n";
    }
    // Close the connection
    unset($conn);

    echo "<a href='../index.html'>Back to the Homepage</a>";

    ?>
</body>

</html>