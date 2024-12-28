import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'triangle_area_screen.dart';
import 'biodata_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("Menu", style: TextStyle(fontSize: 24)),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text("Hitung Luas Segitiga"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TriangleAreaScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text("CRUD Biodata"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BiodataScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          "Selamat datang di Home Screen!",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
