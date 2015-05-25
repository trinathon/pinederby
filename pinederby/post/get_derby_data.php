<?php
	require_once('../includes/db_connect.php');
	function getHeats($derby_id, $mysqli){
		$query = "	SELECT *
					FROM `heats`
					WHERE `derby_id`='".$derby_id."'";
		/* Select queries return a resultset */
		if ($result = $mysqli->query($query)) {
			$racers = array();
			while($obj = $result->fetch_object()){
				$racers[] = $obj;
        	}
        	
			/* free result set */
			$result->close();
		}
		return $racers;
	}
	function getRacers($derby_id, $mysqli){
		$query = "	SELECT *
					FROM `racers`
					WHERE `derby_id`='".$derby_id."'";
		/* Select queries return a resultset */
		if ($result = $mysqli->query($query)) {
			$racers = array();
			while($obj = $result->fetch_object()){
				$racers[] = $obj;
        	}
        	
			/* free result set */
			$result->close();
		}
		return $racers;
	}
	$data = array();
	if(isset($_GET['id'])){
		$derby_id = $_GET['id'];
		$data['racers'] = getRacers($derby_id, $mysqli);
		$data['success'] = true;
	} else {
		$data['error'] = "No Derby ID";
	}
	echo json_encode($data);
?>