import 'package:flutter/material.dart';
import 'package:miniprojeto/interfaces/avaliacao.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/avaliacao_provider.dart';
import '../services/avaliacao_service.dart';

class Detalhes extends StatefulWidget {
  final int index;
  const Detalhes({Key? key, required this.index}) : super(key: key);

  @override
  State<Detalhes> createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {
  bool _editing = false;

  void _deteleAvaliacao() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Tem certeza que deseja excluir esta avaliação?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Não'),
              ),
              TextButton(
                onPressed: () {
                  final avaliacaoProvider = Provider.of<AvaliacaoProvider>(context, listen: false);
                  avaliacaoProvider.removeAvaliacao(widget.index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('O registo de avaliação selecionado foi eliminado com sucesso.'),
                    ),
                  );
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('Sim'),
              ),
            ],
          );
        }
    );
  }

  _toggleEdit() {
    setState(() {
      _editing = !_editing;
    });
  }

  void _share(Avaliacao avaliacao) {
    Share.share('Mensagem do Dealer!!\n\nVamos ter avaliação de ${avaliacao.disciplina}, em ${avaliacao.dataHora}, com a dificuldade de ${avaliacao.dificuldade} numa escala de 1 a 5.\n\nObservações para esta avaliação:\n${avaliacao.observacoes ?? 'Sem observações'}');
  }

  @override
  Widget build(BuildContext context) {
    final AvaliacaoProvider avaliacaoProvider = Provider.of<AvaliacaoProvider>(context, listen: true);
    Avaliacao avaliacao = avaliacaoProvider.avaliacoes[widget.index];
    return Scaffold(
      appBar: AvaliacaoService().canManipulate(avaliacao.dataHora) ? AppBar(
        title: const Text('Detalhes da avaliação'),
        //icon button on the right side of the app bar
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _share(avaliacao),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _deteleAvaliacao(),
          ),
        ],
      ) : AppBar(
        title: const Text('Detalhes da avaliação'),
        //icon button on the right side of the app bar
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _share(avaliacao),
          )
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: SingleChildScrollView(
          child: _editing ?
          DetalhesEdit(index: widget.index, avaliacao: avaliacao, onFormSubmitted: _toggleEdit) :
          DetalhesView(index: widget.index, canManipulate: AvaliacaoService().canManipulate(avaliacao.dataHora)),
        ),
      ),
      floatingActionButton: AvaliacaoService().canManipulate(avaliacao.dataHora) ? FloatingActionButton(
        onPressed: () => _toggleEdit(),
        child: _editing ? const Icon(Icons.close) : const Icon(Icons.edit),
      ) : null,
    );
  }
}

class DetalhesView extends StatelessWidget {
  final int index;
  final bool canManipulate;
  const DetalhesView({Key? key, required this.index, required this.canManipulate}) : super(key: key);

  String _getDateString(String date) {
    //check if date in format YYY/MM/DD HH:MM is in the future
    String year = date.substring(0, 4);
    String month = date.substring(5, 7);
    String day = date.substring(8, 10);
    String hour = date.substring(11, 13);
    String minute = date.substring(14, 16);
    // in format "6 de fevereiro de 2021 às 14:00"
    return "$day de ${_getMonth(month)} de $year às $hour:$minute";
  }

  String _getMonth(String month) {
    switch (month) {
      case '01':
        return 'janeiro';
      case '02':
        return 'fevereiro';
      case '03':
        return 'março';
      case '04':
        return 'abril';
      case '05':
        return 'maio';
      case '06':
        return 'junho';
      case '07':
        return 'julho';
      case '08':
        return 'agosto';
      case '09':
        return 'setembro';
      case '10':
        return 'outubro';
      case '11':
        return 'novembro';
      case '12':
        return 'dezembro';
      default:
        return 'janeiro';
    }
  }

  String _getDificuldade(int dificuldade) {
    // 1 a 5
    switch (dificuldade) {
      case 1:
        return 'muito fácil';
      case 2:
        return 'fácil';
      case 3:
        return 'mais ou menos fácil';
      case 4:
        return 'difícil';
      case 5:
        return 'muito difícil';
      default:
        return 'médio';
    }
  }

  @override
  Widget build(BuildContext context) {
    final AvaliacaoProvider avaliacaoProvider = Provider.of<AvaliacaoProvider>(context, listen: true);
    Avaliacao avaliacao = avaliacaoProvider.avaliacoes[index];
    return Column(
      children: [
        Image.network(
            avaliacao.thumbnail ?? 'https://pbs.twimg.com/profile_images/1172454147758678016/pc18AhSV_400x400.jpg',
            width: double.infinity,
            //height = width
            height: MediaQuery.of(context).size.width * 0.75,
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
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Text(avaliacao.disciplina, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("${avaliacaoProvider.tipoLabel(avaliacao.tipo)} ${_getDificuldade(avaliacao.dificuldade)}"),
              ],
            )
        ),
        ListTile(
          title: const Text('Data e hora da avaliação'),
          subtitle: canManipulate ? Text(_getDateString(avaliacao.dataHora)) : Text("Realizada a ${_getDateString(avaliacao.dataHora)}"),
        ),
        const Divider(),
        ListTile(
          title: const Text('Observações'),
          subtitle: Text(avaliacao.observacoes ?? 'Sem observações'),
        ),
      ],
    );
  }
}

class DetalhesEdit extends StatefulWidget {
  Avaliacao avaliacao;
  final int index;
  final VoidCallback onFormSubmitted;

