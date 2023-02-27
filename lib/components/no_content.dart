import 'package:flutter/material.dart';

class NoContent extends StatelessWidget {
  final String title ;
  final String subtitle;
  final IconData chosenIcon;
  const NoContent({Key? key, required this.title, required this.subtitle, required this.chosenIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(chosenIcon, size: 100, color: Colors.grey),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 20, color: Colors.grey)),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
