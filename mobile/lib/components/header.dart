// header.dart
import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  Header({
    required this.title,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(50.0)),
      child: AppBar(
        title: Text(title),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: onBackPressed ?? () {
            Navigator.of(context).pop(); // Ação padrão de voltar
          },
        ),
        backgroundColor: Colors.green,
        elevation: 4.0,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
