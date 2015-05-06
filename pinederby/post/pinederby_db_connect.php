<?
	//todo: add the pinederby database connection and then include this file whenever we need the pinederby database
	$host = "bownsclan.net";
	$user ="derbyman";
	$password = "w1Nn3r$";
	$database = "testderby";

	// create the connection here
	$db = mysql_connect($host, $user, $password);
	if (!$db) {
	    die('Could not connect: ' . mysql_error());
	}
	//echo 'Connected successfully';
	//mysql_close($link);
?>