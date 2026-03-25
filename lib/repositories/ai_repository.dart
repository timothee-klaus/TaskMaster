import 'dart:convert';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/services/api/ai_service.dart';

/// Couche abstraite Repository: Parse les informations brutes de l'IA (AiService)
/// en Objets Dart compréhensibles par nos ViewModels.
class AiRepository {
  final AiService _aiService;

  AiRepository(this._aiService);

  /// Demande à l'IA de décomposer une tâche en sous-tâches avec créneaux horaires
  Future<List<SubTask>> generateSubtasks(Task task) async {
    final taskTitle = task.title ?? 'Sans titre';
    final dueDate = task.dueDate;
    final totalDuration = task.estimatedDurationMinutes;

    final systemPrompt =
        '''
Tu es un expert en productivité minimaliste. 
L'utilisateur te donne une tâche principale à réaliser. 
${dueDate != null ? "La tâche est prévue pour le : ${dueDate.toLocal()}." : ""}
La durée totale estimée est de $totalDuration minutes.

Tu dois structurer un plan en la décomposant en 3 à 5 sous-tâches ultra-précises.
Pour chaque sous-tâche, tu DOIS proposer :
1. Un titre concis.
2. Une durée estimée en minutes.
3. Une heure de début suggérée (startTime) au format ISO 8601.

RÉPONDS EXCLUSIVEMENT AU FORMAT JSON.
Structure du JSON attendue:
{
  "subtasks": [
    {
      "title": "Étape 1",
      "duration": 15,
      "startTime": "2024-03-24T14:00:00"
    }
  ]
}
''';

    try {
      final response = await _aiService.generateChatCompletion(
        systemPrompt,
        "Tâche : $taskTitle",
      );

      String contentStr = response['choices'][0]['message']['content'];

      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(contentStr);
      if (jsonMatch != null) {
        contentStr = jsonMatch.group(0)!;
      }

      final Map<String, dynamic> data = jsonDecode(contentStr);
      final List<dynamic> subtaskList = data['subtasks'] ?? [];

      return subtaskList.map((item) {
        final st = SubTask();
        if (item is Map) {
          st.title = item['title']?.toString();
          st.durationMinutes = item['duration'] is int
              ? item['duration']
              : null;
          if (item['startTime'] != null) {
            st.startTime = DateTime.tryParse(item['startTime'].toString());
          }
        } else {
          st.title = item.toString();
        }
        return st;
      }).toList();
    } catch (e) {
      print('Échec du découpage intelligent Groq/Llama : $e');
      return [];
    }
  }

  Future<Task?> parseTaskFromNaturalLanguage(String input) async {
    final now = DateTime.now();
    final systemPrompt =
        '''
Tu es un assistant vocal ultra-intelligent (NLP). 
Ton rôle est d'analyser cette courte phrase ("$input") et d'en extraire les détails d'une tâche.
Aujourd'hui, nous sommes le ${now.toIso8601String()}.

Extrais les informations sous forme de JSON strict :
{
  "title": "Nom de la tâche sans les mots de remplissage",
  "description": "Détails supplémentaires ou contexte (optionnel, sinon null)",
  "startTime": "Date et heure de début estimée au format ISO 8601 strict (ex: 2026-03-25T14:00:00). Si aucune date/heure n'est précisée, mets null",
  "durationMinutes": Entier de durée estimée en minutes (ex: 60). Devine-la si absente selon la tâche,
  "priority": "low", "medium" ou "high" selon l'urgence devinée,
  "isFlexible": boolean, vrai si l'utilisateur ne précise pas d'heure fixe ou dit "quand tu as un moment", "plus tard", etc.,
  "shouldGenerateSubtasks": boolean, vrai si l'utilisateur demande de "planifier", "organiser", "décomposer" ou si la tâche semble complexe.
}

RÉPONDS EXCLUSIVEMENT AU FORMAT JSON SANS TEXTE AVANT OU APRÈS.
''';

    try {
      final response = await _aiService.generateChatCompletion(
        systemPrompt,
        "Phrase : $input",
      );

      String contentStr = response['choices'][0]['message']['content'];

      final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(contentStr);
      if (jsonMatch != null) {
        contentStr = jsonMatch.group(0)!;
      }

      final Map<String, dynamic> data = jsonDecode(contentStr);

      final task = Task();
      task.title = data['title']?.toString();
      task.description = data['description']?.toString();

      if (data['startTime'] != null && data['startTime'].toString() != "null") {
        task.dueDate = DateTime.tryParse(data['startTime'].toString());
      }

      if (data['durationMinutes'] is int) {
        task.estimatedDurationMinutes = data['durationMinutes'];
      } else {
        task.estimatedDurationMinutes = 60; // Default
      }

      if (data['isFlexible'] is bool) {
        task.isFlexible = data['isFlexible'];
      }

      final prioStr = data['priority']?.toString().toLowerCase();
      if (prioStr == 'high')
        task.priority = TaskPriority.high;
      else if (prioStr == 'low')
        task.priority = TaskPriority.low;
      else
        task.priority = TaskPriority.medium;

      // Temporary storage for UI logic
      if (data['shouldGenerateSubtasks'] == true) {
        task.description =
            (task.description ?? '') + " [REQUÊTE_PLANIFICATION]";
      }

      return task;
    } catch (e) {
      print('Échec du parsing NLP Groq/Llama : $e');
      return null;
    }
  }
}
