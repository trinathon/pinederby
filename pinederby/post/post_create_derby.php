<?php
	require_once('../includes/db_connect.php');
	$data = array();
	if(isset($_POST['newDerbyName'])) {
		$name = $_POST['newDerbyName'];
		$number_of_lanes = $_POST['newDerbyLanes'];
		$user_id = 2; //todo: set user id to the session variable

		$query = "INSERT INTO derbys (name, user_id, number_of_lanes) VALUES ('".$name."', '".$user_id."', '".$number_of_lanes."')";

		if ($mysqli->query($query)) {
			$data['derby_id'] = mysql_insert_id($mysqli);
		} else {
			$data['error'] = "Failed";
		}
	} else {
		$data['error'] = "No Data";
	}
	echo json_encode($data);
?>