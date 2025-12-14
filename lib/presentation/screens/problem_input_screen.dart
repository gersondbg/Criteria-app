import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // Future integration
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../app/routes.dart';
import '../../main.dart'; // Direct access to global appState for now

class ProblemInputScreen extends StatefulWidget {
  const ProblemInputScreen({super.key});

  @override
  State<ProblemInputScreen> createState() => _ProblemInputScreenState();
}

class _ProblemInputScreenState extends State<ProblemInputScreen> {
  final _formKey = GlobalKey<FormState>();
  final _problemController = TextEditingController();
  
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  void _initSpeech() async {
    try {
      _speechEnabled = await _speech.initialize(
        onError: (val) => debugPrint('onError: $val'),
        onStatus: (val) => debugPrint('onStatus: $val'),
      );
      setState(() {});
    } catch (e) {
      debugPrint("Speech init error: $e");
    }
  }

  void _listen() async {
    if (!_speechEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El reconocimiento de voz no está disponible.')),
      );
      return;
    }

    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _problemController.text = val.recognizedWords;
          }),
          localeId: 'es_ES', // Try Spanish
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  void dispose() {
    _problemController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final problem = _problemController.text.trim();
      
      // Save state
      appState.setProblem(problem);
      
      // Navigate
      Navigator.pushNamed(context, Routes.decisionOverview);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, describe tu problema para continuar.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Definir Problema'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '¿Cuál es la decisión que necesitas tomar?',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Describe la situación con tus propias palabras.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 32),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    TextFormField(
                      controller: _problemController,
                      maxLines: 8,
                      minLines: 4,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: _isListening 
                            ? 'Escuchando... Di tu problema.' 
                            : 'Ej: Tengo que decidir si aceptar una oferta de trabajo...',
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                        // Visual cue for listening state
                        filled: _isListening,
                        fillColor: _isListening ? Theme.of(context).colorScheme.surfaceContainerHighest : null,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening ? Colors.red : Theme.of(context).colorScheme.primary,
                      ),
                      tooltip: 'Hablar',
                      onPressed: _listen,
                    ),
                  ],
                ),
                if (_isListening)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Grabando... Toca el micrófono para detener.',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Continuar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

