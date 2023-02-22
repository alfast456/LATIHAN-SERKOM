import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_serkom/firebase_options.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TablePage extends StatefulWidget {
  const TablePage({super.key});

  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late QuerySnapshot querySnapshot;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    querySnapshot = await firestore.collection('serkom').get();
    // print(foto);
    // cred = credentials.Certificate('path/to/serviceAccountKey.json');
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabel Data Serkom'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Nama')),
                    DataColumn(label: Text('Alamat')),
                    DataColumn(label: Text('No. HP')),
                    DataColumn(label: Text('Jenis Kelamin')),
                    DataColumn(label: Text('Lokasi')),
                    DataColumn(label: Text('Foto')),
                  ],
                  rows: querySnapshot.docs
                      .map((document) => DataRow(
                            cells: [
                              DataCell(Text(document['namaText'])),
                              DataCell(Text(document['alamatText'])),
                              DataCell(Text(document['nohpText'])),
                              DataCell(Text(document['_pilihJK'])),
                              DataCell(Text(document['_getLocation'])),
                              DataCell(FutureBuilder<String>(
                                future: FirebaseStorage.instance
                                    .ref()
                                    .child('serkom')
                                    .child(document['namaText'] + '.jpg')
                                    .getDownloadURL(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Image.network(snapshot.data!);
                                  } else if (snapshot.hasError) {
                                    return Text('Error : ${snapshot.error}');
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                              )),
                            ],
                          ))
                      .toList(),
                ),
              ),
      ),
    );
  }
}
