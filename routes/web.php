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
$router->post('register', 'UserController@register');
$router->post('login', 'UserController@login');
$router->group(['prefix' => 'user', 'middleware' => 'auth'], function () use ($router) {
    $router->delete('/{id}', 'UserController@delete');
    $router->get('/{id}', 'UserController@find');
    $router->get('/', 'UserController@index');
    $router->put('/state', 'UserController@updatestate');
    $router->put('/{id}', 'UserController@update');
});

$router->group(['prefix' => 'node', 'middleware' => 'auth'], function () use ($router) {
    $router->get('/geojson', 'NodeController@geojson');
    $router->get('/admin', 'NodeController@details');
    $router->get('/{id}', 'NodeController@find');
    $router->get('/', 'NodeController@index');
});

$router->group(['prefix' => 'scan', 'middleware' => 'auth'], function () use ($router) {
    $router->post('/date', 'ScanController@range');
    $router->post('/{id}', 'ScanController@add');
    $router->get('/{id}', 'ScanController@find');
    $router->get('/', 'ScanController@index');
});
