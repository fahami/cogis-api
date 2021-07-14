<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class UserController extends Controller
{
    public function index()
    {
        $user = User::all();
        return response()->json($user, 200);
    }
    public function register(Request $request)
    {
        $user = new User();
        $user->name = $request->input('name');
        $user->address = $request->input('address');
        $user->state = $request->input('state');
        $user->phone = $request->input('phone');
        $user->pwd = Hash::make($request->input('pwd'));
        $user->api_token = Str::random(40);
        $user->save();
        return response()->json($user, 200);
    }
    public function find($id)
    {
        $user = User::find($id);
        return response()->json($user);
    }
    public function delete($id)
    {
        User::find($id)->delete();
        return response()->json(['status' => 200, 'message' => 'User deleted'], 200);
    }
    public function update(Request $request, $id)
    {
        $user = User::find($id);
        $user->update([
            'name' => $request->name,
            'address' => $request->address,
            'state' => $request->state,
            'lat' => $request->lat,
            'lng' => $request->lng
        ]);
        return response()->json(['status' => 200], 200);
    }
    public function updatestate(Request $request)
    {
        $user = User::where('phone', $request->phone)->first();
        $user->update([
            'state' => $request->state,
        ]);
        return response()->json(['status' => 200], 200);
    }
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|numeric|exists:users,phone',
            'pwd' => 'required|string|min:6'
        ]);
        if ($validator->fails()) {
            return response()->json(['status' => 400], 400);
        }
        $user = User::where('phone', $request->phone)->first();
        $thresholdVal = DB::table('masters')->latest()->value('threshold');
        if ($user && Hash::check($request->pwd, $user->pwd)) {
            $token = Str::random(40);
            $user->update(['api_token' => $token]);
            return response()->json([
                'id' => $user->id_user,
                'name' => $user->name,
                'api_token' => $token,
                'rssi' => $thresholdVal,
            ], 200);
        }
        return response()->json(['status' => 404], 404);
    }
}
