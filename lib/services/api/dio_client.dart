import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

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

    // Logs sublimes dans la console pour debugger le trafic API IA
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }
}
