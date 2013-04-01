<?php

require '.settings.php';
require 'lib/google/Google_Client.php';
require 'lib/google/contrib/Google_CalendarService.php';
require 'lib/google/contrib/Google_Oauth2Service.php';

$redirect = dirname(APP_REDIRECTURI).'/client.html';

$gclient = new Google_Client();
$gcal = new Google_CalendarService($gclient);
$gauth = new Google_Oauth2Service($gclient);

$gclient->setApplicationName("Kalender for Knut");
$gclient->setClientId(APP_CLIENTID);
$gclient->setClientSecret(APP_CLIENTSECRET);
$gclient->setRedirectUri(APP_REDIRECTURI);

/* Try to login with existing token */
try {
	$gclient->setAccessToken(APP_TOKEN);
	$userinfo = $gauth->userinfo->get();
	header('location: '.$redirect);
	exit();
} catch (Exception $e) {}


if (isset($_GET['code'])) {
	$gclient->authenticate($_GET['code']);

	$userinfo = $gauth->userinfo->get();
	if ($userinfo['email'] != APP_GOOGLEUSER) {
		echo 'Kan ikke logge inn som andre enn Knut Helland';
		exit();
	}

	file_put_contents('.token.php', "<?php define('APP_TOKEN', '{$gclient->getAccessToken()}');");
	header('location: '.$redirect);
}

if ($_POST['gettokenpassword'] && $_POST['gettokenpassword'] == APP_GETTOKENPASSWORD) {
	header('location: '.$gclient->createAuthUrl());
	exit();
} else {
	echo 'You need to startup the application. Enter the password: <form method="post"><input type="password" name="gettokenpassword" /><input type="submit" /></form>';
	exit();
}