import 'package:google_sign_in/google_sign_in.dart';

/// Service that simulates external Authentication API calls.
class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize(
        serverClientId:
            '592187326437-psvftks38oc11p0d3n3echmhi8t9dl7j.apps.googleusercontent.com',
      );
      _isInitialized = true;
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Simulate basic validation
    if (email.contains('@') && password.length >= 6) {
      return {'token': 'ey-dummy-jwt-token', 'userId': 'local-user-id'};
    }
    throw Exception('Identifiants invalides');
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      await _ensureInitialized();
      // Dans cette version du plugin, authenticate() renvoie le compte
      final account = await _googleSignIn.authenticate();

      return {
        'name': account.displayName ?? 'Utilisateur Google',
        'email': account.email,
        'photoUrl': account.photoUrl,
        'token': 'google-dummy-token',
      };
    } catch (e) {
      throw Exception("Erreur d'authentification Google: $e");
    }
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
