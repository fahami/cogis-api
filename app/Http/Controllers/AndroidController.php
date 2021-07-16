<?php

namespace App\Http\Controllers;

use App\Models\Scan;
use Illuminate\Http\Request;

class AndroidController extends Controller
{
    public function find($id)
    {
        $scan = Scan::select('id_user', 'id_slave', 'scan_date', 'rssi', 'lat', 'lng')->where('id_user', $id)->orderBy('scan_date', 'desc')->get();
        $scan->map(function ($data) {
            $data->from = $data->id_user;
            $data->to = $data->id_slave;
            $data->date = $data->scan_date;
            $data->signal = $data->rssi;
            $data->location = [floatval($data->lat), floatval($data->lng)];
            unset($data->id_user, $data->id_slave, $data->scan_date, $data->rssi, $data->lat, $data->lng);
            return $data;
        });
        return response()->json($scan, 200);
    }
    public function marker($id)
    {
        $scan = Scan::select('lat', 'lng')->where('id_user', $id)->get();
        $scan->map(function ($data) {
            $data->location = [floatval($data->lat), floatval($data->lng)];
            unset($data->lat, $data->lng);
            return $data;
        });
        return response()->json($scan, 200);
    }
}
