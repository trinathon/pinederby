<?php
	include_once 'includes/db_connect.php';
	include_once 'includes/functions.php';
 
	sec_session_start();
 
	if (login_check($mysqli) == true){
		echo htmlentities($_SESSION['username']);
	}
	else {
		echo "NOT LOGGED";
	}

	// Check if the unique ID sent was valid if not return to login page
	if(isset($_GET['unique_id'])){
		$query = "	SELECT `derby_id`
					FROM `derbys`
					WHERE `unique_id`='".$_GET['unique_id']."'";
		/* Select queries return a resultset */
		if ($result = $mysqli->query($query)) {
			while($obj = $result->fetch_object()){
				$derby = (array) $obj;
        	}
			/* free result set */
			$result->close();

			if($derby==null){
				// No derby with that unique ID
        		header('Location: ../index.php?error=2');
			} else {
				// Found the derby, store the derby ID
				$derby['success'] = true;
			}
		}
		else {
			// SQL Failed
        	header('Location: ../index.php');
		}


	} else {
		header('Location: ../index.php');
	}
?>

<DOCTYPE html>
<html>
<head>
	<!-- Custom CSS -->
	<style>
	.wrapper{
		padding: 10px;
	}
	.btn-file {
	    position: relative;
	    overflow: hidden;
	}
	.btn-file input[type=file] {
	    position: absolute;
	    top: 0;
	    right: 0;
	    min-width: 100%;
	    min-height: 100%;
	    font-size: 100px;
	    text-align: right;
	    filter: alpha(opacity=0);
	    opacity: 0;
	    outline: none;
	    background: white;
	    cursor: inherit;
	    display: block;
	}
	</style>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="http://getbootstrap.com/favicon.ico">

    <title>Pinewood Racer - Preregistration</title>

	<!-- Include Javascript Libraries -->
	<!-- JQuery -->
	<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>

	<!-- Bootstrap -->
	<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
	<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

	<!-- Custom styles for this template -->
    <link href="css/login.css" rel="stylesheet">

	<script>
		$(document).on('change', '.btn-file :file', function() {
			var input = $(this),
				numFiles = input.get(0).files ? input.get(0).files.length : 1,
				label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
			input.trigger('fileselect', [numFiles, label]);
		});
		$( document ).ready(function() {
		  	initialize();

		  	// A few event listeners
			$('.btn-file :file').on('fileselect', function(event, numFiles, label) {
				console.log(numFiles);
				console.log(label);
			});
			// Change the car photo
			$("#car_photo").change(function(){
				readURL(this);
			});
		});

		function readURL(input) {
			// Gives image preview
		    if (input.files && input.files[0]) {
		        var reader = new FileReader();

		        reader.onload = function (e) {
		            $('#carPhotoPreview').attr('src', e.target.result);
		        }
		        reader.readAsDataURL(input.files[0]);
		        $('#carPhotoPreview').attr('width', '300px');
		        $('#carPhotoPreviewContainer').show();
		    }
		}

		
		function initialize(){
			//todo: load all the derbys associated with the logged in user
			//		add the derbys to the list with links to load them
			console.log("refresh");
		}
	</script>
</head>
<body>
<div id="container login">
	<div id="main" class="row" >
		<div class="form-signin">
			<img class="img-responsive" src="images/car-logo.png" alt="LOGO GOES HERE">
		</div>
		<div id="formContainer" class="col-6-md">
			
			<form id="userInfo" class="form-signin" role="form" action="includes/process_login.php" method="post" name="login_form">
				<h2 class="form-signin-heading">Please fill in info</h2>
				<label for="first_name" class="sr-only">First Name</label>
				<input type="text" id="first_name" name="first_name" class="form-control" placeholder="First Name" required="true" autofocus="true">
				<label for="last_name" class="sr-only">Last Name</label>
				<input type="text" id="last_name" name="last_name" class="form-control" placeholder="Last Name" required="true" autofocus="true">

				<span class="btn btn-default btn-lg btn-file">
				    Take/Select Car Photo <input id="car_photo" type="file" accept="image/*" capture="camera" name="car_photo"></input>
				</span>
				<div id="carPhotoPreviewContainer" class="panel panel-default" style="display:none">
					<div class="panel-heading">
						<strong>Image Preview</strong>
					</div>
					<div class="panel-body">
						<img id="carPhotoPreview" src="" width="100px">
					</div>
				</div>
				<button class="btn btn-lg btn-primary" type="submit" onclick="">Submit</button>
			</form>
		</div><!--./formContainer-->
	</div><!--./main-->
</div><!--./container-->


</body>
</html>