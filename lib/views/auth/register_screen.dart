import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/viewmodels/register_viewmodel.dart';
import 'package:taskmaster/viewmodels/settings_viewmodel.dart';
import 'package:taskmaster/views/auth/widgets/auth_text_field.dart';
import 'package:taskmaster/views/auth/widgets/social_button.dart';
import 'package:taskmaster/views/auth/widgets/auth_header.dart';
import 'package:taskmaster/utils/app_colors.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);
    final settingsVM = context.watch<SettingsViewModel>();
    final isDarkMode =
        settingsVM.isDarkMode ||
        (settingsVM.profile == null &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Scaffold(
      backgroundColor: AppColors.getBackground(isDarkMode),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [const Color(0xFF1E1E1E), const Color(0xFF121212)]
                : [
                    Colors.redAccent.withOpacity(0.8),
                    Colors.deepPurpleAccent.withOpacity(0.8),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: isDarkMode ? 0 : 12,
              color: AppColors.getSurface(isDarkMode),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: isDarkMode
                    ? BorderSide(color: AppColors.darkBorder)
                    : BorderSide.none,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    AuthHeader(
                      title: "TaskMaster",
                      subtitle: "Rejoignez-Nous",
                      caption: "Profitez des meilleures fonctionnalités",
                    ),

                    const SizedBox(height: 20),
                    AuthTextField(
                      viewModel.nameController,
                      label: "Entrez Votre Nom",
                      icon: Icons.person,
                    ),
                    AuthTextField(
                      viewModel.emailController,
                      label: "Entrez Votre Email",
                      icon: Icons.email,
                    ),
                    AuthTextField(
                      viewModel.passwordController,
                      label: "Entrez le Mot de passe",
                      icon: Icons.lock,
                      obscure: true,
                    ),
                    AuthTextField(
                      viewModel.confirmPasswordController,
                      label: "Confirmez le Mot de passe",
                      icon: Icons.lock,
                      obscure: true,
                    ),

                    if (viewModel.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                        ),
                        onPressed: viewModel.register,
                        child: const Text(
                          "S'enregistrer",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Text(
                      "ou se connecter avec",
                      style: TextStyle(
                        color: AppColors.getTextSecondary(isDarkMode),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialButton(
                          text: "Google",
                          backgroundColor: isDarkMode
                              ? AppColors.darkSurface
                              : Colors.white,
                          textColor: isDarkMode ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 12),
                        SocialButton(
                          text: "Facebook",
                          backgroundColor: const Color(0xFF1877F2),
                          textColor: Colors.white,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 12),
                    Text(
                      "Politique de Confidentialité • Contact • Conditions",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.getTextSecondary(
                          isDarkMode,
                        ).withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
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
