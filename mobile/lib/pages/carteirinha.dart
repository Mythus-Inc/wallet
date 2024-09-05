import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';

class CarteirinhaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Example data for the first carousel item
    final Map<String, String> idInformation = {
      'nome': 'Carla Santos de Oliveira',
      'curso': 'Engenharia de Software',
      'ra': '20220006519',
      'ingresso': '2022',
      'validade': '12/2025',
    };

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
          final double footerHeight = 40.0;
          final double additionalSpacing = 16.0;
          final double carouselHeight = screenHeight -
              appBarHeight -
              footerHeight -
              additionalSpacing +
              30.0;

          return Column(
            children: [
              Container(
                height: carouselHeight,
                child: CarouselWidget(
                    idInformation:
                        idInformation), // Pass ID info to the carousel
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality to export to PDF
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
      bottomNavigationBar: Footer(),
    );
  }
}

class CarouselWidget extends StatelessWidget {
  final Map<String, String> idInformation;

  CarouselWidget({required this.idInformation});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      color: Colors.white,
      child: PageView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildInfoItem(idInformation), // First item shows ID information
          _buildQRCodeItem(), // Second item shows a QR code
        ],
      ),
    );
  }

  Widget _buildInfoItem(Map<String, String> info) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: RotatedBox(
          quarterTurns: 3, // Rotate 270 degrees (90 degrees counterclockwise)
          child: Stack(
            children: [
              // Top border
              Positioned(
                top:
                    100, // Adjust this to control the distance from the first element
                left: 15,
                right: 15,
                child: Container(
                  height: 1.0, // Height of the border
                  color: Colors.grey, // Border color
                ),
              ),
              // Left border (red)
              Positioned(
                top: 0,
                bottom: 0,
                left: 0, // Position the red border on the left
                child: Container(
                  width: 5.0, // Width of the border
                  color: Colors.green, // Border color
                ),
              ),
              // Additional border (e.g., green) next to the red border
              Positioned(
                top: 0,
                bottom: 0,
                left: 10.0, // Position this border next to the red border
                child: Container(
                  width: 5.0, // Width of the additional border
                  color: Colors.red, // Color of the additional border
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                right: 0, // Position the red border on the left
                child: Container(
                  width: 5.0, // Width of the border
                  color: Colors.red, // Border color
                ),
              ),
              // Additional border (e.g., green) next to the red border
              Positioned(
                top: 0,
                bottom: 0,
                right: 10.0, // Position this border next to the red border
                child: Container(
                  width: 5.0, // Width of the additional border
                  color: Colors.green, // Color of the additional border
                ),
              ),
              Positioned(
                top: -80,
                bottom: 385,
                right: 150,
                child: Container(
                  width: 5.0, // Width of the border
                  color: Colors.green, // Border color
                ),
              ),
              Positioned(
                top: -80,
                bottom: 395,
                right: 140, // Position this border next to the red border
                child: Container(
                  width: 5.0, // Width of the additional border
                  color: Colors.red, // Color of the additional border
                ),
              ),

              //teste
              Positioned(
                top:
                    85, // Adjust this to control the distance from the first element
                left: 379,
                right: 15,
                child: Container(
                  height: 5.0, // Height of the border
                  color: Colors.red, // Border color
                ),
              ),
              Positioned(
                top:
                    95, // Adjust this to control the distance from the first element
                left: 368,
                right: 15,
                child: Container(
                  height: 5.0, // Height of the border
                  color: Colors.green, // Border color
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                    left: 25.0,
                    top:
                        30.0), // Adjust padding to avoid overlapping with the borders
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${info['nome']}',
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Curso: ${info['curso']}',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'RA: ${info['ra']}',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Ingresso: ${info['ingresso']}',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Validade: ${info['validade']}',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQRCodeItem() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          width: 500.0, // Increase the width
          height: 500.0, // Increase the height
          child: Icon(Icons.qr_code,
              size: 250, color: Colors.black), // Make the QR code icon larger
        ),
      ),
    );
  }
}
