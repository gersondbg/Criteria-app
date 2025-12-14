import 'package:flutter/material.dart';
import '../../main.dart'; // Global appState
import '../../app/routes.dart';

class AlternativesScreen extends StatefulWidget {
  const AlternativesScreen({super.key});

  @override
  State<AlternativesScreen> createState() => _AlternativesScreenState();
}

class _AlternativesScreenState extends State<AlternativesScreen> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addAlternative() {
    final name = _textController.text.trim();
    if (name.isNotEmpty) {
      appState.addAlternative(name);
      _textController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _removeAlternative(String id) {
    appState.removeAlternative(id);
    setState(() {}); // Force rebuild if listener doesn't trigger widget (though ListenableBuilder handles it)
  }

  void _continue() {
    if (appState.alternatives.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Debes definir al menos 2 alternativas para comparar.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      Navigator.pushNamed(context, Routes.evaluation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final alternatives = appState.alternatives;
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Definir Alternativas'),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24.0),
                  children: [
                    Text(
                      '¿Qué opciones tienes?',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Agrega las diferentes alternativas que estás considerando. Necesitas al menos dos para poder compararlas.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // Input
                    Card(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _textController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre de la Alternativa',
                                hintText: 'Ej: Aceptar trabajo',
                                border: OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _addAlternative(),
                            ),
                            const SizedBox(height: 16),
                            FilledButton.icon(
                              onPressed: _addAlternative,
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar Alternativa'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      'Alternativas Agregadas (${alternatives.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    if (alternatives.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: Text('Aún no has agregado alternativas.')),
                      )
                    else
                      ...alternatives.map((alt) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.fork_right)),
                          title: Text(alt.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _removeAlternative(alt.id),
                          ),
                        ),
                      )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: FilledButton(
                  onPressed: appState.alternatives.length >= 2 ? _continue : null,
                  style: FilledButton.styleFrom(
                     minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text('Continuar a Evaluación'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
