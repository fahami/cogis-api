<?php

/** @var \Laravel\Lumen\Routing\Router $router */

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It is a breeze. Simply tell Lumen the URIs it should respond to
| and give it the Closure to call when that URI is requested.
|
*/

$router->get('/', function () use ($router) {
    return $router->app->version();
});
$router->group(['middleware' => 'auth'], function () use ($router) {
    $router->get('api/user', 'UserController@index');
    $router->get('api/user/{id}', 'UserController@find');
    $router->put('api/user/{id}/', 'UserController@update');
    $router->delete('api/user/{id}/', 'UserController@delete');
    $router->get('api/geojson/', 'UserController@geojson');
});
$router->post('api/user', 'UserController@create');
$router->post('api/login', 'UserController@login');
