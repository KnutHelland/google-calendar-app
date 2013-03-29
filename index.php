<?php

require_once 'lib/server.php';
require 'lib/connectToGoogle.php';

if (!strstr($_SERVER['HTTP_ACCEPT'], 'json')) {
	header('location: client.html');
}

class EventsModel extends Model {

	public $idRegex = '[[:alnum:]\-\_\.\@]+';

	public $gcal;

	public function __construct($router) {
		global $gcal, $gclient;
		$this->gcal = $gcal;

		// Matches /calendar/:calendar/events(/*)
		$this->overrideIndexRegex = '/^\/calendar\/(?P<calendar>'.$this->idRegex.')\/events(?:|\/.*)$/i';

		parent::__construct($router);
	}

	/** List calendar events
	 *  url: /calendar/:calendar/events(/*) */
	public function index($req, $res) {
		$calendarId = $req->param('calendar');
		$data = $this->gcal->events->listEvents($calendarId);
		$res->sendData($data);
	}

	/** /events/:id(/*) */
	public function get($req, $res) {
		$id = $req->param('id');
		$data = $this->gcal->events->get($id);
		$res->sendData($id);
	}

	public function update($req, $res) {
		$res->sendData(array('error' => 'Cannot update events.'));
	}

	public function delete($req, $res) {
		$res->sendData(array('error' => 'Cannot delete events'));
	}

	public function create($req, $res) {
		$res->sendData(array('error' => 'Cannot create events'));
	}
}

class CalendarsModel extends Model {

	public $idRegex = '[[:alnum:]\-\_\.\@]+';

	private $gcal;

	public function __construct($router) {
		global $gcal, $gclient;
		$this->gcal = $gcal;
		parent::__construct($router);
	}

	/** Get all available calendars 
	  * url: /calendars(/) */
	public function index($req, $res) {
		$data = $this->gcal->calendarList->listCalendarList();
		$res->sendData($data);
	}

	/** Get info about the calendar
	 *  url: /calendars/:id(/*) */
	public function get($req, $res) {
		$id = $req->param('id');
		$data = $this->gcal->calendars->get($id);
		$res->sendData($data);
	}

	public function update($req, $res) {
		$this->sendData(array('error' => 'Cannot update a calendar'));
	}

	public function delete($req, $res) {
		$this->sendData(array('error' => 'Cannot delete a calendar.'));
	}

	public function create($req, $res) {
		$this->sendData(array('error' => 'Cannot create a calendar.'));
	}
}


$router = new Router();
new CalendarsModel($router);
new EventsModel($router);
$router->run();