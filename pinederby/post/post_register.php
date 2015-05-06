<?
	// Define an array to return
	$result = array(
		"error" => null,
		"notice" => null,
		"return" => null);

	// This check makes sure a username and password were sent
	if(!isset($_POST['username'])||!isset($_POST['password'])){
		$result['error'] = "No username/password sent";
		$result['return'] = false;
		echo json_encode($result);
		exit;
	}
	else{
		// Variables for the username and password - note: these need to be hashed before storing in the database
		// we don't want to store the plain text
		$username = $_POST['username'];
		$password = $_POST['password'];
	}
	
	//todo: check and make sure the username doesn't already exist in the database
	//		return false and a notice that the user already exists

	//todo: if the user doesn't already exist, create a username and password hash and store the
	//		hashed values in the pinederby user database
?>