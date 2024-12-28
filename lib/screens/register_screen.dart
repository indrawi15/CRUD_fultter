import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Simpan username/password (contoh untuk SQLite bisa dimodifikasi)
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setString('username', usernameController.text);
                await prefs.setString('password', passwordController.text);
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text("Register"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text("Sudah punya akun? Login di sini"),
            ),
          ],
        ),
      ),
    );
  }
}
