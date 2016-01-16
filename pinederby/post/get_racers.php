<?php
	require_once('../includes/db_query.php');
	$data = array();
	if(isset($_GET['derby_id'])){
		$tQuery = "SELECT *
					FROM `racers`
					WHERE `derby_id`='".$_GET['derby_id']."'";
		/* Select queries return a resultset */
	}
	echo qsql($tQuery);
?>