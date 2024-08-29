import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)), 
      child: Container(
        color: Colors.green,
        height: 40.0, // Altura do footer
        child: Center(
          child: Text(
            '2024 © Mythus All rights reserved',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.0,
            ),
          ),
        ),
     ),
    );
  }
}

