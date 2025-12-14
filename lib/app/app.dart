import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'routes.dart';

class CriteriaApp extends StatelessWidget {
  const CriteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRITERIA',
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme, // Keeping it simple as per strict request
      initialRoute: Routes.home,
      routes: Routes.getRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }
}
