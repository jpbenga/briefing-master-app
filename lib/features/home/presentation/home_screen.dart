import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Briefing Master'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Coach IA vocal pour la prise de parole professionnelle.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            Text(
              'Cette base Flutter prépare les modules métiers, la navigation et '
              'les thèmes pour l\'expérience temps réel.',
            ),
          ],
        ),
      ),
    );
  }
}
