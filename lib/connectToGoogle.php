<?php

require_once dirname(__FILE__).'/google/Google_Client.php';
require_once dirname(__FILE__).'/google/contrib/Google_CalendarService.php';
session_start();

/*
 * Global vars:
 * gclient, gcal
 */
$gclient = new Google_Client();
$gcal = new Google_CalendarService($gclient);
$gclient->setApplicationName("kh webapp");

$gclient->setClientId(APP_CLIENTID);
$gclient->setClientSecret(APP_CLIENTSECRET);
$gclient->setRedirectUri(APP_REDIRECTURI);
// $gclient->setDeveloperKey('')
/*
if (isset($_GET['logout'])) {
	unset($_SESSION['token']);
}

if (isset($_GET['code'])) {
	$gclient->authenticate($_GET['code']);
	$_SESSION['token'] = $gclient->getAccessToken();
}

if (isset($_SESSION['token'])) {
	$gclient->setAccessToken($_SESSION['token']);
}

if (!$gclient->getAccessToken()) {
  $authUrl = $gclient->createAuthUrl();
  print "<a class='login' href='$authUrl'>Connect Me!</a>";
}
*/

$gclient->setAccessToken(APP_TOKEN);