/// Service that simulates external Authentication API calls.
/// In a real app, this would use http.Client or Dio to connect to Firebase/REST API.
class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Simulate basic validation
    if (email.contains('@') && password.length >= 6) {
      return {'token': 'ey-dummy-jwt-token', 'userId': 'local-user-id'};
    }
    throw Exception('Identifiants invalides');
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (email.contains('@') && password.length >= 6) {
      return {'token': 'ey-dummy-jwt-token', 'userId': 'local-user-id'};
    }
    throw Exception('Erreur lors de la création du compte');
  }
}
