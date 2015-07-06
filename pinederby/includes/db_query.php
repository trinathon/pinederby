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

?>