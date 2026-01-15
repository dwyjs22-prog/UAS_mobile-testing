<?php

namespace App\Http\Controllers;

use App\Models\Pasien;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PasienController extends Controller
{
    private function formatResponse($data, $code = 200, $status = true)
    {
        return response()->json([
            'code' => (int) $code,
            'status' => $status,
            'data' => $data
        ], $code);
    }

    // 🔹 GET semua pasien
    public function index()
    {
        $data = Pasien::all();
        return $this->formatResponse($data);
    }

    // 🔹 POST tambah pasien
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama'   => 'required',
            'umur'   => 'required|integer',
            'alamat' => 'required',
        ]);

        if ($validator->fails()) {
            return $this->formatResponse(
                $validator->errors()->first(),
                422,
                false
            );
        }

        $pasien = Pasien::create([
            'nama'   => $request->nama,
            'umur'   => $request->umur,
            'alamat' => $request->alamat,
        ]);

        return $this->formatResponse([
            'message' => 'Data pasien berhasil ditambahkan',
            'data'    => $pasien
        ], 201);
    }

    // 🔹 GET pasien by ID
    public function show($idpasien)
    {
        $pasien = Pasien::find($idpasien);

        if (!$pasien) {
            return $this->formatResponse(
                'Pasien tidak ditemukan',
                404,
                false
            );
        }

        return $this->formatResponse($pasien);
    }

    // 🔹 PUT update pasien
    public function update(Request $request, $idpasien)
    {
        $pasien = Pasien::find($idpasien);

        if (!$pasien) {
            return $this->formatResponse(
                'Pasien tidak ditemukan',
                404,
                false
            );
        }

        $validator = Validator::make($request->all(), [
            'nama'   => 'required',
            'umur'   => 'required|integer',
            'alamat' => 'required',
        ]);

        if ($validator->fails()) {
            return $this->formatResponse(
                $validator->errors()->first(),
                422,
                false
            );
        }

        $pasien->update([
            'nama'   => $request->nama,
            'umur'   => $request->umur,
            'alamat' => $request->alamat,
        ]);

        return $this->formatResponse([
            'message' => 'Data pasien berhasil diupdate',
            'data'    => $pasien
        ]);
    }

    // 🔹 DELETE pasien
    public function destroy($idpasien)
    {
        $pasien = Pasien::find($idpasien);

        if (!$pasien) {
            return $this->formatResponse(
                'Pasien tidak ditemukan',
                404,
                false
            );
        }

        $pasien->delete();

        return $this->formatResponse(
            'Data pasien berhasil dihapus'
        );
    }
}