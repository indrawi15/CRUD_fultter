import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../database/database_helper.dart';

class BiodataScreen extends StatefulWidget {
  @override
  _BiodataScreenState createState() => _BiodataScreenState();
}

class _BiodataScreenState extends State<BiodataScreen> {
  final dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> biodataList = [];

  // Variable to hold the image file
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    fetchBiodata();
  }

  void fetchBiodata() async {
    try {
      final data = await dbHelper.queryAllBiodata();
      print("Data fetched: $data"); // Debug log
      setState(() {
        biodataList = data;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  // Function to pick an image using image picker
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void showBiodataForm({Map<String, dynamic>? biodata}) {
    final nameController = TextEditingController(text: biodata?['name'] ?? '');
    final addressController = TextEditingController(text: biodata?['address'] ?? '');
    final phoneController = TextEditingController(text: biodata?['phone'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(biodata == null ? "Tambah Biodata" : "Edit Biodata"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display selected image in a circle
            GestureDetector(
              onTap: _pickImage, // Open image picker on tap
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null
                    ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                    : null,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: "Alamat"),
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Telepon"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              final name = nameController.text;
              final address = addressController.text;
              final phone = phoneController.text;

              if (name.isEmpty || address.isEmpty || phone.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Semua field harus diisi!")),
                );
                return;
              }

              // Handle the image upload (this is just an example, save to the database as needed)
              final imagePath = _imageFile?.path ?? '';

              if (biodata == null) {
                await dbHelper.insertBiodata({
                  'name': name,
                  'address': address,
                  'phone': phone,
                  'photo': imagePath, // Save image path in database
                });
              } else {
                await dbHelper.updateBiodata({
                  'id': biodata['id'],
                  'name': name,
                  'address': address,
                  'phone': phone,
                  'photo': imagePath, // Update image path in database
                });
              }

              fetchBiodata();
              Navigator.pop(context);
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CRUD Biodata")),
      body: biodataList.isEmpty
          ? Center(child: Text("Belum ada data. Tambahkan biodata baru!"))
          : ListView.builder(
        itemCount: biodataList.length,
        itemBuilder: (context, index) {
          final biodata = biodataList[index];
          return ListTile(
            leading: biodata['photo'] != null && biodata['photo'].isNotEmpty
                ? ClipOval(
              child: Image.file(
                File(biodata['photo']),
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            )
                : Icon(Icons.account_circle, size: 50),
            title: Text(biodata['name'] ?? "Nama tidak ada"),
            subtitle: Text(
              "${biodata['address'] ?? "Alamat tidak ada"} - ${biodata['phone'] ?? "Telepon tidak ada"}",
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => showBiodataForm(biodata: biodata),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await dbHelper.deleteBiodata(biodata['id']);
                    fetchBiodata();
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showBiodataForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
