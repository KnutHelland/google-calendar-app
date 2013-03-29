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

$gclient->setClientId('661924815038-fet45jucrds47q8utfo7c6apm1po7r8r.apps.googleusercontent.com');
$gclient->setClientSecret('_ht7x2qXFVaQSaGHH2jqKcuS');
$gclient->setRedirectUri('http://localhost/~knut/webapp/index.php');
// $gclient->setDeveloperKey('')

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