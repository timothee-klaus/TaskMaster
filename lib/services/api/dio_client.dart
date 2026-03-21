import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Un wrapper générique de Dio pour toute l'application.
/// Si vous ajoutez d'autres APIs externes plus tard, ils réutiliseront ce client.
class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.groq.com/openai/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['GROQ_API_KEY'] ?? ''}',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Optionnel: Interceptor pour debugger les requêtes HTTP dans la console pendant le dev
    // dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }
}
