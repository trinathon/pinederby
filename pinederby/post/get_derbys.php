<?php
	require_once('../includes/db_connect.php');
	$data = array();
	if(isset($_GET['id'])){
		$query = "	SELECT `derby_id`, `name`, `number_of_lanes`,`status`,`creation_date`
					FROM `derbys`
					WHERE `user_id`='".$_GET['id']."'";
		/* Select queries return a resultset */
		if ($result = $mysqli->query($query)) {
			$derbys = array();
			while($obj = $result->fetch_object()){
				$derbys[] = $obj;
        	}
        	$data['derbys'] = $derbys;
			/* free result set */
			$result->close();
		}
		$data['success'] = true;


	} else {
		$data['error'] = "No User ID";
	}
	echo json_encode($data);
?>