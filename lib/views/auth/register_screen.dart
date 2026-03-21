import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/viewmodels/register_viewmodel.dart';
import 'package:taskmaster/views/auth/widgets/auth_text_field.dart';
import 'package:taskmaster/views/auth/widgets/social_button.dart';
import 'package:taskmaster/views/auth/widgets/auth_header.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.deepPurpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    AuthHeader(
                      title: "TaskMaster",
                      subtitle: "Rejoignez-Nous",
                      caption: "Profitez des meilleures fonctionnalités",
                    ),

                    SizedBox(height: 20),
                    AuthTextField(viewModel.nameController, label: "Entrez Votre Nom", icon: Icons.person),
                    AuthTextField(viewModel.emailController, label: "Entrez Votre Email", icon: Icons.email),
                    AuthTextField(viewModel.passwordController, label: "Entrez le Mot de passe", icon: Icons.lock, obscure: true),
                    AuthTextField(viewModel.confirmPasswordController, label: "Confirmez le Mot de passe", icon: Icons.lock, obscure: true),

                    if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(viewModel.errorMessage!,
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),

                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.redAccent,
                      ),
                      onPressed: viewModel.register,
                      child: Text("S'enregistrer", style: TextStyle(fontSize: 18)),
                    ),

                    SizedBox(height: 20),
                    Text("ou se connecter avec"),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialButton(text: "Google", backgroundColor: Colors.white, textColor: Colors.black),
                        SizedBox(width: 12),
                        SocialButton(text: "Facebook", backgroundColor: Colors.blueAccent, textColor: Colors.white),
                      ],
                    ),

                    SizedBox(height: 20),
                    Divider(),
                    Text("Politique de Confidentialité • Contact • Conditions",
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  
}
