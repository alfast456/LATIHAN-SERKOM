import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_serkom/firebase_options.dart';

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
                  ],
                  rows: querySnapshot.docs
                      .map((document) => DataRow(cells: [
                            DataCell(Text(document['namaText'])),
                            DataCell(Text(document['alamatText'])),
                            DataCell(Text(document['nohpText'])),
                            DataCell(Text(document['_pilihJK'])),
                            DataCell(Text(document['_getLocation'])),
                          ]))
                      .toList(),
                ),
              ),
      ),
    );
  }
}
