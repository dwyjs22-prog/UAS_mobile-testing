<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pasien extends Model
{
    use HasFactory;

    protected $table = 'pasiens';
    protected $primaryKey = 'idpasien';

    // ⬅️ auto increment INTEGER (DEFAULT, tapi kita jelaskan biar jelas)
    public $incrementing = true;
    protected $keyType = 'int';

    protected $fillable = [
        'nama',
        'umur',
        'alamat'
    ];

    protected $hidden = [
        'created_at',
        'updated_at',
    ];
}