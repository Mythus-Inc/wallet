import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';

class CarteirinhaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: 'Wallet - IFPR',
        onBackPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenHeight = constraints.maxHeight;
          final double appBarHeight = AppBar().preferredSize.height; // altura padrão do AppBar
          final double footerHeight = 20.0; // Height of the Footer
          final double additionalSpacing = 5.0; // espaço para adicionar os botões
          final double carouselHeight = (screenHeight - appBarHeight - footerHeight - additionalSpacing);

          return Container(
            color: Colors.white, // Set the background color to match the carousel
            child: Column(
              children: [
                Container(
                  height: carouselHeight,
                  child: Center(
                    child: CarouselWidget(), // Carousel takes up the defined height
                  ),
                ),
                SizedBox(height: additionalSpacing), // Adds space between the carousel and footer
                Spacer(), // Fills the remaining space to push the footer to the bottom
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Footer(), // Footer remains fixed at the bottom
    );
  }
}

class CarouselWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width; // Get screen width

    return Container(
      width: screenWidth, // Set carousel width to screen width
      color: Colors.white, // Set the same color as the background of the screen
      child: PageView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildCarouselItem(Colors.white, 'Carteirinha'),
          _buildCarouselItem(Colors.white, 'QR Code'),
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
