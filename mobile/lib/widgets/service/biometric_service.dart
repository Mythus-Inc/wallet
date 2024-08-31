import 'package:local_auth/local_auth.dart';

class BiometricService { //utilizar extends ChangeNotifier quando for salvar um objeto

  final LocalAuthentication auth = LocalAuthentication();

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

  Future<bool> authenticate() async {
    return await auth.authenticate(
      localizedReason: 'Por favor, autentique-se para acessar o app.',
      options: const AuthenticationOptions(
          biometricOnly: true,     
          useErrorDialogs: true,   
          stickyAuth: true,        
      ),
    ); 
  }
}