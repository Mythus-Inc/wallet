
import 'package:flutter/material.dart';
import 'package:wallet_mobile/pages/biometric_page.dart';
class Routes {
  static Map<String, Widget Function(BuildContext)> list = <String, WidgetBuilder>{
    '/biometric' : (_) => const BiometricPage(),
    
  };

  static String biometric = '/biometric';
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
  static NavigatorState to = Routes.navigatorKey!.currentState!;

}

