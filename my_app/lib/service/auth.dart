import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const secureStorage = FlutterSecureStorage();

const String baseUrl =
    'http://192.168.1.19:8000/api'; // Ganti IP dengan IP host laptop Anda

// Fungsi untuk mendapatkan header default
Future<Map<String, String>> getDefaultHeaders() async {
  final accessToken = await secureStorage.read(key: 'access_token');
  return {
    'Content-Type': 'application/json',
    if (accessToken != null) 'Authorization': 'Bearer $accessToken',
  };
}

// Fungsi untuk login
Future<void> login(String email, String password) async {
  final url = Uri.parse('$baseUrl/auth/login');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['token']['access_token'];

      // Simpan access token di secure storage
      await secureStorage.write(key: 'access_token', value: accessToken);
      print('Access token successfully stored!');
    } else {
      final error = json.decode(response.body);
      throw Exception('Login failed: ${error['message'] ?? 'Server error'}');
    }
  } catch (e) {
    throw Exception('Login failed: $e');
  }
}

// Fungsi untuk mengambil data pengguna yang terlindungi
Future<Map<String, dynamic>> fetchProtectedData() async {
  final url = Uri.parse('$baseUrl/user/me');
  final headers = await getDefaultHeaders();

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Berhasil mendapatkan data
      return json.decode(response.body) as Map<String, dynamic>;
    } else if (response.statusCode == 401) {
      // Token tidak valid atau sudah kedaluwarsa
      throw Exception('Invalid or expired access token. Please log in again.');
    } else {
      final error = json.decode(response.body);
      throw Exception('Error: ${error['message'] ?? 'Server error'}');
    }
  } catch (e) {
    throw Exception('An error occurred while fetching data: $e');
  }
}

// Fungsi untuk logout
Future<void> logout() async {
  try {
    // Hapus access token dari secure storage
    await secureStorage.delete(key: 'access_token');
    print('Access token successfully deleted.');
  } catch (e) {
    throw Exception('An error occurred while logging out: $e');
  }
}
