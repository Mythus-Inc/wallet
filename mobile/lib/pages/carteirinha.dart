
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallet_mobile/dto/dto_aluno_login.dart';
import 'package:wallet_mobile/pages/login.dart';
import 'package:wallet_mobile/service/aluno_service.dart';
import '../components/header.dart';
import '../components/footer.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


Future<void> generatePDF(String nome, String curso, String anoEgresse, String validade, Uint8List? imagemAluno) async {
  final pdf = pw.Document();
  final String dataGeracao = DateTime.now().toLocal().toString().split(' ')[0];

  // Load institutional logo
  final ByteData ifprLogoData = await rootBundle.load('assets/app/ifprLogo.png');
  final Uint8List ifprLogoBytes = ifprLogoData.buffer.asUint8List();
  final pw.ImageProvider ifprLogo = pw.MemoryImage(ifprLogoBytes);

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.green, width: 3),
            borderRadius: pw.BorderRadius.circular(12),
          ),
          child: pw.Padding(
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header with logos and title
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(ifprLogo, width: 100, height: 100),
                    pw.Text(
                      'IDENTIDADE ESTUDANTIL',
                      style: pw.TextStyle(
                        fontSize: 18, 
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                      ),
                    ),
                  ],
                ),
                pw.Divider(color: PdfColors.red, thickness: 2),
                
                // Student Photo and Details
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Photo Section
                    imagemAluno != null
                      ? pw.Container(
                          width: 150,
                          height: 200,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.green, width: 2),
                          ),
                          child: pw.Image(
                            pw.MemoryImage(imagemAluno),
                            width: 150,
                            height: 200,
                            fit: pw.BoxFit.cover,
                          ),
                        )
                      : pw.Container(
                          width: 150,
                          height: 200,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.grey, width: 2),
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              'Foto não disponível', 
                              style: pw.TextStyle(color: PdfColors.grey),
                            ),
                          ),
                        ),
                    
                    // Details Section
                    pw.SizedBox(width: 20),
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Nome', nome),
                          _buildDetailRow('Curso', curso),
                          _buildDetailRow('Ano de Ingresso', anoEgresse),
                          _buildDetailRow('Validade', validade),
                        ],
                      ),
                    ),
                  ],
                ),
                
                pw.Spacer(),
                
                // Footer
                pw.Divider(color: PdfColors.red, thickness: 2),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Instituto Federal do Paraná',
                      style: pw.TextStyle(
                        fontSize: 10, 
                        color: PdfColors.grey,
                      ),
                    ),
                    pw.Text(
                      'Gerado em: $dataGeracao',
                      style: pw.TextStyle(
                        fontSize: 10, 
                        color: PdfColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => pdf.save(),
  );
}

// Helper method to create consistent detail rows
pw.Widget _buildDetailRow(String label, String value) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(vertical: 5),
    child: pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(
            text: '$label: ',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
              color: PdfColors.green,
            ),
          ),
          pw.TextSpan(
            text: value,
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
Future<Uint8List> _loadAlunoImage() async {
  final ByteData data = await rootBundle.load('assets/app/user.png');
  return data.buffer.asUint8List();
}

class CarteirinhaPage extends StatelessWidget {
  final Future<DtoalunoLogin?> dadosAluno = AlunoService.recuperarAlunoSalvo();

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
          } else {
            // Quando os dados forem carregados ou ocorrer um erro, construa o layout da carteirinha
            final DtoalunoLogin? aluno = snapshot.data;
            final String curso =
                (aluno?.alunoTurma != null && aluno!.alunoTurma!.isNotEmpty)
                    ? aluno.alunoTurma!.first.curso ?? 'Curso não disponível'
                    : 'Curso não disponível';
            final String ingresso =
                (aluno?.alunoTurma != null && aluno!.alunoTurma!.isNotEmpty)
                    ? aluno.alunoTurma!.first.dataMatricula ??
                        'data da matricula não disponível'
                    : 'data da matricula não disponível';
            final String validade =
                (aluno?.alunoTurma != null && aluno!.alunoTurma!.isNotEmpty)
                    ? aluno.alunoTurma!.first.validade ??
                        'data da validade não disponível'
                    : 'data da validade não disponível';

            final Map<String, String> idInformation = {
              'nome': aluno?.nome ?? 'Nome não disponível',
              'curso': curso,
              'ra': aluno?.ra ?? 'RA não disponível',
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
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
  onPressed: () async {
    Uint8List imagemAluno = await _loadAlunoImage(); // Carrega a imagem do aluno

    generatePDF(
      aluno?.nome ?? 'Nome não disponível',
      curso,
      ingresso,
      validade,
      imagemAluno, // Passa a imagem carregada
    );
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
          }
        },
      ),
      bottomNavigationBar: Footer(),
    );
  }
}

class CarouselWidget extends StatefulWidget {
  final Map<String, String> idInformation;

  CarouselWidget({required this.idInformation});

  @override
  _CarouselWidgetState createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Expanded(
          // Usar Expanded para dar uma altura fixa ao PageView
          child: Container(
            width: screenWidth,
            color: Colors.white,
            child: PageView(
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: <Widget>[
                _buildInfoItem(widget.idInformation), // Primeira página
                _buildQRCodeItem(), // Segunda página
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.circle,
              size: 10,
              color: _currentPage == 0 ? Colors.green : Colors.grey,
            ),
            SizedBox(width: 8),
            Icon(
              Icons.circle,
              size: 10,
              color: _currentPage == 1 ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ],
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
                left: 445,
                right: 15,
                child: Container(
                  height: 5.0, // Height of the border
                  color: Colors.red, // Border color
                ),
              ),
              Positioned(
                top:
                    95, // Adjust this to control the distance from the first element
                left: 435,
                right: 15,
                child: Container(
                  height: 5.0, // Height of the border
                  color: Colors.green, // Border color
                ),
              ),
              Positioned(
                top:
                    0, // Adjust this to control the distance from the first element
                bottom: 290,
                left: 444,
                right: 158,
                child: Container(
                  height: 5.0, // Height of the border
                  color: Colors.red, // Border color
                ),
              ),
              Positioned(
                top:
                    0, // Adjust this to control the distance from the first element
                bottom: 284,
                left: 435,
                right: 167,
                child: Container(
                  height: 5.0, // Height of the border
                  color: Colors.green, // Border color
                ),
              ),
              Positioned(
                top: -25, // Adjust this to move the image vertically
                left: 250, // Adjust this to move the image horizontally
                child: Container(
                  width: 160, // Width of the image
                  height: 160, // Height of the image
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(8), // Optional: add border radius
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/app/ifprLogo.png'), // Replace with your image path
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -48, // Adjust this to move the image vertically
                left: 25, // Adjust this to move the image horizontally
                child: Container(
                  width: 200, // Width of the image
                  height: 200, // Height of the image
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(8), // Optional: add border radius
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/app/brasao.png'), // Replace with your image path
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20, // Adjust this to move the text vertically
                left: 460, // Adjust this to move the text horizontally
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
                top: 120, // Adjust this to move the placeholder vertically
                left: 430, // Adjust this to move the placeholder horizontally
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