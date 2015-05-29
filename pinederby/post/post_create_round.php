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
		echo "<pre>";
		var_dump($racers);
		echo "</pre>";
		echo "<strong>Number of Racers: ".sizeof($racers)."</strong>\n";
		$result->close();
	}
	// Put the racer ID's in a list
	$racer_ids = array();
	foreach ($racers as $key => $value) {
		$racer = $racers[$key];
		$racer = (array) $racer;
		$racer_ids[] = $racer['racer_id'];
	}

	// Get Previous round offsets
	$rounds = array();
	$query = "	SELECT *
				FROM `rounds`
				WHERE `derby_id`='".$derby_id."'";
	if ($result = $mysqli->query($query)) {
		while($obj = $result->fetch_object()){
			$rounds[] = $obj;	
		}
		echo "<pre>";
		var_dump($rounds);
		echo "</pre>";
		echo "<strong>Number of Rounds: ".sizeof($rounds)."</strong>\n";
		$result->close();
	}
	// Get previously used generators from rounds
	$prev_gens = array();
	foreach ($rounds as $key => $value) {
		$round = $rounds[$key];
		$round = (array) $round;
		$prev_gens[] = $round['generator_id'];
	}
	asort($prev_gens);

	// Get generators with same number of Lanes
	$generators = array();
	$query = "	SELECT *
				FROM `generators`
				WHERE `number_of_lanes`='".$number_of_lanes."'";
	if ($result = $mysqli->query($query)) {
		while($obj = $result->fetch_object()){
			$generators[] = $obj;	
		}
		echo "<pre>";
		var_dump($generators);
		echo "</pre>";
		echo "<strong>Number of Generators: ".sizeof($generators)."</strong></br>";
		$result->close();
	}
	$number_of_generators = sizeof($generators);

/*
	// Get unused generators with same number of Lanes
	//
	// Check inner select for limiting the rounds query to the current derby
	//
//	$generator = 0;
//	$query = "CALL get_next_generator($derby_id,'.$number_of_lanes.')";
	$query = "SELECT get_next_generator(1,3);"
	if ($result = $mysqli->query($query)) {
		while($obj = $result->fetch_object()){
			$generator = $obj;	
		}
		echo "<pre>";
		var_dump($generator);
		echo "</pre>";
		echo "<strong>Generator Id: "$generator"</strong></br>";
		$result->close();
	}
*/
	
	// Select a random generator that hasn't already been used
	echo "RANDOM</br>";
	$rnd_gens = range(1, $number_of_generators); 
	shuffle($rnd_gens); 
	$rnd = array_slice($rnd_gens, 0, $number_of_generators); 
	print_r($rnd_gens);
	echo "</br>END RANDOM</br>";
	$i = 0;
	do {
		$round_gen_index = $rnd_gens[$i];
		$i++;
	} while (in_array($round_gen_index, $prev_gens));
	//todo: add logic for the case that we have exhausted all possible gens


	echo "<strong>Generator for this round ".$round_gen_index."</strong></br>";
	var_dump($generators[$round_gen_index-1]);
	$round_gen = $generators[$round_gen_index-1];
	$round_gen = (array) $round_gen;
	$offsets = explode(',', $round_gen['offsets']);
	echo "</br><strong>Offsets</strong></br>";
	var_dump($offsets);

?>