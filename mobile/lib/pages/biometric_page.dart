import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:wallet_mobile/pages/home.dart';
import 'package:wallet_mobile/widgets/service/biometric_service.dart';

class BiometricPage extends StatefulWidget {
  const BiometricPage({super.key});
  @override
  State<BiometricPage> createState() => _BiometricPageState();
}



class _BiometricPageState extends State<BiometricPage> {
  late BiometricService biometricService;
  bool isAuthenticated = false;
  
  @override
  void initState() {
    super.initState();
    biometricService = BiometricService();
    biometricService.autenticar();
    authenticateUser();
  }

  Future<void> authenticateUser() async {
    isAuthenticated = await biometricService.authenticate();
    if (isAuthenticated) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Home()),
      );
    } 
  }

  @override
  Widget build(BuildContext context) { // no lugar do build dev ser a página de Login
    return Scaffold(
      appBar: AppBar(
        title: Text("Autentique-se"),
      ),
      body: Container(child: Center(child: Text("Use a digital para se autenticar")),),
    );
  }
}