enum AvaliacaoTipo {
  frequencia,
  miniteste,
  projeto,
  defesa
}

class Avaliacao {
  String disciplina;
  AvaliacaoTipo tipo;
  String dataHora;
  int dificuldade;
  String? observacoes; // optional
  String? thumbnail; // optional

  Avaliacao({
    required this.disciplina,
    required this.tipo,
    required this.dataHora,
    required this.dificuldade,
    this.observacoes,
    this.thumbnail,
  });
}