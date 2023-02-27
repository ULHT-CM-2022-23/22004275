import 'package:flutter/material.dart';
import 'package:miniprojeto/pages/detalhes.dart';
import 'package:miniprojeto/services/avaliacao_service.dart';
import 'package:provider/provider.dart';

import '../components/no_content.dart';
import '../providers/avaliacao_provider.dart';

class Avaliacoes extends StatefulWidget {
  const Avaliacoes({Key? key}) : super(key: key);

  @override
  State<Avaliacoes> createState() => _AvaliacoesState();
}

class _AvaliacoesState extends State<Avaliacoes> {

  _deleteAvaliacao(int index, String date) {
    if (AvaliacaoService().canManipulate(date)) {
      final avaliacaoProvider = Provider.of<AvaliacaoProvider>(context, listen: false);
      avaliacaoProvider.removeAvaliacao(index);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Só podem ser eliminados registos de avaliações futuras.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final avaliacaoProvider = Provider.of<AvaliacaoProvider>(context, listen: true);

    return avaliacaoProvider.avaliacoes.isNotEmpty ? ListView(
      //get the list of avaliacoes from the provider and the index of the current item
      children: avaliacaoProvider.avaliacoes.map((avaliacao) {
        return Dismissible(
          key: Key("${avaliacao.disciplina} ${avaliacao.dataHora}"),
          onDismissed: (direction) => _deleteAvaliacao(avaliacaoProvider.avaliacoes.indexOf(avaliacao), avaliacao.dataHora),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.delete_rounded, color: Colors.white)
            ),
          ),
          child: ListTile(
            //leading image from URL
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
            subtitle: Text("${avaliacaoProvider.tipoLabel(avaliacao.tipo)} - ${avaliacao.dataHora}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                    Icons.warning_rounded,
                    color: avaliacao.dificuldade > 3 ? Colors.red : avaliacao.dificuldade > 2 ? Colors.orange : Colors.green
                ),
                const SizedBox(width: 8),
                Text(avaliacao.dificuldade.toString())
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Detalhes(index: avaliacaoProvider.avaliacoes.indexOf(avaliacao)),
                ),
              );
            },
          ),
        );
      }).toList(),
    )
        : const NoContent(title: 'Nenhuma avaliação encontrada', subtitle: 'Quando registar uma avaliação ela aparecerá aqui', chosenIcon: Icons.line_weight_rounded);
  }
}
