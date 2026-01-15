import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class PasienEditPage extends StatefulWidget {
  const PasienEditPage({super.key});

  @override
  State<PasienEditPage> createState() => _PasienEditPageState();
}

class _PasienEditPageState extends State<PasienEditPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController umurController;
  late TextEditingController alamatController;

  bool isLoading = false;
  late int idPasien;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map data =
        ModalRoute.of(context)!.settings.arguments as Map;

    idPasien = data['idpasien'];

    namaController = TextEditingController(text: data['nama']);
    umurController =
        TextEditingController(text: data['umur'].toString());
    alamatController = TextEditingController(text: data['alamat']);
  }

  // 🔹 UPDATE pasien
  Future<void> updatePasien() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final response = await http.put(
      Uri.parse('${Api.baseUrl}/pasien/$idPasien'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': namaController.text,
        'umur': umurController.text,
        'alamat': alamatController.text,
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data pasien berhasil diperbarui')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Data Pasien',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Icon(
                    Icons.edit_note,
                    size: 80,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Perbarui Data Pasien',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 🔤 NAMA
                  TextFormField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama Pasien',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? 'Nama wajib diisi' : null,
                  ),

                  const SizedBox(height: 16),

                  // 🔢 UMUR
                  TextFormField(
                    controller: umurController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Umur',
                      prefixIcon: const Icon(Icons.cake),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? 'Umur wajib diisi' : null,
                  ),

                  const SizedBox(height: 16),

                  // 🏠 ALAMAT
                  TextFormField(
                    controller: alamatController,
                    decoration: InputDecoration(
                      labelText: 'Alamat',
                      prefixIcon: const Icon(Icons.home),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (v) =>
                        v!.isEmpty ? 'Alamat wajib diisi' : null,
                  ),

                  const SizedBox(height: 28),

                  // 💾 BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: isLoading ? null : updatePasien,
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'SIMPAN PERUBAHAN',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
