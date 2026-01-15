<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\PasienController;
use Illuminate\Support\Facades\Route;

// ================= AUTH =================
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// ================= PASIEN (UNTUK UAS → PUBLIC) =================
Route::get('/pasien', [PasienController::class, 'index']);
Route::post('/pasien', [PasienController::class, 'store']);
Route::get('/pasien/{idpasien}', [PasienController::class, 'show']);
Route::put('/pasien/{idpasien}', [PasienController::class, 'update']);
Route::delete('/pasien/{idpasien}', [PasienController::class, 'destroy']);
