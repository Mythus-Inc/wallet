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
      'ra': '20220006500',
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
          final double carouselHeight = screenHeight - appBarHeight - footerHeight - additionalSpacing - 50.0;

          return Column(
            children: [
              Container(
                height: carouselHeight,
                child: CarouselWidget(idInformation: idInformation), // Pass ID info to the carousel
              ),
              SizedBox(height: 50),
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
      color: Colors.blueAccent,
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: RotatedBox(
          quarterTurns: 3, // Rotate 270 degrees (90 degrees counterclockwise)
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centers the column vertically
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the left
            children: [
              Text(
                '${info['nome']}',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              SizedBox(height: 10),
              Text(
                'Curso: ${info['curso']}',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'RA: ${info['ra']}',
                style: TextStyle(color: Colors.white, fontSize: 18),
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
          width: 500.0,  // Increase the width
          height: 500.0, // Increase the height
          child: Icon(Icons.qr_code, size: 250, color: Colors.black), // Make the QR code icon larger
        ),
      ),
    );
  }
}
