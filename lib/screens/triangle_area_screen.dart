import 'package:flutter/material.dart';

class TriangleAreaScreen extends StatelessWidget {
  final TextEditingController baseController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hitung Luas Segitiga")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: baseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Masukkan Alas (cm)"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Masukkan Tinggi (cm)"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final base = double.tryParse(baseController.text);
                final height = double.tryParse(heightController.text);

                if (base == null || height == null || base <= 0 || height <= 0) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Error"),
                      content: Text("Masukkan angka yang valid untuk alas dan tinggi."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                final area = 0.5 * base * height;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Hasil"),
                    content: Text("Luas segitiga adalah ${area.toStringAsFixed(2)} cm²"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Hitung Luas"),
            ),
          ],
        ),
      ),
    );
  }
}
