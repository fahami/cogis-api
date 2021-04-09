<?php

namespace App\Http\Controllers;

use App\Models\Scan;
use Illuminate\Http\Request;

class ScanController extends Controller
{
    public function index()
    {
        $scan = Scan::all('id_user', 'id_slave', 'scan_date');
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
        $scan = Scan::find($id, ['id_user', 'id_slave', 'scan_date']);
        $res = (object)[
            'from' => $scan->id_user,
            'to' => $scan->id_slave,
            'label' => $scan->scan_date
        ];
        return response()->json($res, 200);
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
