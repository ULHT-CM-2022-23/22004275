import 'package:flutter/material.dart';
import 'package:miniprojeto/app_container.dart';
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
    }
    return colors;
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
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
              )
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AppContainer()),
              );
            },
            child: const Text('Go to AppContainer'),
          ),
        ],
      ),
    );
  }
}
