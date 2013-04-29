<?php

error_reporting(E_ALL);

require '.settings.php';
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
        $data = array();
        $calendarId = $req->param('calendar');
    
        $options = array(
            'timeMin' => gmdate('c', strtotime("-1 month"))
        );

        if ($calendarId == 'all') {
            $data = array();
            $calendars = $this->gcal->calendarList->listCalendarList();
            $calendars = $calendars['items'];
            foreach ($calendars as $calendar) {
                $items = $this->gcal->events->listEvents($calendar['id'], $options);
                if (isset($items['items'])) {
                    $items = $items['items'];
                    $data = array_merge($data, $items);
                }
            }
        } else {
            $data = $this->gcal->events->listEvents($calendarId, $options);
            $data = $data['items'];
        }

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
        $res->sendData($data['items']);
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

class ColorsModel extends Model {

    private $gcal;

    public function __construct($router) {
        global $gcal, $gclient;
        $this->gcal = $gcal;
        parent::__construct($router);
    }

    public function index($req, $res) {
        $this->sendData(array('error' => 'Cannot list colors'));
    }

    /** Get a specific color
     *  url: /colors/:id(/*) */
    public function get($req, $res) {
        $id = $req->param('id');
        $data = $this->gcal->colors->get($id);
        $res->sendData($data);
    }

    public function update($req, $res) {
        $this->sendData(array('error' => 'Cannot update a color'));
    }

    public function delete($req, $res) {
        $this->sendData(array('error' => 'Cannot delete a color.'));
    }

    public function create($req, $res) {
        $this->sendData(array('error' => 'Cannot create a color.'));
    }
}


$router = new Router();
new CalendarsModel($router);
new EventsModel($router);
new ColorsModel($router);
$router->run();