  DetalhesEdit({Key? key, required this.index, required this.avaliacao, required this.onFormSubmitted}) : super(key: key);

  @override
  State<DetalhesEdit> createState() => _DetalhesEditState();
}

class _DetalhesEditState extends State<DetalhesEdit> {
  final _nomeController = TextEditingController();
  AvaliacaoTipo? _tipoAvaliacao;
  final _observacoesController = TextEditingController();
  final List<String> _dificuldadeLabels = [
    'Muito fácil',
    'Fácil',
    'Médio',
    'Difícil',
    'Muito difícil'
  ];
  String _data = '';
  int _dificuldade = 3;
  bool _loading = false;

  @override
  void initState() {
    _nomeController.value = TextEditingValue(text: widget.avaliacao.disciplina);
    _data = widget.avaliacao.dataHora;
    _dificuldade = widget.avaliacao.dificuldade;
    _tipoAvaliacao = widget.avaliacao.tipo;
    _observacoesController.value = TextEditingValue(text: widget.avaliacao.observacoes ?? '');
    super.initState();
  }

  void _setData(DateTime date) {
    setState(() {
      // all dates are in format YYYY/MM/DD HH:MM lmao
      _data = '${date.year}/${date.month < 10 ? '0' : ''}${date.month}/${date.day < 10 ? '0' : ''}${date.day} ${date.hour < 10 ? '0' : ''}${date.hour}:${date.minute < 10 ? '0' : ''}${date.minute}';
    });
  }

  bool _isFormValid() {
    return _nomeController.text.isNotEmpty &&
        _tipoAvaliacao != null &&
        _data.isNotEmpty;
  }

  void _submitForm() async {
    if (!_isFormValid()) {
      return;
    }
    setState(() {
      _loading = true;
    });
    final AvaliacaoProvider avaliacaoProvider = Provider.of<AvaliacaoProvider>(context, listen: false);
    avaliacaoProvider.editarAvaliacao(widget.index, Avaliacao(
      disciplina: _nomeController.text,
      tipo: _tipoAvaliacao!,
      dataHora: _data,
      dificuldade: _dificuldade,
      observacoes: _observacoesController.text,
      thumbnail: widget.avaliacao.thumbnail,
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('O registo de avaliação selecionado foi editado com sucesso.'),
      ),
    );
    setState(() {
      _loading = false;
      widget.onFormSubmitted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          TextField(
            controller: _nomeController,
            maxLength: 50,
            decoration: InputDecoration(
              labelText: 'Nome da disciplina',
              hintText: 'Ex: Computação Móvel',
              errorText: _nomeController.text.isEmpty ? 'O nome da disciplina não pode estar vazio' : null,
              errorStyle: const TextStyle(color: Colors.red),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),
          SizedBox.fromSize(size: const Size(0, 16)),
          DropdownButton(
            isExpanded: true,
            value: _tipoAvaliacao,
            hint: const Text('Tipo de avaliação'),
            enableFeedback: true,
            items: const [
              DropdownMenuItem(
                value: AvaliacaoTipo.frequencia,
                child: Text('Frequência'),
              ),
              DropdownMenuItem(
                value: AvaliacaoTipo.miniteste,
                child: Text('Mini-teste'),
              ),
              DropdownMenuItem(
                value: AvaliacaoTipo.projeto,
                child: Text('Projeto'),
              ),
              DropdownMenuItem(
                value: AvaliacaoTipo.defesa,
                child: Text('Defesa'),
              )
            ],
            onChanged: (value) {
              setState(() {
                _tipoAvaliacao = value;
              });
            },
          ),
          SizedBox.fromSize(size: const Size(0, 16)),
          ElevatedButton(
            onPressed: () async {
              DateTime? dateTime = await showOmniDateTimePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(
                  const Duration(days: 3652),
                ),
                is24HourMode: true,
                isShowSeconds: false,
                minutesInterval: 1,
                secondsInterval: 1,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                constraints: const BoxConstraints(
                  maxWidth: 350,
                  maxHeight: 650,
                ),
                transitionBuilder: (context, anim1, anim2, child) {
                  return FadeTransition(
                    opacity: anim1.drive(
                      Tween(
                        begin: 0,
                        end: 1,
                      ),
                    ),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 200),
                barrierDismissible: true,
                selectableDayPredicate: (dateTime) => true,
                type: OmniDateTimePickerType.dateAndTime,
              );

              _setData(dateTime!);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                _data.isEmpty ? 'Data e hora da avaliação' : _data,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox.fromSize(size: const Size(0, 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                width: 100,
                child: Text(
                  'Dificuldade da avaliação',
                  textAlign: TextAlign.center,
                ),
              ),
              Slider(
                value: _dificuldade.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: _dificuldadeLabels[_dificuldade - 1],
                onChanged: (value) {
                  setState(() {
                    _dificuldade = value.toInt();
                  });
                },
              ),
            ],
          ),
          SizedBox.fromSize(size: const Size(0, 16)),
          TextField(
            controller: _observacoesController,
            maxLength: 200,
            decoration: const InputDecoration(
              labelText: 'Observações (opcional)',
              hintText: 'Ex: Sala A.2.11 com o docente X',
            ),
            maxLines: 5,
          ),
          SizedBox.fromSize(size: const Size(0, 25)),
          _loading ? const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ) : ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Guardar alterações')
          ),
          SizedBox.fromSize(size: const Size(0, 25))
        ],
      ),
    );
  }
}
