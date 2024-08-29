
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wallet_mobile/routes/routes.dart';
import 'package:wallet_mobile/widgets/service/biometric_service.dart';
import 'package:provider/provider.dart';
class Biometric extends StatefulWidget{
  const Biometric({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _Biometric();
  
}

class _Biometric extends State<Biometric>{
  final ValueNotifier<bool> isNotAuthenticated = ValueNotifier(false);
  
  

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  checkAuthentication() async {
    final auth = context.read<BiometricService>();
    final isLocalAuthAvailable = await auth.isBiometricAvailable();
    isNotAuthenticated.value = false;

    if (isLocalAuthAvailable) {
      final authenticated = await auth.authenticate();

      if (!authenticated) {
        isNotAuthenticated.value = true;
      } else {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed(
          Routes.biometric// Routes.initial, tem que adicionar a rota para a página home e remover a rota da página de biometric
            
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ValueListenableBuilder<bool>(
        valueListenable: isNotAuthenticated,
        builder: (context, failed, _) {
          if (failed) {
            return Center(
              child: CustomButton(
                onPressed: (){},
                text: 'Tentar autenticar novamente',
              ),
            );
          }
          return Center(
            child: SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.deepPurple.shade400,
              ),
            ),
          );
        },
      ),
    );
  }
  
  CustomButton({required onPressed, required String text}) {}

}


