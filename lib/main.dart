import 'package:flutter/material.dart';
import 'app/app.dart';
import 'presentation/viewmodels/app_state.dart';

// Simple global access for now (or use Provider/GetIt in future)
final appState = AppState();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CriteriaApp());
}
