<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Auth\Access\Response;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class UserController extends Controller
{
    public function index()
    {
        $user = User::all();
        return response()->json($user);
    }
    public function create(Request $request)
    {
        $user = new User();
        $user->name = $request->input('name');
        $user->address = $request->input('address');
        $user->state = $request->input('state');
        $user->phone = $request->input('phone');
        $user->pwd = Hash::make($request->input('pwd'));
        $user->api_token = Str::random(40);
        $user->save();
        return response()->json(['status' => 200, 'data' => $user]);
    }
    public function find($id)
    {
        $user = User::find($id);
        return response()->json($user);
    }
    public function delete($id)
    {
        $user = User::find($id);
        $user->delete();
        return response()->json($user);
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
        return response()->json(['status' => 200]);
    }
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|numeric|exists:users,phone',
            'pwd' => 'required|string|min:6'
        ]);
        if ($validator->fails()) {
            return response()->json(['status' => 400]);
        }
        $user = User::where('phone', $request->phone)->first();
        if ($user && Hash::check($request->pwd, $user->pwd)) {
            $token = Str::random(40);
            $user->update(['api_token' => $token]);
            return response()->json([
                'status' => 200,
                'data' => [
                    'id' => $user->id_user,
                    'name' => $user->name,
                    'api_token' => $token,
                ]
            ]);
        }
        return response()->json(['status' => 404]);
    }
    public function geojson()
    {
        $user = DB::table('users')->select('lat', 'lng')->get();
        $user->map(function ($data) {
            $data->type = "Feature";
            $data->geometry = (object) [
                "type" => "Point",
                "coordinates" => [
                    floatval($data->lat),
                    floatval($data->lng),
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
