<?php

namespace App\Http\Controllers;

use App\Models\Scan;
use App\Models\User;
use Illuminate\Support\Arr;

class NodeController extends Controller
{
    public function index()
    {
        $node = User::all('id_user', 'name', 'state');
        $node->map(function ($data) {
            $data->id = $data->id_user;
            $data->title = $data->name;
            $data->label = strval($data->id_user);
            $data->color = ($data->state == 2) ? '#FF0000' : '#00FF00';
            $data->shape = "box";
            unset($data->id_user);
            unset($data->name);
            unset($data->state);
            return $data;
        });
        return response()->json($node);
    }
    public function find($id)
    {
        $itself = User::select("id_user AS id", "lat", "lng", "name AS title")
            ->where("id_user", $id)
            ->get();

        $node = Scan::select("u2.lat", "u2.lng", "u2.id_user AS id", "u2.name AS title")
            ->join('users AS u1', "u1.id_user", "scans.id_user")
            ->join('users AS u2', "u2.id_user", "scans.id_slave")
            ->where("scans.id_user", $id)
            ->get();
        $merged = $itself->concat($node);
        $merged->map(function ($data) {
            $data->id;
            $data->title;
            $data->label = strval($data->id);
            $data->color = ($data->state == 2) ? '#FF0000' : '#00FF00';
            $data->coordinates = (array)[
                floatval($data->lat),
                floatval($data->lng)
            ];
            $data->shape = "box";
            unset($data->lat, $data->lng);
            return $data;
        });
        return response()->json($merged, 200);
    }
    public function details()
    {
        $node = User::all('id_user', 'state', 'phone', 'name');
        $node->map(function ($data) {
            $data->id = $data->id_user;
            $data->status = $data->state;
            unset($data->id_user);
            unset($data->state);
            return $data;
        });
        return response()->json($node, 200);
    }

    public function geojson()
    {
        $user = User::all('lat', 'lng');
        $user->map(function ($data) {
            $data->type = "Feature";
            $data->geometry = (object) [
                "type" => "Point",
                "coordinates" => [
                    floatval($data->lng),
                    floatval($data->lat),
                ]
            ];
            $data->properties = (object)[
                "icon" => "rocket"
            ];
            unset($data->lat);
            unset($data->lng);
            return $data;
        });
        return response()->json($user);
    }
}
