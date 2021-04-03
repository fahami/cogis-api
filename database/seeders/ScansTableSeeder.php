<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Faker\Factory as Faker;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class ScansTableSeeder extends Seeder
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
            DB::table('scans')->insert([
                'id_area' => $faker->numberBetween(1, 5),
                'lat' => $faker->latitude,
                'lng' => $faker->longitude,
                'rssi' => $faker->numberBetween(-70, -35),
                'id_user' => $faker->numberBetween(1, 80),
                'id_slave' => $faker->numberBetween(1, 80),
                'scan_date' => $faker->dateTimeBetween($startDate = '-5 months', $endDate = 'now')
            ]);
        }
    }
}
