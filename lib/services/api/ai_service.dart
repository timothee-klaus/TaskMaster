import 'package:dio/dio.dart';
import 'package:taskmaster/services/api/dio_client.dart';

/// Service bas-niveau responsable uniquement d'appeler l'intelligence artificielle Groq via Dio.
class AiService {
  final DioClient _dioClient;

  // Modèle gratuit extrêmement rapide chez Groq, parfait pour la génération json
  final String _model = 'llama-3.1-8b-instant';

  AiService(this._dioClient);

  /// Génère une réponse textuelle de l'IA formatée obligatoirement en JSON.
  Future<Map<String, dynamic>> generateChatCompletion(
    String systemPrompt,
    String userMessage,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        '/chat/completions',
        data: {
          "model": _model,
          "messages": [
            {"role": "system", "content": systemPrompt},
            {"role": "user", "content": userMessage},
          ],
          "response_format": {"type": "json_object"},
          "temperature":
              0.2, // Faible température pour éviter que l'IA hallucine ou dérive
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(
        'Erreur de connexion IA: ${e.response?.data ?? e.message}',
      );
    }
  }
}
