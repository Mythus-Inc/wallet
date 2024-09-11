import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService { //utilizar extends ChangeNotifier quando for salvar um objeto

  final LocalAuthentication auth = LocalAuthentication();
  
  autenticar() async {
    if (await isBiometricAvailable()){
        await getListBiometricsTypes();
        await authenticate();
    
    }
  }


  Future<bool> isBiometricAvailable() async {
    try{
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      return canAuthenticateWithBiometrics;
    }catch(e){
      return false;
    } 
  }

  Future<void> getListBiometricsTypes() async {
    List<BiometricType> listBiometricType = await auth.getAvailableBiometrics();
  }

  Future<bool> authenticate() async { // esse método pode causar uma exception, que deve ser corrigida
    bool auxAuthenticated = false;
    try{
        auxAuthenticated = await auth.authenticate(
        localizedReason: 'Utilize a digital para acessar o app.',
        options: const AuthenticationOptions(
            biometricOnly: true,     
            useErrorDialogs: true,   
            stickyAuth: true,        
        ),
      ); 
    } on PlatformException catch(e) {
      print(e);
    }
    return auxAuthenticated;
  }
}