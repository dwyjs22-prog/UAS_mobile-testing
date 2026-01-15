import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api.dart';

class PasienListPage extends StatefulWidget {
  const PasienListPage({super.key});

  @override
  State<PasienListPage> createState() => _PasienListPageState();
}

class _PasienListPageState extends State<PasienListPage> {
  List pasien = [];
  bool isLoading = true;

  // 🔹 GET semua pasien
  Future<void> fetchPasien() async {
    setState(() => isLoading = true);

    final response = await http.get(
      Uri.parse('${Api.baseUrl}/pasien'),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        pasien = result['data'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  // 🔹 DELETE pasien
  Future<void> deletePasien(int id) async {
    final response = await http.delete(
      Uri.parse('${Api.baseUrl}/pasien/$id'),
    );

    if (response.statusCode == 200) {
      fetchPasien();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pasien berhasil dihapus')),
      );
    }
  }

  // 🔹 Dialog hapus
  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Pasien'),
        content: const Text('Yakin ingin menghapus data pasien ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              deletePasien(id);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // 🔹 Dialog logout
  void confirmLogout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchPasien();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Data Pasien',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: confirmLogout,
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pasien.isEmpty
              ? const Center(
                  child: Text(
                    'Data pasien kosong',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: pasien.length,
                  itemBuilder: (context, index) {
                    final item = pasien[index];

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            // 👤 ICON
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.green.shade100,
                              child: const Icon(
                                Icons.person,
                                color: Colors.green,
                              ),
                            ),

                            const SizedBox(width: 12),

                            // 📄 DATA
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['nama'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Umur : ${item['umur']}'),
                                  Text('Alamat : ${item['alamat']}'),
                                ],
                              ),
                            ),

                            // ✏️🗑️ ACTION
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () async {
                                    final result =
                                        await Navigator.pushNamed(
                                      context,
                                      '/edit',
                                      arguments: item,
                                    );
                                    if (result == true) {
                                      fetchPasien();
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () =>
                                      confirmDelete(item['idpasien']),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

      // ➕ FAB
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add');
          if (result == true) {
            fetchPasien();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
