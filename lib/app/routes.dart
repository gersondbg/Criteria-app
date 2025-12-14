import 'package:flutter/material.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/problem_input_screen.dart';
import '../presentation/screens/decision_overview_screen.dart';

import '../presentation/screens/criteria_input_screen.dart';
import '../presentation/screens/alternatives_screen.dart';
import '../presentation/screens/evaluation_screen.dart';
import '../presentation/screens/result_screen.dart';
import '../presentation/screens/explanation_screen.dart';
import '../presentation/screens/pdf_screen.dart';

class Routes {
  static const String home = '/';
  static const String problemInput = '/problem';
  static const String decisionOverview = '/overview';
  static const String criteriaInput = '/criteria';
  static const String alternatives = '/alternatives';
  static const String evaluation = '/evaluation';
  static const String result = '/result';
  static const String explanation = '/explanation';
  static const String pdf = '/pdf';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      problemInput: (context) => const ProblemInputScreen(),
      decisionOverview: (context) => const DecisionOverviewScreen(),
      criteriaInput: (context) => const CriteriaInputScreen(),
      alternatives: (context) => const AlternativesScreen(),
      evaluation: (context) => const EvaluationScreen(),
      result: (context) => const ResultScreen(),
      explanation: (context) => const ExplanationScreen(),
      pdf: (context) => const PdfScreen(),
    };
  }
}
