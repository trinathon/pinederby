<?php
//	require_once('db_connect.php');
	// Generic query
	function qsql($tQuery) {
//	echo "$tQuery";
	require('db_connect.php');
		if ($result = $mysqli->query($tQuery)) {
			$rows = array();
			while($row = mysqli_fetch_assoc($result)) {
			    $rows[] = $row;
			}
//			echo json_encode($rows);
			return json_encode($rows);
		}
	}

/*
	$query = $_POST['query'];
	$resultset = array();
	if ($result = $mysqli->query($query)) {
		while($obj = $result->fetch_object()){
			$derby = $obj;
		}
		$result->close();

		$resultset =  (array) $resultset;
		/-*echo "<pre>";
		var_dump($derby);
		echo "</pre>";*-/
		$number_of_lanes = $derby['number_of_lanes'];
		echo "<strong>Number of Lanes: ".$number_of_lanes."</strong>\n";
	}
*/
/*
	$sth = mysqli_query("SELECT ...");
	$rows = array();
	while($r = mysqli_fetch_assoc($sth)) {
	    $rows[] = $r;
	}
	print json_encode($rows);
*/

?>