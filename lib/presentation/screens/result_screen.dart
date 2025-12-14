import 'package:flutter/material.dart';
import '../../main.dart'; // Global appState
import '../../app/routes.dart';
// import '../viewmodels/app_state.dart'; 
// import '../screens/criteria_input_screen.dart'; // For Routes ref if needed, but we use string keys.
// Wait, we used Routes.criteriaInput. We need to import Routes (already there).
// We need to make sure we don't have errors.
// actually, we used Routes.criteriaInput which is in routes.dart.
// Let's checks the file content again or just run analyze.
// If I look at strict ResultScreen content, I need to make sure I imported Routes. yes I did.
// But I might not have imported the screens? No, Routes file maps strings.
// WE just need Routes class. It is imported.
// Let's run analyze first.
// Actually, AlternativeScore is in app_state.dart so we might need it if we type hint. 
// But the warning says unused. Let's check why.
// Ah, appState is imported from main.dart. 
// Let's remove the explicit import if it's unused.

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  void _startNewDecision(BuildContext context) {
    appState.startNewDecision();
    Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final ranking = appState.getRanking();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado de la Decisión'),
        automaticallyImplyLeading: false, // Prevent going back to calculation
      ),
      body: ranking.isEmpty
          ? const Center(child: Text('No hay resultados disponibles.'))
          : ListView.separated(
              padding: const EdgeInsets.all(24.0),
              itemCount: ranking.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = ranking[index];
                final isWinner = index == 0;

                return Card(
                  elevation: isWinner ? 4 : 1,
                  color: isWinner 
                      ? Theme.of(context).colorScheme.primaryContainer 
                      : Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isWinner 
                        ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
                        : BorderSide.none,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isWinner 
                          ? Theme.of(context).colorScheme.primary 
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      foregroundColor: isWinner 
                          ? Theme.of(context).colorScheme.onPrimary 
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                      child: Text(
                        '#${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      item.alternative.name,
                      style: TextStyle(
                        fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
                        fontSize: isWinner ? 18 : 16,
                      ),
                    ),
                    subtitle: isWinner ? const Text('Mejor opción recomendada') : null,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isWinner 
                            ? Theme.of(context).colorScheme.primary 
                            : Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${item.score} pts',
                        style: TextStyle(
                          color: isWinner 
                              ? Theme.of(context).colorScheme.onPrimary 
                              : Theme.of(context).colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, Routes.explanation);
              },
              icon: const Icon(Icons.info_outline),
              label: const Text('Ver Explicación Detallada'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
            const SizedBox(height: 24),
            
            // Acceptance Section
            const Text(
              '¿Aceptas esta decisión?',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      // Reject Logic
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Volver a Analizar'),
                          content: const Text('¿Qué te gustaría ajustar para reconsiderar la decisión?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx); // Close dialog
                                Navigator.pop(context); // Go back to Evaluation (from Result)
                                Navigator.pushNamed(context, Routes.criteriaInput); // Go to Criteria? 
                                // Flow: Result -> Evaluation (Previous). 
                                // User wants to adjust Criteria. 
                                // We should probably navigate to CriteriaInput.
                                // However, keeping stack clean is good. 
                                // Let's Pop until we find the route or push named.
                                // Simplest: PushNamed CriteriaInput.
                              },
                              child: const Text('Criterios'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                Navigator.pop(context); // Go back to Evaluation
                              },
                              child: const Text('Evaluaciones'),
                            ),
                          ],
                        ),
                      );
                    },
                    label: const Text('Rechazar'),
                    icon: const Icon(Icons.close),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      // Accept Logic -> PDF
                      Navigator.pushNamed(context, Routes.pdf);
                    },
                    label: const Text('Aceptar'),
                    icon: const Icon(Icons.check),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green, // Success color helper
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => _startNewDecision(context),
              child: const Text('Comenzar Nueva Decisión'),
            ),
          ],
        ),
      ),
    );
  }
}
