<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Faker\Factory as Faker;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class UsersTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $faker = Faker::create('id_ID');
        foreach (range(0, 100) as $i) {
            DB::table('users')->insert([
                'name' => $faker->name,
                'address' => $faker->address,
                'lat' => $faker->latitude,
                'lng' => $faker->longitude,
                'state' => $faker->numberBetween(1, 5),
                'phone' => $faker->e164PhoneNumber,
                'api_token' => Str::random(40),
                'pwd' => $faker->password(6, 20)
            ]);
        }
    }
}
