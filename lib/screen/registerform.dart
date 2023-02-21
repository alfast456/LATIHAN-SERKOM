import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
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
  late String _location;
  late File _image;
  String _JK = "";

  @override
  void initState() {
    super.initState();
    _getLocation();
    _getImage();
  }

  Future<void> _getLocation() async {
    // mendapatkan lokasi GPS menggunakan package geolocator
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _location = "${position.latitude}, ${position.longitude}";
    // lalu disimpan ke dalam variabel _location
  }

  Future<void> _getImage() async {
    // mengambil gambar dari galeri menggunakan package image_picker
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _pilihJK(String? value) {
    setState(() {
      _JK = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    AdapterS.size(context: context);
    TextEditingController? namaText;
    TextEditingController? alamatText;
    TextEditingController? nohpText;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 40, left: 40, right: 40),
        child: Form(
          child: SizedBox(
            width: AdapterS.screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("Form Pendaftaran TOEFL"),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: labelText(
                      fieldLabel: "Nama", textController: namaText, size: 128),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: labelText(
                      fieldLabel: "Alamat lengkap",
                      textController: alamatText,
                      size: 128),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: labelText(
                      fieldLabel: "No. HP",
                      textController: nohpText,
                      size: 128),
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
                                  title: Text("Foto Anda"),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
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
