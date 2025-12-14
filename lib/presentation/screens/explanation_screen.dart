import 'package:flutter/material.dart';
import '../../main.dart'; // Global appState
import '../../app/routes.dart';

class ExplanationScreen extends StatelessWidget {
  const ExplanationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Should depend on logic, usually called after results are ready.
    // We assume state is valid.
    final ranking = appState.getRanking();
    
    if (ranking.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Explicación')),
        body: const Center(child: Text('No hay resultados para explicar.')),
      );
    }

    final winner = ranking.first;
    final explanation = appState.getDecisionExplanation();
    final criteria = appState.criteria;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Análisis Detallado'),
      ),
      body: Scrollbar(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Text(
              '¿Por qué esta es la mejor opción?',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Winner Card with Explanation
            Card(
              elevation: 2,
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      winner.alternative.name,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      explanation,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            height: 1.5,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            Text(
              'Desglose por Criterio',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Criteria Breakdown List
            ...criteria.map((criterion) {
              final score = appState.getEvaluation(winner.alternative.id, criterion.id);
              final contribution = score * criterion.weight;
              
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              criterion.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              'Importancia (Peso): ${criterion.weight}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$score / 5',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '+$contribution pts',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FilledButton.tonal(
          onPressed: () {
            // Return to Result Screen (Pop or PushNamed if strict flow required, but pop is safer if pushed from Result)
            // But Requirements say: "Botón: 'Ver resultado final' -> /result". 
            // If we pushNamed, we stack. If we pop, we return. 
            // "Integrar navegación DESDE la pantalla de resultado" 
            // implies Result -> Explanation. So Pop is "Back to Result". 
            // BUT strict requirement "-> /result" might imply explicit nav.
            // I will use pop if canPop, else pushReplacement to Result.
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, Routes.result);
            }
          },
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
          child: const Text('Ver Resultado Final'),
        ),
      ),
    );
  }
}
