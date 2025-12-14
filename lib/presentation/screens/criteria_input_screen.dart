import 'package:flutter/material.dart';
import '../../main.dart'; // Global appState access
import '../../app/routes.dart';

class CriteriaInputScreen extends StatefulWidget {
  const CriteriaInputScreen({super.key});

  @override
  State<CriteriaInputScreen> createState() => _CriteriaInputScreenState();
}

class _CriteriaInputScreenState extends State<CriteriaInputScreen> {
  final _textController = TextEditingController();
  double _currentWeight = 3.0;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _addCriterion() {
    final name = _textController.text.trim();
    if (name.isNotEmpty) {
      appState.addCriterion(name, _currentWeight.round());
      _textController.clear();
      setState(() {
        _currentWeight = 3.0; // Reset weight
      });
      // dismiss keyboard
      FocusScope.of(context).unfocus();
    }
  }

  void _removeCriterion(String id) {
    appState.removeCriterion(id);
    setState(() {}); // Rebuild to show updated list
  }

  void _continue() {
    if (appState.criteria.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Debes agregar al menos un criterio.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      Navigator.pushNamed(context, Routes.alternatives);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to changes for rebuild
    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        final criteriaList = appState.criteria;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Definir Criterios'),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24.0),
                  children: [
                    Text(
                      '¿Qué factores importan?',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Agrega los criterios que usarás para evaluar tus opciones (ej: Costo, Tiempo, Calidad). Asigna un peso del 1 al 5 según su importancia.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Input Card
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
                                labelText: 'Nombre del Criterio',
                                hintText: 'Ej: Precio',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _addCriterion(),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text('Importancia: ${_currentWeight.round()}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Slider(
                                    value: _currentWeight,
                                    min: 1,
                                    max: 5,
                                    divisions: 4,
                                    label: _currentWeight.round().toString(),
                                    onChanged: (value) {
                                      setState(() {
                                        _currentWeight = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            FilledButton.icon(
                              onPressed: _addCriterion,
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar Criterio'),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      'Criterios Agregados (${criteriaList.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),

                    if (criteriaList.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: Text('Aún no has agregado criterios.')),
                      )
                    else
                      ...criteriaList.map((criterion) => Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(criterion.weight.toString()),
                          ),
                          title: Text(criterion.name),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _removeCriterion(criterion.id),
                          ),
                        ),
                      )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: FilledButton(
                  onPressed: _continue,
                  style: FilledButton.styleFrom(
                     minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text('Continuar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
