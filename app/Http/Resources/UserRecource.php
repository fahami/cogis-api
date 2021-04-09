<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    public function toArray($request)
    {
        return [
            'id' => $this->id_user,
            'phone' => $this->phone,
            'name' => $this->name,
            'status' => $this->state,
        ];
    }
}
