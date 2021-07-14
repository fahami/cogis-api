<?php

namespace App\Http\Controllers;

use App\Models\Master;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class MasterController extends Controller
{
    public function index()
    {
        $user = Master::all();
        return response()->json($user, 200);
    }
    public function delete($id)
    {
        Master::find($id)->delete();
        return response()->json(['status' => 200, 'message' => 'User deleted'], 200);
    }
    public function update(Request $request)
    {
        $user = DB::table('masters')->latest()->first();
        $user->update([
            'threshold' => $request->threshold,
        ]);
        return response()->json(['status' => 200], 200);
    }
}
