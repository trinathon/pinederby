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
?>

<DOCTYPE html>
<html>
<head>
	<!-- Custom CSS -->
	<style>
	.wrapper{
		padding: 10px;
	}
	</style>

	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="http://getbootstrap.com/favicon.ico">

    <title>Pinewood Racer</title>

	<!-- Include Javascript Libraries -->
	<!-- JQuery -->
	<script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>

	<!-- Bootstrap -->
	<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
	<script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

	<script>
		$( document ).ready(function() {
		  initialize();
		});
		function initialize(){
			//todo: load all the derbys associated with the logged in user
			//		add the derbys to the list with links to load them
			console.log("refresh");
			refreshDerbyList();
		}
		function closeDerby(){
			//todo: function to close the open derby
			console.log("Close Derby"); //todo: remove debug
		}
		function createDerby(){
			//todo: function to create a derby
			//		we need the date the derby is to be created 
			//		the unique ID for pre-registration is only available for 2 weeks prior to the derby
			//		and can be used 1 day prior and 1 day after to view the presentation view
			var data = $('#createDerbyForm').serialize();
			console.log(data); //todo: remove debug
			$.ajax({
				type: "POST",
				url: 'post/post_create_derby.php',
				data: data,
				dataType: 'json',
				success: function( response ) {
					console.log( response );
					if(response.error==null){
						loadDerby(response.derby_id);
					}
				}
			});
		}
		function loadDerby(derbyId){
			// Hide the modal if the derby was just created
			$('#createDerbyModal').modal('hide');
			//todo: function to load the selected derby
			console.log('Derby '+derbyId);
			// Load derby data
			getDerbyData(derbyId).done(function(derby){
				console.log(derby);

			});
			// Set the derby name
			var derbyName = $('#'+derbyId).attr('name');
			$('#navDerbyName').html(derbyName);
			
			// Add derby tools to the navbar
			var buttons = $('<li>',{
				id: 'navDerbyButtons'
			});
			var closeButton = $('<button>',{
				id: 'closeDerbyBtn',
				type: 'button',
				class: 'btn btn-danger navbar-btn',
				html: '<span class="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>',
				onclick: 'closeDerby()'
			});

			buttons.append(closeButton);

			$('#navDerbyTools').append(buttons);

			// Clear the derby list notification
			$('#notify').html('');


			// Hide and show the divs for when a derby is loaded
			$('#initial').hide();
			$('#main').show();
			$('#navDerbySelect').hide();
			$('#navDerbyName').show();
		}//.loadDerby
		function refreshDerbyList(){
			//var userId = "<?php echo $_SESSION['user_id'];?>";
			var userId = "2";
			getDerbys(userId).done(function(data) {
				var derbys = data.derbys;
				var arrayLength = derbys.length;
				for (var i = 0; i < arrayLength; i++) {
				    var derby = derbys[i];
				    var derbyLi = $('<li>',{
				    	id:derby.derby_id,
				    	html:"<a href='#' onclick='loadDerby("+derby.derby_id+")'>"+derby.name+"</a>",
				    	name: derby.name
				    });
				    $('#derbyList').prepend(derbyLi);
				    $('#notify').html('<span class="glyphicon glyphicon-hand-left" aria-hidden="true"></span> Derby List');
				}
			});
		}
		function getDerbys(userId){
			var dynamicData = {};
			dynamicData["id"] = userId;
			return $.ajax({
				url: "post/get_derbys.php",
				type: "get",
				data: dynamicData,
				dataType: 'json'
			});
		}
		function getDerbyData(derbyId){
			var dynamicData = {};
			dynamicData["id"] = derbyId;
			return $.ajax({
				url: "post/get_derby_data.php",
				type: "get",
				data: dynamicData,
				dataType: 'json'
			});
		}
		function loadRacers(derbyId){
			$.ajax({
				type: "POST",
				url: 'post/get_racers.php',
				data: {
					derby_id: derbyId
				},
				dataType: 'json',
				success: function( response ) {
					console.log( response );
				}
			});	
		}
	</script>
</head>
<body>
<div id="container">

	<!-- Modals -->
	<!-- Create Derby Modal -->
	<div class="modal " id="createDerbyModal" tabindex="-1" role="dialog" aria-labelledby="itemBidLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
					<h4 class="modal-title" id="loginLabel">Pinewood Racer</h4>
				</div>
				<div id="modal-body" class="modal-body">
					<form id="createDerbyForm" role="form">
						<div class="form-group">
							<label for="newDerbyName">Pinewood Derby Name</label>
							<input type="text" id="newDerbyName" name="newDerbyName" class="form-control" placeholder="Derby Name">
						</div>
						<div class="form-group">
							<label for="newDerbyLanes">Number of Lanes</label>
							<select id="newDerbyLanes" name="newDerbyLanes" class="form-control">
								<option>2</option>
								<option>3</option>
								<option>4</option>
							</select>
						</div>
					</form>
				</div>
				<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						<button type="submit" class="btn btn-primary" onclick="createDerby()">Create</button>
				</div>
			</div>
		</div>
	</div>
	<!--./ End Create Derby Modal-->


	<!-- Navigation Section -->
	<nav class="navbar navbar-default" role="navigation" style="margin-bottom:10px">
		<div class="container-fluid">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="#">Pinewood Racer</a>
			</div>

			<!-- Collect the nav links, forms, and other content for toggling -->
			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav">
					<li id="navDerbySelect" class="dropdown" data-toggle="popover" data-trigger="focus" title="Create/Load A Derby" data-content="Click here to begin">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false" >Create/Load Derby <span class="caret"></span></a>
						<ul id="derbyList" class="dropdown-menu" role="menu">
							<li class="divider"></li>
							<li><a href="#" data-toggle="modal" data-target="#createDerbyModal">Create A Derby</a></li>
						</ul>
					</li>
					<li id="navDerbyName" class="navbar-text">

					</li>
					<li id="navDerbyTools">

					</li>
					<li>
						<p id='notify' class="navbar-text"></p> 
					</li>
				</ul>
				<ul class="nav navbar-nav navbar-right">
					<li><a href="includes/logout.php">Logout</a></li>
				</ul>
			</div><!-- /.navbar-collapse -->
		</div><!-- /.container-fluid -->
	</nav>



	<div id="wrapper" class="wrapper">
		<div id="initial" class="row">
			<div class="col-md-4"></div>
			<div class="col-md-4">
				<strong>Create/Load a Derby to get Started</strong>
			</div>
			<div class="col-md-4"></div>
		</div><!--./initial-->



		<div id="main" class="row" style="display:none;">
			<div id="heatList" class="col-md-3">
				<strong>Scores</strong>

			</div>
			<div id="heatContainer" class="col-md-9">
				<div id="heatBody" class="row">
					<div id="heatRanking" class="col-md-8">
						<strong>Heat Rankings will be here</strong>
						Touch the racer images in the order that they finished then press next to move on to the next heat. 
					</div><!--./heatRanking-->
					<div id="heatRight" class="col-md-4">
						<strong>This is the heat extra space (needed?)</strong>
					</div><!--./heatRight-->
				</div><!--./heatBody-->
				<div id="heatFooter" class="row">
					<div class="col-md-12 well">
						<strong>This is the Heat Footer</strong>
					</div>
				</div><!--./heatFooter-->
			</div><!--./heatContainer-->
		</div><!--./main-->
	</div>
</div><!--./container-->


</body>
</html>