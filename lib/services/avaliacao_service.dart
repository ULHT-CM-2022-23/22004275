import '../interfaces/avaliacao.dart';

class AvaliacaoService {
  bool canManipulate(String date) {
    //check if date in format YYY/MM/DD HH:MM is in the future
    DateTime now = DateTime.now();
    String year = date.substring(0, 4);
    String month = date.substring(5, 7);
    String day = date.substring(8, 10);
    String hour = date.substring(11, 13);
    String minute = date.substring(14, 16);
    DateTime dateToCompare = DateTime(int.parse(year), int.parse(month), int.parse(day), int.parse(hour), int.parse(minute));
    return now.isBefore(dateToCompare);
  }

  double getMedia7dias(List<Avaliacao> avaliacoes) {
    int media = 0;
    int count = 0;
    DateTime now = DateTime.now();
    for (Avaliacao avaliacao in avaliacoes) {
      String year = avaliacao.dataHora.substring(0, 4);
      String month = avaliacao.dataHora.substring(5, 7);
      String day = avaliacao.dataHora.substring(8, 10);
      String hour = avaliacao.dataHora.substring(11, 13);
      String minute = avaliacao.dataHora.substring(14, 16);
      DateTime dateToCompare = DateTime(int.parse(year), int.parse(month), int.parse(day), int.parse(hour), int.parse(minute));
      if (now.difference(dateToCompare).inDays <= 7) {
        media += avaliacao.dificuldade;
        count++;
      }
    }
    return count > 0 ? media/count : 0;
  }

  double getMedia7a14dias(List<Avaliacao> avaliacoes) {
    // media da dificuldade das avaliações feitas entre 7 e 14 dias
    int media = 0;
    int count = 0;
    DateTime now = DateTime.now();
    for (Avaliacao avaliacao in avaliacoes) {
      String year = avaliacao.dataHora.substring(0, 4);
      String month = avaliacao.dataHora.substring(5, 7);
      String day = avaliacao.dataHora.substring(8, 10);
      String hour = avaliacao.dataHora.substring(11, 13);
      String minute = avaliacao.dataHora.substring(14, 16);
      DateTime dateToCompare = DateTime(int.parse(year), int.parse(month), int.parse(day), int.parse(hour), int.parse(minute));
      if (now.difference(dateToCompare).inDays > 7 && now.difference(dateToCompare).inDays <= 14) {
        media += avaliacao.dificuldade;
        count++;
      }
    }
    return count > 0 ? media/count : 0;
  }
}