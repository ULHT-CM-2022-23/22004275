import 'package:flutter/material.dart';
import '../interfaces/avaliacao.dart';

class AvaliacaoProvider extends ChangeNotifier {
  List<Avaliacao> _avaliacoes = [];
  List<Avaliacao> get avaliacoes => _avaliacoes;

  String _ordenarPor = 'dataHora';
  String get ordenarPor => _ordenarPor;
  set ordenarPor(String value) {
    _ordenarPor = value;
    _orderAvaliacoes();
    notifyListeners();
  }

  AvaliacaoProvider() {
    _avaliacoes = [
      Avaliacao(
        disciplina: 'Sistemas de Informação na Nuvem',
        tipo: AvaliacaoTipo.frequencia,
        dataHora: '2023/10/10 10:10',
        dificuldade: 3,
        observacoes: 'Frequência intermédia',
        thumbnail: 'https://www.microuniverso.com.br/wp-content/uploads/2019/01/268500-sistema-em-nuvem-o-que-e-e-quais-as-vantagens-1.jpg'
      ),
      Avaliacao(
        disciplina: 'Segurança Informática',
        tipo: AvaliacaoTipo.miniteste,
        dataHora: '2023/10/23 10:10',
        dificuldade: 2,
        thumbnail: 'https://www.itchannel.pt/img/uploads/thumb_image_1409072920.jpg'
      ),
      Avaliacao(
        disciplina: 'Computação Móvel',
        tipo: AvaliacaoTipo.projeto,
        dataHora: '2023/02/11 10:10',
        dificuldade: 4,
        observacoes: 'Projeto de grupo',
        thumbnail: 'https://is5-ssl.mzstatic.com/image/thumb/Purple122/v4/52/86/a0/5286a03f-ddfb-64d4-4583-a8deb1291b06/AppIcon1-0-0-85-220-0-0-0-0-4-0-0-0-2x-sRGB-0-0-0-0-0.png/256x256bb.png'
      ),
      Avaliacao(
        disciplina: 'Inteligência Artificial',
        tipo: AvaliacaoTipo.defesa,
        dataHora: '2023/11/01 10:10',
        dificuldade: 5,
        observacoes: 'Defesa de projeto',
        thumbnail: 'https://xplain.co/wp-content/uploads/2019/12/Artificial-Intelligence-2-256x256.jpg'
      ),
    ];
    _orderAvaliacoes();
  }

  String tipoLabel(AvaliacaoTipo tipo) {
    switch (tipo) {
      case AvaliacaoTipo.frequencia:
        return 'Frequência';
      case AvaliacaoTipo.miniteste:
        return 'Mini-teste';
      case AvaliacaoTipo.projeto:
        return 'Projeto';
      case AvaliacaoTipo.defesa:
        return 'Defesa';
    }
  }

  AvaliacaoTipo tipoFromLabel(String label) {
    switch (label) {
      case 'Frequência':
        return AvaliacaoTipo.frequencia;
      case 'Mini-teste':
        return AvaliacaoTipo.miniteste;
      case 'Projeto':
        return AvaliacaoTipo.projeto;
      case 'Defesa':
        return AvaliacaoTipo.defesa;
      default:
        return AvaliacaoTipo.frequencia;
    }
  }

  void _orderAvaliacoes() {
    switch (_ordenarPor) {
      case 'dataHora':
        _avaliacoes.sort((a, b) => a.dataHora.compareTo(b.dataHora));
        break;
      case 'disciplina':
        _avaliacoes.sort((a, b) => a.disciplina.compareTo(b.disciplina));
        break;
      case 'dificuldade':
        _avaliacoes.sort((a, b) => a.dificuldade.compareTo(b.dificuldade));
        break;
      case 'tipo':
        _avaliacoes.sort((a, b) => a.tipo.index.compareTo(b.tipo.index));
        break;
    }
  }

  void addAvaliacao(Avaliacao avaliacao) {
    _avaliacoes.add(avaliacao);
    _orderAvaliacoes();
    notifyListeners();
  }

  void editarAvaliacao(int index, Avaliacao avaliacao) {
    _avaliacoes[index] = avaliacao;
    _orderAvaliacoes();
    notifyListeners();
  }

  void removeAvaliacao(int index) {
    _avaliacoes.remove(_avaliacoes[index]);
    notifyListeners();
  }
}
