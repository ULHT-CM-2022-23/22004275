import 'package:flutter/material.dart';
import 'package:miniprojeto/components/no_content.dart';
import 'package:miniprojeto/interfaces/avaliacao.dart';
import 'package:miniprojeto/pages/detalhes.dart';
import 'package:miniprojeto/services/avaliacao_service.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import '../providers/avaliacao_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _media7dias = 0;
  double _media7a14dias = 0;

  List<Avaliacao> _getAvaliacoesProximos7Dias() {
    final avaliacoes = Provider.of<AvaliacaoProvider>(context, listen: false).avaliacoes;
    final proximos7Dias = <Avaliacao>[];
    final hoje = DateTime.now();
    for (final avaliacao in avaliacoes) {
      //dataHora is a string in the format 'yyyy/MM/dd HH:mm'
      final dataHora = avaliacao.dataHora.split(' ');
      final data = dataHora[0].split('/');
      final hora = dataHora[1].split(':');
      final dataAvaliacao = DateTime(int.parse(data[0]), int.parse(data[1]), int.parse(data[2]), int.parse(hora[0]), int.parse(hora[1]));
      if (dataAvaliacao.difference(hoje).inDays <= 7 && dataAvaliacao.difference(hoje).inDays >= 0) {
        proximos7Dias.add(avaliacao);
      }
    }
    return proximos7Dias;
  }

  String _getDaysUntil(String date) {
    final dataHora = date.split(' ');
    final data = dataHora[0].split('/');
    final hora = dataHora[1].split(':');
    final dataAvaliacao = DateTime(int.parse(data[0]), int.parse(data[1]), int.parse(data[2]), int.parse(hora[0]), int.parse(hora[1]));
    final hoje = DateTime.now();
    final dias = dataAvaliacao.difference(hoje).inDays;
    if (dias == 0) {
      return 'Hoje às ${dataHora[1]}';
    } else if (dias == 1 || ((hoje.weekday == 5 || hoje.weekday == 6) && dataAvaliacao.weekday == 1 && dias <= 3)) {
      return 'Amanhã às ${dataHora[1]}';
    } else {
      return 'Daqui a $dias dias';
    }
  }

  List<Color> _getColors(int media) {
    final colors = <Color>[];
    switch (media) {
      case 1:
        colors.add(Colors.green.shade300);
        colors.add(Colors.green.shade100);
        break;
      case 2:
        colors.add(Colors.green);
        colors.add(Colors.green.shade300);
        break;
      case 3:
        colors.add(Colors.yellow);
        colors.add(Colors.green);
        break;
      case 4:
        colors.add(Colors.orange);
        colors.add(Colors.yellow);
        break;
      case 5:
        colors.add(Colors.red);
        colors.add(Colors.orange);
        break;
      default:
        colors.add(Colors.grey);
        colors.add(Colors.grey);
    }
    return colors;
  }

  String _generateSugestaoDeEstudo() {
    final avaliacoes = Provider.of<AvaliacaoProvider>(context, listen: false).avaliacoes;
    final media7dias = AvaliacaoService().getMedia7dias(avaliacoes);
    final media7a14dias = AvaliacaoService().getMedia7a14dias(avaliacoes);

    if (media7dias == 0) {
      return 'Não tens avaliações nos próximos 7 dias, aproveita para estudar!';
    } else if (media7a14dias == 0) {
      return 'Não tens avaliações nos próximos 7 a 14 dias, aproveita para estudar!';
    } else if (media7dias > media7a14dias) {
      return 'Os próximos 7 dias serão mais difíceis, tenta estudar mais!';
    } else if (media7dias < media7a14dias) {
      return 'Aproveita que os próximos 7 dias serão mais fáceis e estuda mais!';
    } else if (media7dias == media7a14dias){
      return 'Parece que vais ter duas semanas de estudos iguais, aproveita para repartir o estudo!';
    } else {
      return 'Continua um bom trabalho!';
    }
  }

  @override
  void initState() {
    final avaliacaoProvider = Provider.of<AvaliacaoProvider>(context, listen: false);
    _media7dias = AvaliacaoService().getMedia7dias(avaliacaoProvider.avaliacoes);
    _media7a14dias = AvaliacaoService().getMedia7a14dias(avaliacaoProvider.avaliacoes);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final avaliacoes = Provider.of<AvaliacaoProvider>(context).avaliacoes;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Média da dificuldade',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                        customWidths: CustomSliderWidths(progressBarWidth: 10),
                        customColors: CustomSliderColors(
                          progressBarColors: _getColors(_media7dias.toInt()),
                          trackColor: Colors.grey[300]!,
                        ),
                      ),
                      innerWidget: (value) {
                        return Center(
                          child: Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(fontSize: 30),
                          ),
                        );
                      },
                      min: 0,
                      max: 5,
                      initialValue: _media7dias,
                    ),
                    const Text('Nos próximos 7 dias'),
                  ],
                ),
                Column(
                  children: [
                    SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                        customWidths: CustomSliderWidths(progressBarWidth: 10),
                        customColors: CustomSliderColors(
                          progressBarColors: _getColors(_media7a14dias.toInt()),
                          trackColor: Colors.grey[300]!,
                        ),
                      ),
                      innerWidget: (value) {
                        return Center(
                          child: Text(
                            value.toStringAsFixed(0),
                            style: const TextStyle(fontSize: 30),
                          ),
                        );
                      },
                      min: 0,
                      max: 5,
                      initialValue: _media7a14dias,
                    ),
                    const Text('Entre 7 a 14 dias'),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            _getAvaliacoesProximos7Dias().isEmpty ?
            const NoContent(title: 'Semana livre', subtitle: 'Não existe nenhuma avaliação esta semana', chosenIcon: Icons.emoji_emotions_rounded) :
            ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 20),
                const Text('Próximas avaliações'),
                const SizedBox(height: 5),
                ..._getAvaliacoesProximos7Dias().map((avaliacao) {
                  return Card(
                    child: ListTile(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => Detalhes(index: avaliacoes.indexOf(avaliacao)))),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                            avaliacao.thumbnail ?? 'https://pbs.twimg.com/profile_images/1172454147758678016/pc18AhSV_400x400.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded) {
                                return child;
                              }
                              return AnimatedOpacity(
                                opacity: frame == null ? 0 : 1,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeOut,
                                child: child,
                              );
                            }
                        ),
                      ),
                      title: Text(avaliacao.disciplina),
                      subtitle: Text(_getDaysUntil(avaliacao.dataHora)),
                    ),
                  );
                }).toList(),
              ],
            ),
            const SizedBox(height: 30),
            // text align to the left
            Container(
              alignment: Alignment.centerLeft,
              child: const Text('Sugestão de estudo'),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                _generateSugestaoDeEstudo(),
                style: const TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
