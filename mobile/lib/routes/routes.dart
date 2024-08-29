
import 'package:flutter/material.dart';
import 'package:wallet_mobile/widgets/biometric.dart';
class Routes {
  static Map<String, Widget Function(BuildContext)> list = <String, WidgetBuilder>{
    '/biometric' : (_) => const Biometric(),
    
  };

  static String biometric = '/biometric';
  static GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
  static NavigatorState to = Routes.navigatorKey!.currentState!;

}

