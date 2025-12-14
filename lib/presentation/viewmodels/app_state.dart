import 'package:flutter/material.dart';
import '../../domain/entities/criterion.dart';
import '../../domain/entities/alternative.dart';

class AppState extends ChangeNotifier {
  String? _problemDescription;
  final List<Criterion> _criteria = [];
  final List<Alternative> _alternatives = [];
  // Map<AlternativeID, Map<CriterionID, Value>>
  final Map<String, Map<String, int>> _evaluations = {};

  String? get problemDescription => _problemDescription;
  List<Criterion> get criteria => List.unmodifiable(_criteria);
  List<Alternative> get alternatives => List.unmodifiable(_alternatives);

  void setProblem(String description) {
    _problemDescription = description;
    notifyListeners();
  }

  // --- Criteria ---

  void addCriterion(String name, int weight) {
    final criterion = Criterion(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      weight: weight,
    );
    _criteria.add(criterion);
    notifyListeners();
  }

  void removeCriterion(String id) {
    _criteria.removeWhere((c) => c.id == id);
    _evaluations.forEach((key, val) => val.remove(id)); // Clean up evaluations
    notifyListeners();
  }

  // --- Alternatives ---

  void addAlternative(String name) {
    final alternative = Alternative(
      id: DateTime.now().millisecondsSinceEpoch.toString() + _alternatives.length.toString(),
      name: name,
    );
    _alternatives.add(alternative);
    notifyListeners();
  }

  void removeAlternative(String id) {
    _alternatives.removeWhere((a) => a.id == id);
    _evaluations.remove(id); // Clean up evaluations
    notifyListeners();
  }

  // --- Evaluation ---

  void setEvaluation(String alternativeId, String criterionId, int value) {
    if (!_evaluations.containsKey(alternativeId)) {
      _evaluations[alternativeId] = {};
    }
    _evaluations[alternativeId]![criterionId] = value;
    notifyListeners();
  }

  int getEvaluation(String alternativeId, String criterionId) {
    return _evaluations[alternativeId]?[criterionId] ?? 1; // Default to 1
  }

  // --- Scoring & Results ---

  List<AlternativeScore> getRanking() {
    final List<AlternativeScore> ranking = [];

    for (var alternative in _alternatives) {
      int totalScore = 0;
      
      for (var criterion in _criteria) {
        final score = getEvaluation(alternative.id, criterion.id);
        totalScore += score * criterion.weight;
      }

      ranking.add(AlternativeScore(alternative: alternative, score: totalScore));
    }

    // Sort descending (Standard: Higher is better)
    ranking.sort((a, b) => b.score.compareTo(a.score));

    return ranking;
  }

  String getDecisionExplanation() {
    final ranking = getRanking();
    if (ranking.isEmpty) return "No hay suficientes datos para generar una explicación.";

    final winner = ranking.first;
    final winnerName = winner.alternative.name;

    // Find top contributing criteria (Score * Weight)
    final contributions = <Criterion, int>{};
    for (var criterion in _criteria) {
      final score = getEvaluation(winner.alternative.id, criterion.id);
      contributions[criterion] = score * criterion.weight;
    }

    // Sort contributions descending
    final sortedCriteria = contributions.keys.toList()
      ..sort((a, b) => contributions[b]!.compareTo(contributions[a]!));

    final topCriteria = sortedCriteria.take(2).toList();
    
    String explanation = "La opción \"$winnerName\" es la recomendada porque obtuvo el puntaje más alto global (${winner.score} pts). ";

    if (topCriteria.isNotEmpty) {
      explanation += "Destaca principalmente por su desempeño en ";
      explanation += topCriteria.map((c) => "\"${c.name}\"").join(" y ");
      explanation += ".";
    }

    if (ranking.length > 1) {
      final runnerUp = ranking[1];
      final diff = winner.score - runnerUp.score;
      explanation += " Supera a la segunda opción \"${runnerUp.alternative.name}\" por $diff puntos.";
    }

    return explanation;
  }

  void startNewDecision() {
    _problemDescription = null;
    _criteria.clear();
    _alternatives.clear();
    _evaluations.clear();
    notifyListeners();
  }
}

class AlternativeScore {
  final Alternative alternative;
  final int score;

  AlternativeScore({
    required this.alternative,
    required this.score,
  });
}
