import 'package:flutter/material.dart';
import '../components/header.dart'; // Importa o Header
import '../components/footer.dart'; // Importa o Footer

class CarteirinhaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Wallet - IFPR',), // Header importado
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.white, // Cor de fundo para o restante da tela
            ),
          ),
          Center(
            child: CarouselWidget(), // Carrossel no meio
          ),
        ],
      ),
      bottomNavigationBar: Footer(), // Footer importado
    );
  }
}

class CarouselWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0, // Largura do carrossel
      height: 200.0, // Altura do carrossel
      child: PageView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildCarouselItem(const Color.fromARGB(255, 173, 149, 149), 'Carteirinha'),
          _buildCarouselItem(const Color.fromARGB(255, 173, 149, 149), 'QR Code'),
        ],
      ),
    );
  }

  Widget _buildCarouselItem(Color color, String text) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
    );
  }
}
