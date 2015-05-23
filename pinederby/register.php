<?php
include_once 'includes/register.inc.php';
include_once 'includes/functions.php';
?>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Secure Login: Registration Form</title>
        <script type="text/JavaScript" src="js/sha512.js"></script> 
        <script type="text/JavaScript" src="js/forms.js"></script>
       
        <!-- Include Javascript Libraries -->
        <!-- JQuery -->
        <script src="//ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>

        <!-- Bootstrap -->
        <script src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

         <!-- Bootstrap core CSS -->
        <link href="http://getbootstrap.com/dist/css/bootstrap.min.css" rel="stylesheet">
        <!--<link href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">-->

        <!-- Custom styles for this template -->
        <link href="css/login.css" rel="stylesheet">
    </head>
    <body>

        <div class="container login">
            <div class="form-signin">
                <img class="img-responsive" src="images/car-logo.png" alt="LOGO GOES HERE">
            </div>

            <div class="row">
                <div id="fill" class="col-3-md"></div>
                <div id="manageColumn" class="col-4-md">
                    <!-- Registration form to be output if the POST variables are not
                    set or if the registration script caused an error. -->
                    <h1>Register with us</h1>
                    <?php
                    if (!empty($error_msg)) {
                        echo $error_msg;
                    }
                    ?>
                    <ul>
                        <li>Usernames may contain only digits, upper and lower case letters and underscores</li>
                        <li>Emails must have a valid email format</li>
                        <li>Passwords must be at least 6 characters long</li>
                        <li>Passwords must contain
                            <ul>
                                <li>At least one uppercase letter (A..Z)</li>
                                <li>At least one lower case letter (a..z)</li>
                                <li>At least one number (0..9)</li>
                            </ul>
                        </li>
                        <li>Your password and confirmation must match exactly</li>
                    </ul>
                    <form action="<?php echo esc_url($_SERVER['PHP_SELF']); ?>" method="post" name="registration_form" class="form-signin" role="form">
                        <label for="username" class="sr-only">Username</label>
                        <input type="text" id="username" name='username' class="form-control" placeholder="Username" required="true" autofocus="">
                        <label for="email" class="sr-only">Email address</label>
                        <input type="email" id="email" name='email' class="form-control" placeholder="Email address" required="true" autofocus="">

                        <label for="password" class="sr-only">Password</label>
                        <input type="password" id="password" name="password" class="form-control" placeholder="Password" required="true">

                        <label for="confirmpwd" class="sr-only">Confirm Password</label>
                        <input type="password" id="confirmpwd" name="confirmpwd" class="form-control" placeholder="Confirm Password" required="true">

                        <input type="button" class="btn btn-default" value="Register" 
                            onclick="return regformhash(this.form,
                                this.form.username,
                                this.form.email,
                                this.form.password,
                                this.form.confirmpwd);" />
                        <a href="index.php" type="button" class="btn btn-danger">Cancel</a>
                    </form>
                </div><!--.manageColumn-->
                <div id="fill" class="col-3-md"></div>
            </div>
        </div>
    </body>
</html>