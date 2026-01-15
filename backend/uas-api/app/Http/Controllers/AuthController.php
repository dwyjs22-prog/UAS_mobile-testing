<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    // 🔹 Helper response (rapi & konsisten)
    private function formatResponse($data, $code = 200, $status = true)
    {
        return response()->json([
            'code' => (int) $code,
            'status' => $status,
            'data' => $data
        ], $code);
    }

    // ================= REGISTER =================
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama'     => 'required|string|max:255',
            'email'    => 'required|email|unique:users,email',
            'password' => 'required|min:6'
        ]);

        if ($validator->fails()) {
            return $this->formatResponse(
                $validator->errors()->first(),
                422,
                false
            );
        }

        $user = User::create([
            'name'     => $request->nama,
            'email'    => $request->email,
            'password' => Hash::make($request->password),
        ]);

        return $this->formatResponse([
            'message' => 'Registrasi berhasil',
            'user' => [
                'id'    => $user->id,
                'name'  => $user->name,
                'email' => $user->email
            ]
        ]);
    }

    // ================= LOGIN =================
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'    => 'required|email',
            'password' => 'required'
        ]);

        if ($validator->fails()) {
            return $this->formatResponse(
                $validator->errors()->first(),
                422,
                false
            );
        }

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return $this->formatResponse(
                'Email atau password salah',
                401,
                false
            );
        }

        // 🔐 Token Sanctum
        $token = $user->createToken('api-token')->plainTextToken;

        return $this->formatResponse([
            'token' => $token,
            'user' => [
                'id'    => $user->id,
                'name'  => $user->name,
                'email' => $user->email,
            ]
        ]);
    }

    // ================= LOGOUT (opsional) =================
    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();

        return $this->formatResponse('Logout berhasil');
    }
}