class DtoalunoLogin{
  final String ra;

  DtoalunoLogin({required this.ra});
  Map<String, dynamic> toJson() {
    return {
      'ra': ra,
    };
  }
}