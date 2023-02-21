import 'package:flutter/material.dart';
import 'package:flutter_serkom/screen/registerform.dart';

void main() {
  runApp(const home());
}

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: registerform(),
    );
  }
}
