import 'package:local_auth/local_auth.dart';

class BiometricService{

  final LocalAuthentication auth;
  BiometricService({required this.auth});

  Future<bool> isBiometricAvailable() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    return canAuthenticateWithBiometrics || await auth.isDeviceSupported();
  }

  Future<bool> authenticate() async {
    return await auth.authenticate(
      localizedReason: 'Por favor, autentique-se para acessar o app.',
    );
  }

}