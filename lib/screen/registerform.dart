import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_serkom/utility/dimenResponsive.dart';
import 'package:flutter_serkom/widget/textlabel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class registerform extends StatefulWidget {
  const registerform({super.key});

  @override
  State<registerform> createState() => _registerformState();
}

class _registerformState extends State<registerform> {
  final _formKey = GlobalKey<FormState>();
  final namaText = TextEditingController();
  final alamatText = TextEditingController();
  final nohpText = TextEditingController();
  late String _location;
  late File _image;
  String _JK = "";

  @override
  void initState() {
    super.initState();
    // _getLocation();
    // _getImage();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // cek apakah GPS sudah aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // GPS belum aktif
      return Future.error('Location services are disabled.');
    }

    // cek apakah aplikasi sudah mendapatkan izin untuk mengakses lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // aplikasi belum mendapatkan izin untuk mengakses lokasi
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // pengguna menolak untuk memberikan izin
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // pengguna menolak untuk memberikan izin secara permanen
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _location = "${position.latitude}, ${position.longitude}";
    // lalu disimpan ke dalam variabel _location
  }

  void _pilihJK(String? value) {
    setState(() {
      _JK = value!;
    });
  }

  Future<void> _getImage() async {
    // mengambil gambar dari galeri menggunakan package image_picker
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    print("File: ${pickedFile?.path}");

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _submitForm() async {
    // proses submit form
    // print("Nama: ${namaText.text}");
    try {
      await FirebaseFirestore.instance.collection('serkom').add({
        'namaText': namaText.text,
        'alamatText': alamatText.text,
        'nohpText': nohpText.text,
        '_pilihJK': _JK,
        '_getLocation': _location,
      });
    } catch (e) {
      print("Error: $e");
    }

    // proses upload foto ke Firebase Storage
    try {
      if (_image != null) {
        // upload foto ke Firebase Storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('serkom')
            .child(namaText.text + '.jpg');
        await ref.putFile(_image);
        final url = await ref.getDownloadURL();
        print("URL: $url");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    AdapterS.size(context: context);
    // TextEditingController? namaText = TextEditingController();
    // TextEditingController? alamatText = TextEditingController();
    // TextEditingController? nohpText = TextEditingController();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 40, left: 40, right: 40),
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: AdapterS.screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Form Pendaftaran TOEFL"),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: TextField(
                    controller: namaText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nama Lengkap',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: TextField(
                    controller: alamatText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Alamat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: TextField(
                    controller: nohpText,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'No. HP',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Row(
                    children: <Widget>[
                      Text("Jenis Kelamin"),
                      Radio(
                        value: "Laki-laki",
                        groupValue: _JK,
                        onChanged: _pilihJK,
                      ),
                      Text("Laki-laki"),
                      Radio(
                        value: "Perempuan",
                        groupValue: _JK,
                        onChanged: _pilihJK,
                      ),
                      Text("Perempuan"),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Row(
                    children: <Widget>[
                      Text("Lokasi Pendaftaran : "),
                      ElevatedButton(
                        onPressed: () async {
                          await _getLocation();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Lokasi Anda"),
                                  content: Text('Lokasi saat ini: $_location'),
                                );
                              });
                        },
                        child: Text("Cek Lokasi Sekarang"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Row(
                    children: <Widget>[
                      Text("Upload Foto : "),
                      ElevatedButton(
                        onPressed: () async {
                          await _getImage();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Pilih Foto Anda"),
                                  content: Image.file(_image),
                                );
                              });
                        },
                        child: Text("Upload Foto"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                    onPressed: () async {
                      // print(namaText?.text.toString());
                      if (_formKey.currentState!.validate()) {
                        await _submitForm();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Processing Data")));
                      }
                    },
                    child: Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
