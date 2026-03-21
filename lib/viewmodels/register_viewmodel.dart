import 'package:flutter/material.dart';
import '../models/user.dart';

class RegisterViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? errorMessage;

  void register() {
    if (passwordController.text != confirmPasswordController.text) {
      errorMessage = "Les mots de passe ne correspondent pas";
      notifyListeners();
      return;
    }

    final user = User(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    // Ici tu peux appeler ton service d’API ou Firebase
    print("Utilisateur enregistré : ${user.name}, ${user.email}");
  }
}
