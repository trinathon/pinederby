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
		function createDerby(){
			//todo: function to create a derby
			//		we need the date the derby is to be created 
			//		the unique ID for pre-registration is only available for 2 weeks prior to the derby
			//		and can be used 1 day prior and 1 day after to view the presentation view

		}
		function loadDerby(derbyId){
			//todo: function to load the selected derby
			console.log('Derby '+derbyId);
			// Load derby data


			// Hide and show the divs for when a derby is loaded
			$('#initial').hide();
			$('#main').show();
			$('#navDerbySelect').hide();
			$('#navDerbyName').show();

		}
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
				    	html:"<a href='#' onclick='loadDerby("+derby.derby_id+")'>"+derby.name+"</a>"
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
	</script>
</head>
<body>
<div id="container">

	<!-- Modals -->
	<!-- Login -->
	<div class="modal " id="createDerbyModal" tabindex="-1" role="dialog" aria-labelledby="itemBidLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
					<h4 class="modal-title" id="loginLabel">Pinewood Racer</h4>
				</div>
				<div id="modal-body" class="modal-body">
					<form id="loginForm" role="form">
						<div class="form-group">
							<label for="exampleInputEmail1">Email address</label>
							<input type="email" class="form-control" id="exampleInputEmail1" placeholder="Enter email">
						</div>
						<div class="form-group">
							<label for="exampleInputPassword1">Password</label>
							<input type="password" class="form-control" id="exampleInputPassword1" placeholder="Password">
						</div>
				</div>
				<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						<button type="submit" class="btn btn-primary" onclick="login()">Login</button>
					</form>
				</div>
			</div>
		</div>
	</div>


	<!-- Navigation Section -->
	<nav class="navbar navbar-default" role="navigation">
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
					<li id="navDerbyName">

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
				<strong>Heat List goes here</strong>
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