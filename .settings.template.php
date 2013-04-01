<?php

/**
 * Default settings
 */

define('APP_CLIENTID', ''); // Google console client id
define('APP_CLIENTSECRET', ''); // Google console client secret
define('APP_REDIRECTURI', 'http://'.$_SERVER['SERVER_NAME'].'/~knut/webapp/gettoken.php');
echo APP_REDIRECTURI;
define('APP_GOOGLEUSER', ''); // set to the only allowed google user
define('APP_GETTOKENPASSWORD', 'utopia');

require '.token.php';