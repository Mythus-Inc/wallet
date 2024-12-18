class DtoAlunoFoto {
  final String ra;
  String caminhoImagem;

  DtoAlunoFoto(this.ra, this.caminhoImagem);

  Map<String, dynamic> toJson()  {
    return  {
      'ra': ra,
      'caminhoImagem':caminhoImagem,
    };
  }

}