<?php
  include_once 'includes/db_connect.php';
  include_once 'includes/functions.php';
   
  sec_session_start();
   
  if (login_check($mysqli) == true) {
    $logged = 'in';
  } else {
    $logged = 'out';
  }
?>
<DOCTYPE html>
<html lang="en">
  <head>
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
    <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

    <!-- Login Scripts -->
    <script src="js/sha512.js"></script>
    <script src="js/forms.js"></script>

    <!-- Bootstrap core CSS -->
    <link href="http://getbootstrap.com/dist/css/bootstrap.min.css" rel="stylesheet">
    <!--<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">-->

    <!-- Custom styles for this template -->
    <link href="css/login.css" rel="stylesheet">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>

  <body>
    <div class="container login">
      <div class="form-signin">
        <img class="img-responsive" src="images/car-logo.png" alt="LOGO GOES HERE">
      </div>

      <div class="row">
        <div id="manageColumn" class="col-6-md">
          <?php
            if (isset($_GET['error'])) {
                echo '<p class="error">Error Logging In!</p>';
            }
          ?>
          <form id="userInfo" class="form-signin" role="form" action="includes/process_login.php" method="post" name="login_form">
            <h2 class="form-signin-heading">Please sign in</h2>
            <label for="email" class="sr-only">Email address</label>
            <input type="email" id="email" name="email" class="form-control" placeholder="Email address" required="" autofocus="">
            <label for="password" class="sr-only">Password</label>
            <input type="password" id="password" name="password" class="form-control" placeholder="Password" required="">
            <!--<div class="checkbox">
              <label>
              <input type="checkbox" value="remember-me"> Remember me
              </label>
            </div>-->
            <button class="btn btn-lg btn-primary" type="submit" onclick="formhash(this.form, this.form.password);">Sign in</button>
            <a type="button" class="btn btn-lg btn-success" href="register.php">Register</a>
            <div id="result">
            </div>

          </form>

        </div><!--.manageColumn -->
        <div id="racerRegistrationColumn" class="col-6-md">
          <form id="racerRegistration" class="form-signin" role="form">
            <h2 class="form-signin-heading">Derby Pre-registration</h2>
            <label for="inputDerbyId" class="sr-only">Unique Derby ID</label>
            <input type="text" id="inputDerbyId" class="form-control" placeholder="Unique Derby ID" required="true" autofocus="" style="margin-bottom:10px">
            <button class="btn btn-lg btn-primary" type="submit">Pre-Register</button>
            <div>
              <i>This is for racers to register for a derby that has already been created by someone else. You will need to get your unique derby ID from the person managing the derby. 
              If they don't have one they will need to register for an account above and create a new derby.</i>
            </div>
          </form>
        </div>
      </div> <!-- /row -->
    </div> <!-- /container -->
</body>
</html>