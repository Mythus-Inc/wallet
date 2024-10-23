import 'package:flutter/material.dart';
import 'package:wallet_mobile/dto/dto_aluno_login.dart';
import 'package:wallet_mobile/pages/login.dart';
import 'package:wallet_mobile/service/aluno_service.dart';
import '../components/header.dart';
import '../components/footer.dart';

class CarteirinhaPage extends StatelessWidget {
  Future<DtoalunoLogin?> dadosAluno = AlunoService.recuperarAlunoSalvo();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        title: 'Wallet - IFPR',
        onBackPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ),
      body: FutureBuilder<DtoalunoLogin?>(
        future: dadosAluno, // O Future que será resolvido
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Enquanto os dados estão carregando, exibe um indicador de progresso
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Se ocorreu algum erro, exibe uma mensagem de erro
            return Center(child: Text('Erro ao carregar os dados.'));
          } else if (snapshot.hasData && snapshot.data != null) {
            // Quando os dados forem carregados, atualize o idInformation
            final DtoalunoLogin aluno = snapshot.data!;
            final String curso = (aluno.alunoTurma != null && aluno.alunoTurma!.isNotEmpty) ? aluno.alunoTurma!.first.curso ?? 'Curso não disponível' : 'Curso não disponível';
            final String ingresso = (aluno.alunoTurma != null && aluno.alunoTurma!.isNotEmpty) ? aluno.alunoTurma!.first.dataMatricula ?? 'data da matricula não disponível' : 'data da matricula não disponível';
            final String validade = (aluno.alunoTurma != null && aluno.alunoTurma!.isNotEmpty) ? aluno.alunoTurma!.first.validade ?? 'data da validade não disponível' : 'data da validade não disponível';
            
            final Map<String, String> idInformation = {
              'nome': aluno.nome ?? 'Nome não disponível',
              'curso': curso,
              'ra': aluno.ra,
              'ingresso': ingresso,
              'validade': validade,
            };

            // Aqui construa o layout da página com os dados do aluno
            return LayoutBuilder(
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
                      child: CarouselWidget(idInformation: idInformation),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Adicione funcionalidade para exportar para PDF
                          },
                          child: Text('Exportar para PDF'),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                );
              },
            );
          } else {
            // Caso os dados sejam nulos ou não sejam carregados corretamente
            return Center(child: Text('Nenhum dado disponível.'));
          }
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
              Positioned(
                top: -15, // Adjust this to move the image vertically
                left: 220, // Adjust this to move the image horizontally
                child: Container(
                  width: 130, // Width of the image
                  height: 130, // Height of the image
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(8), // Optional: add border radius
                    image: DecorationImage(
                      image: AssetImage(
                        'mobile/assets/app/ifprLogo.png'), // Replace with your image path
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -25, // Adjust this to move the image vertically
                left: 30, // Adjust this to move the image horizontally
                child: Container(
                  width: 160, // Width of the image
                  height: 160, // Height of the image
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(8), // Optional: add border radius
                    image: DecorationImage(
                      image: AssetImage(
                          '../../assets/app/brasao.png'), // Replace with your image path
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20, // Adjust this to move the text vertically
                left: 385, // Adjust this to move the text horizontally
                child: Text(
                  'IDENTIDADE\nESTUDANTIL', // Your new text
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                top: 170, // Adjust this to move the placeholder vertically
                left: 320, // Adjust this to move the placeholder horizontally
                child: Container(
                  width: 150, // Width of the placeholder
                  height: 200, // Height of the placeholder
                  color:
                      Colors.grey[300], // Background color of the placeholder
                  child: Center(
                    child: Icon(
                      Icons.image, // Icon representing the image placeholder
                      color: Colors.grey[700],
                      size: 50, // Size of the icon
                    ),
                  ),
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
