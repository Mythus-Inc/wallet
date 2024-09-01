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
          final double appBarHeight = AppBar().preferredSize.height;
          final double footerHeight = 40.0; // Adjust to match Footer height
          final double additionalSpacing = 16.0; // Space between carousel and buttons
          final double carouselHeight = screenHeight - appBarHeight - footerHeight - additionalSpacing - 50.0; // Adjusted for button height

          return Column(
            children: [
              Container(
                height: carouselHeight,
                child: CarouselWidget(), // Carousel takes up the defined height
              ),
              SizedBox(height: 50), // Space between carousel and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center buttons horizontally
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // exportar para pdf
                    },
                    child: Text('Exportar para PDF'),
                  ),
                ],
              ),
              Spacer(), // Pushes the footer to the bottom
            ],
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
      color: Colors.white, 
      child: PageView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildCarouselItem(Colors.blueAccent, 'Carteirinha'),
          _buildCarouselItem(Colors.greenAccent, 'QR Code'),
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
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}