import 'package:flutter/material.dart';

class DecisionOverviewScreen extends StatelessWidget {
  const DecisionOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de Decisión'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Resumen de la decisión (Próximamente)'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                Navigator.pushNamed(context, '/criteria');
              },
              child: const Text('Definir Criterios'),
            ),
          ],
        ),
      ),
    );
  }
}
