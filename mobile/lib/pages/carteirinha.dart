import 'dart:io';  // Para usar File
import 'package:flutter/material.dart';
import 'package:wallet_mobile/dto/dto_aluno_login.dart';
import 'package:wallet_mobile/pages/login.dart';
import 'package:wallet_mobile/service/aluno_service.dart';
import '../components/header.dart';
import '../components/footer.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os dados.'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final DtoalunoLogin aluno = snapshot.data!;
            final String curso = (aluno.alunoTurma != null && aluno.alunoTurma!.isNotEmpty)
                ? aluno.alunoTurma!.first.curso ?? 'Curso não disponível'
                : 'Curso não disponível';
            final String ingresso = (aluno.alunoTurma != null && aluno.alunoTurma!.isNotEmpty)
                ? aluno.alunoTurma!.first.dataMatricula ?? 'Data da matrícula não disponível'
                : 'Data da matrícula não disponível';
            final String validade = (aluno.alunoTurma != null && aluno.alunoTurma!.isNotEmpty)
                ? aluno.alunoTurma!.first.validade ?? 'Data da validade não disponível'
                : 'Data da validade não disponível';

            final Map<String, String> idInformation = {
              'nome': aluno.nome ?? 'Nome não disponível',
              'curso': curso,
              'ra': aluno.ra,
              'ingresso': ingresso,
              'validade': validade,
            };

            // Obtendo o caminho da foto do aluno
            final String? caminhoFoto = aluno.foto; // Verifique se aluno.foto contém o caminho

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
                      child: CarouselWidget(
                        idInformation: idInformation,
                        caminhoFoto: caminhoFoto,  // Passando o caminho da foto
                      ),
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
  final String? caminhoFoto;  // Recebendo o caminho da foto

  CarouselWidget({required this.idInformation, this.caminhoFoto});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      color: Colors.white,
      child: PageView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          _buildInfoItem(idInformation), // Primeiro item mostra as informações do ID
          _buildQRCodeItem(idInformation['ra'] ?? ''), // Segundo item mostra o QR code
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
          quarterTurns: 3, // Rotaciona 270 graus (anti-horário)
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 200,
                child: Container(
                  width: 130, // Largura da imagem
                  height: 130, // Altura da imagem
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: (caminhoFoto != null && File(caminhoFoto!).existsSync())
                          ? FileImage(File(caminhoFoto!))  // Usando o caminho da foto
                          : AssetImage('assets/app/default_image.png') as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 25.0, top: 30.0),
                child: Column(
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

  Widget _buildQRCodeItem(String ra) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          width: 250.0,
          height: 250.0,
          child: PrettyQrView.data(
            data: "$ra - Carteirinha Aprovada",
            errorCorrectLevel: QrErrorCorrectLevel.M,
            decoration: PrettyQrDecoration(
              shape: PrettyQrSmoothSymbol(),
              image: PrettyQrDecorationImage(
                image: AssetImage('assets/app/ifprlogosmall.png'),
                position: PrettyQrDecorationImagePosition.embedded,
                scale: 0.2,
                fit: BoxFit.contain,
                padding: EdgeInsets.all(50),
              ),
            ),
          ),
        ),
      ),
    );
  }
}