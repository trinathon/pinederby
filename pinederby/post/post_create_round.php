<?php
	require_once('../includes/db_connect.php');
	// Setup fake post variables
	// todo: finish with real variables
	$derby_id = 1;

	// Get the derby Data
	$query = "	SELECT `derby_id`, `name`, `number_of_lanes`,`status`,`creation_date`
					FROM `derbys`
					WHERE `derby_id`='".$derby_id."'";
	$derby = array();
	if ($result = $mysqli->query($query)) {
		while($obj = $result->fetch_object()){
			$derby = $obj;
		}
		$result->close();

		$derby =  (array) $derby;
		/*echo "<pre>";
		var_dump($derby);
		echo "</pre>";*/
		$number_of_lanes = $derby['number_of_lanes'];
		echo "<strong>Number of Lanes: ".$number_of_lanes."</strong>\n";
	}
	

	// Get the racers
	$racers = array();
	$query = "	SELECT *
				FROM `racers`
				WHERE `derby_id`='".$derby_id."'";
	if ($result = $mysqli->query($query)) {
		while($obj = $result->fetch_object()){
			$racers[] = $obj;	
		}
		/*echo "<pre>";
		var_dump($racers);
		echo "</pre>";*/
		echo "<strong>Number of Racers: ".sizeof($racers)."</strong>\n";
		$result->close();
	}


?>