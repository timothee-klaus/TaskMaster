import 'dart:convert';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/services/api/ai_service.dart';

/// Couche abstraite Repository: Parse les informations brutes de l'IA (AiService)
/// en Objets Dart compréhensibles par nos ViewModels.
class AiRepository {
  final AiService _aiService;

  AiRepository(this._aiService);

  /// Demande à l'IA de décomposer une tâche en sous-tâches (Smart Subtasks)
  Future<List<SubTask>> generateSubtasks(String taskTitle) async {
    final systemPrompt = '''
Tu es un expert en productivité minimaliste. 
L'utilisateur te donne un titre de tâche à réaliser. 
Tu dois structurer un plan en la décomposant en 3 à 5 sous-tâches ultra-précises et concises.
IL EST IMPÉRATIF QUE TU RETOURNES EXCLUSIVEMENT DU CODE JSON VALIDE (pas d'intro, pas de format markdown), SOUS CETTE FORME EXACTE:
{
  "subtasks": [
    "Créer un plan de table",
    "Acheter des décorations",
    "Envoyer les invitations"
  ]
}
''';

    try {
      final response = await _aiService.generateChatCompletion(
        systemPrompt,
        taskTitle,
      );

      // Format classique d'une réponse API OpenAI / Groq
      final contentStr = response['choices'][0]['message']['content'];

      final Map<String, dynamic> data = jsonDecode(contentStr);
      final List<dynamic> subtaskList = data['subtasks'] ?? [];

      // On convertit les strings en authentiques objets SubTask Isar
      return subtaskList
          .map((title) => SubTask()..title = title.toString())
          .toList();
    } catch (e) {
      print('Échec du découpage intelligent Llama3 : $e');
      return [];
    }
  }
}
