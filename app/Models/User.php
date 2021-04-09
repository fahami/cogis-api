<?php

namespace App\Models;

use Illuminate\Auth\Authenticatable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Contracts\Auth\Access\Authorizable as AuthorizableContract;
use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
use Laravel\Lumen\Auth\Authorizable;


class User extends Model implements AuthenticatableContract, AuthorizableContract
{
    use Authorizable, Authenticatable;
    protected $primaryKey = 'id_user';
    protected $guarded = [];
    protected $hidden = [
        'pwd',
    ];
}
