import 'package:flutter/material.dart';
import '../../main.dart'; // Global appState
import '../../app/routes.dart';

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({super.key});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  // Navigation to Results
  void _finishEvaluation() {
    Navigator.pushNamed(context, Routes.result);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final alternatives = appState.alternatives;
        final criteria = appState.criteria;

        if (alternatives.isEmpty || criteria.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Evaluar Alternativas')),
            body: const Center(child: Text('Faltan datos para evaluar.')),
          );
        }

        return DefaultTabController(
          length: alternatives.length,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Evaluar Alternativas'),
              bottom: TabBar(
                isScrollable: true,
                tabs: alternatives.map((e) => Tab(text: e.name)).toList(),
              ),
            ),
            body: TabBarView(
              children: alternatives.map((alternative) {
                return ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      'Evalúa "${alternative.name}"',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Puntúa esta alternativa para cada criterio (1=Malo, 5=Excelente).',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    ...criteria.map((criterion) {
                      final currentScore = appState.getEvaluation(alternative.id, criterion.id);
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    criterion.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Peso: ${criterion.weight}',
                                      style: Theme.of(context).textTheme.labelSmall,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text('1', style: Theme.of(context).textTheme.labelSmall),
                                  Expanded(
                                    child: Slider(
                                      value: currentScore.toDouble(),
                                      min: 1,
                                      max: 5,
                                      divisions: 4,
                                      label: currentScore.toString(),
                                      onChanged: (val) {
                                        appState.setEvaluation(alternative.id, criterion.id, val.round());
                                      },
                                    ),
                                  ),
                                  Text('5', style: Theme.of(context).textTheme.labelSmall),
                                  const SizedBox(width: 8),
                                  Text(
                                    currentScore.toString(),
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 32),
                  ],
                );
              }).toList(),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: _finishEvaluation,
              label: const Text('Finalizar'),
              icon: const Icon(Icons.check),
            ),
          ),
        );
      },
    );
  }
}
