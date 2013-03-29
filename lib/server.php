<?php

error_reporting(E_ALL);



class Request {
	/** The RESTful method */
	public $method;

	/** Query string */
	public $query;

	/** Parameters */
	public $params = array();

	/** If the request contained JSON-data, this contains the data decoded. */
	public $data = '';

	/** Return the parameter */
	public function param($name) {
		if (isset($this->params[$name])) {
			return $this->params[$name];
		} else {
			return null;
		}
	}

	/** Create a request object from the current request. */
	public static function parseCurrentRequest() {
		$req = new Request;
		$req->method = $_SERVER['REQUEST_METHOD'];
		$req->query = $_SERVER['QUERY_STRING'];
		$req->data = json_decode(file_get_contents('php://input'));
		return $req;
	}
}


class Response {
	/** Content buffer to send if no data. */
	private $buffer = '';

	/** Data to send if it is a json type */
	private $data = array();

	/** Content type to be sendt */
	private $contentType = 'application/json';

	public function sendHeader($name, $value) {
	 	header($name, $value);
	}

	/** Appends data to the data buffer */
	public function sendData($data) {
		$this->data = array_merge($this->data, (array)$data);
	}

	public function send($text) {
		if (count($this->data) > 0) {
			trigger_error("Data is already sent, so sending text has no effect.");
		}

		$this->buffer .= $text;
	}

	/** Send the response */
	public function flush() {
		$this->sendHeader("Content-type", $this->contentType);
		
		if (count($this->data) == 0 && strlen($this->buffer) > 0) {
			echo $this->buffer;
		} else {
			echo json_encode($this->data);
		}
	}
}

/** Routes the request based on simple rules */
class Router {
	/** Instance of the request */
	private $req;

	/** The response */
	private $res;

	public function __construct() {
		$this->req = Request::parseCurrentRequest();
		$this->res = new Response;
	}

	/** Handles any methods */
	public function any($regex, $callback) {
		if (preg_match($regex, $this->req->query, $params)) {
			unset($params[0]);
			$this->req->params = $params;
			call_user_func_array($callback, array($this->req, $this->res));
		}
	}

	/** Overloads so you can have functions /method/($regex, $callback) */
	public function __call($name, $arguments) {

		$methods = array('get', 'post', 'put', 'delete');
		if (in_array($name, $methods) && count($arguments) == 2) {

			if ($this->req->method == strtoupper($name)) {
				$this->any($arguments[0], $arguments[1]);
			}

			return;
		}

		trigger_error("Method <strong>Router::" + $name + "</strong> does not exist.", E_USER_ERROR);
	}


	public function run() {
		$this->res->flush();
	}
}



/** A datamodel that can be extended and used with the router. */
abstract class Model {
	/** The part of the regex that matches the id */
	public $idRegex = "[0-9]+";

	public $overrideName = null;

	public $overrideIndexRegex = null;

	public $overrideGetRegex = null;

	public $overrideCreateRegex = null;

	public $overrideUpdateRegex = null;

	public $overrideDeleteRegex = null;

	public function __construct($router) {
		$model = strtolower(get_class($this));
		if (substr($model, -5) == 'model') $model = substr($model, 0, -5);
		if ($this->overrideName) $model = $overrideName;

		$pre = "/^\/{$model}";
		$base = $pre.'\/?$/i';
		$byId = $pre.'\/(?P<id>'.$this->idRegex.')(?:|\/.*)$/i';
		
		$index = $base;
		if ($this->overrideIndexRegex) $index = $this->overrideIndexRegex;
		$router->get($index, array($this, 'index'));

		$get = $byId;
		if ($this->overrideGetRegex) $get = $this->overrideGetRegex;
		$router->get($get, array($this, 'get'));

		$create = $base;
		if ($this->overrideCreateRegex) $create = $this->overrideCreateRegex;
		$router->post($create, array($this, 'create'));

		$update = $pre.'(?:\/?|(?P<id>'.$this->idRegex.'))(?:|\/.*)$/i';
		if ($this->overrideUpdateRegex) $update = $this->overrideUpdateRegex;
		$router->put($create, array($this, 'update'));

		$delete = $byId;
		if ($this->overrideDeleteRegex) $delete = $this->overrideDeleteRegex;
		$router->delete($delete, array($this, 'delete'));
	}

	/** List all elements in this model */
	public abstract function index($req, $res);

	/** Get one element of this model */
	public abstract function get($req, $res);

	/** Create one element in this model */
	public abstract function create($req, $res);

	/** Update one element in this model */
	public abstract function update($req, $res);

	/** Delete one element in this model */
	public abstract function delete($req, $res);
}



/*******************************************************************************
 * Example application
 ****************************************/


$app = new Router();


/* Matches /event/:id */
$regex = '/^\/event\/(?P<id>[0-9]+)(?:|\/.*)$/';

/** Get events for a month */
function getEvent($req, $res) {
	$res->sendData(array(
		'title' => 'You wanted this data...',
		'id' => $req->param('id'),
		'allParams' => $req->params
	));
}
$app->get($regex, 'getEvent');

/** Create an event */
function postEvent($req, $res) {}
$app->post($regex, 'postEvent');


/** Update an event */
function putEvent($req, $res) {}
$app->put($regex, 'putEvent');

/** Delete an event */
function deleteEvent($req, $res) {}
$app->delete($regex, 'deleteEvent');

/** Retrieve all events between start time and end time. */
function getEvents($req, $res) {
	$res->sendData($req->params);
}
/* Matches /events/:start(/:end(/*)) */
$app->get('/^\/events\/(?P<start>[0-9]+)(?:|\/(?P<end>[0-9]+)(?:|\/.*))$/', 'getEvents');


class SongsModel extends Model {

	public function get($req, $res) {
		$res->sendData('You wanted a specific song? ' . $req->param('id') . ' by the way.');
	}


	public $overrideIndexRegex = '/\/songs\/(?P<genre>[[:alnum:]]+)(?:|\/.*)$/i';

	public function index($req, $res) {
		$res->sendData("You wanted to listen to " . $req->param('genre'));
	}


	public function update($req, $res) {}
	public function delete($req, $res) {}
	public function create($req, $res) {}
}

$songs = new SongsModel($app);

$app->run();

