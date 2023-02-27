import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:miniprojeto/interfaces/avaliacao.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../providers/avaliacao_provider.dart';

class CreateAvaliacao extends StatefulWidget {
  const CreateAvaliacao({Key? key}) : super(key: key);

  @override
  State<CreateAvaliacao> createState() => _CreateAvaliacaoState();
}

class _CreateAvaliacaoState extends State<CreateAvaliacao> {
  final _nomeController = TextEditingController();
  final _dropdownMenuController = TextEditingController();
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

  void _setData(DateTime date) {
    setState(() {
      // all dates are in format YYYY/MM/DD HH:MM lmao
      _data = '${date.year}/${date.month < 10 ? '0' : ''}${date.month}/${date.day < 10 ? '0' : ''}${date.day} ${date.hour < 10 ? '0' : ''}${date.hour}:${date.minute < 10 ? '0' : ''}${date.minute}';
    });
  }

  bool _isFormValid() {
    return _nomeController.text.isNotEmpty &&
        _dropdownMenuController.text.isNotEmpty &&
        _data.isNotEmpty;
  }

  void _limparForm() {
    _nomeController.clear();
    _dropdownMenuController.clear();
    _observacoesController.clear();
    setState(() {
      _dificuldade = 3;
      _data = '';
    });
  }

  Future<void> _submitForm() async {
    if (_isFormValid()) {
      setState(() => _loading = true);
      final avaliacaoProvider = Provider.of<AvaliacaoProvider>(context, listen: false);
      final avaliacao = Avaliacao(
        disciplina: _nomeController.text,
        tipo: avaliacaoProvider.tipoFromLabel(_dropdownMenuController.text),
        dataHora: _data,
        dificuldade: _dificuldade,
        observacoes: _observacoesController.text,
        thumbnail: await setThubmnail(),
      );
      avaliacaoProvider.addAvaliacao(avaliacao);
      _limparForm();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          backgroundColor: Colors.green,
          content: Text('A avaliação foi registada com sucesso.'),
        ),
      );
    } else if(_dropdownMenuController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          content: Text('Seleccione o tipo de avaliação.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          content: Text('Preencha todos os campos obrigatórios.'),
        ),
      );
    }
    setState(() => _loading = false);
  }

  Future<String> setThubmnail() async {
    try {
      dynamic image = json.decode((await http.get(Uri.parse('https://contextualwebsearch-websearch-v1.p.rapidapi.com/api/Search/ImageSearchAPI?q=${_nomeController.text}&pageNumber=1&pageSize=10&autoCorrect=true'), headers: {
        'X-RapidAPI-Key': 'dc81c490d6msh0db50d2fe1e2c94p18575fjsnd31df5d1bf6e',
        'X-RapidAPI-Host': 'contextualwebsearch-websearch-v1.p.rapidapi.com'
      })).body);
      return image['value'][0]['thumbnail'];
    } catch (e) {
      return 'https://pbs.twimg.com/profile_images/1172454147758678016/pc18AhSV_400x400.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              maxLength: 50,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Nome da disciplina',
                hintText: 'Ex: Computação Móvel',
                errorText: _nomeController.text.isEmpty ? 'O nome da disciplina não pode estar vazio' : null,
                errorStyle: const TextStyle(color: Colors.red),
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
            SizedBox.fromSize(size: const Size(0, 16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownMenu(
                  width: 200,
                  hintText: 'Tipo de avaliação',
                  enableSearch: false,
                  enableFilter: false,
                  controller: _dropdownMenuController,
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(
                        value: 0,
                        label: 'Frequência'
                    ),
                    DropdownMenuEntry(
                        value: 1,
                        label: 'Mini-teste'
                    ),
                    DropdownMenuEntry(
                        value: 2,
                        label: 'Projeto'
                    ),
                    DropdownMenuEntry(
                        value: 3,
                        label: 'Defesa'
                    )
                  ],
                  onSelected: (_) => setState(() => FocusScope.of(context).unfocus()),
                ),
                SizedBox(
                  //auto width that doesnt overflow
                  width: MediaQuery.of(context).size.width - 290,
                  child: ElevatedButton(
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
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        _data.isEmpty ? 'Data e hora da avaliação' : _data,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
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
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
                labelText: 'Observações (opcional)',
                hintText: 'Ex: Sala A.2.11 com o docente X',
              ),
              maxLines: 5,
            ),
            SizedBox.fromSize(size: const Size(0, 25)),
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _limparForm(),
                  child: const Text('Limpar'),
                ),
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
                    child: const Text('Registar avaliação')
                ),
              ],
            ),
            SizedBox.fromSize(size: const Size(0, 25))
          ],
        ),
      ),
    );
  }
}
