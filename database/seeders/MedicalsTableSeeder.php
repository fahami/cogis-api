<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Faker\Factory as Faker;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class MedicalsTableSeeder extends Seeder
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
            DB::table('medicals')->insert([
                'id_user' => $faker->numberBetween(1, $i),
                'suhu' => $faker->numberBetween(34, 37),
                'kondisi' => $faker->numberBetween(1, 3),
                'date' => $faker->dateTimeBetween('-5 months', 'now')
            ]);
        }
    }
}
