<?php

namespace App\Http\Controllers;

use App\Models\Scan;
use Illuminate\Http\Request;

class ScanController extends Controller
{
    public function index()
    {
        $scan = Scan::select('id_user', 'id_slave', 'scan_date')->orderBy('id_scan')->limit(100)->get();
        $scan->map(function ($data) {
            $data->from = $data->id_user;
            $data->to = $data->id_slave;
            $data->label = $data->scan_date;
            unset($data->id_user, $data->id_slave, $data->scan_date);
            return $data;
        });
        return response()->json($scan, 200);
    }
    public function find($id)
    {
        $scan = Scan::select('id_user', 'id_slave', 'scan_date')->where('id_user', $id)->get();
        $scan->map(function ($data) {
            $data->from = $data->id_user;
            $data->to = $data->id_slave;
            $data->label = $data->scan_date;
            unset($data->id_user, $data->id_slave, $data->scan_date);
            return $data;
        });
        return response()->json($scan, 200);
    }
    public function add(Request $request)
    {
        $scan = Scan::create($request->all());
        return response()->json($scan, 200);
    }
    public function range(Request $request)
    {
        $scan = Scan::select('id_user', 'id_slave', 'scan_date')
            ->whereBetween('scan_date', [$request->startDate, $request->endDate])
            ->get();
        $scan->map(function ($data) {
            $data->from = $data->id_user;
            $data->to = $data->id_slave;
            $data->label = $data->scan_date;
            unset($data->id_user, $data->id_slave, $data->scan_date);
            return $data;
        });
        return response()->json($scan, 200);
    }
}
