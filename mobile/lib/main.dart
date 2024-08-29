import 'package:flutter/material.dart';
import 'pages/carteirinha.dart'; // Importe o arquivo da página

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CarteirinhaPage(), // Defina CarteirinhaPage como home
    );
  }
}
