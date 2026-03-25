import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/viewmodels/auth_viewmodel.dart';
import 'package:taskmaster/viewmodels/settings_viewmodel.dart';
import 'package:taskmaster/utils/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final authVM = context.read<AuthViewModel>();
    final success = await authVM.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      context.read<SettingsViewModel>().refreshProfile();
      context.go('/home');
    }
  }

  Future<void> _handleGoogleLogin() async {
    final authVM = context.read<AuthViewModel>();
    final success = await authVM.signInWithGoogle();

    if (success && mounted) {
      context.read<SettingsViewModel>().refreshProfile();
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsVM = context.watch<SettingsViewModel>();
    final authVM = context.watch<AuthViewModel>();
    final isDarkMode =
        settingsVM.isDarkMode ||
        (settingsVM.profile == null &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);

    return Scaffold(
      backgroundColor: AppColors.getBackground(isDarkMode),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset('assets/images/logo.png')),

                Text(
                  'Bon retour !',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimary(isDarkMode),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connectez-vous pour gérer vos tâches.',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.getTextSecondary(isDarkMode),
                  ),
                ),
                const SizedBox(height: 40),

                // Email Field
                _buildLabel('Email', isDarkMode),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hint: 'exemple@gmail.com',
                  isDarkMode: isDarkMode,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 20),

                // Password Field
                _buildLabel('Mot de passe', isDarkMode),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hint: '••••••••',
                  isDarkMode: isDarkMode,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.getTextSecondary(isDarkMode),
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),

                if (authVM.errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    authVM.errorMessage!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 14,
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Login Button
                _buildPrimaryButton(
                  onPressed: authVM.isLoading ? null : _handleLogin,
                  label: 'Se connecter',
                  isLoading: authVM.isLoading,
                ),

                const SizedBox(height: 20),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: AppColors.getBorder(isDarkMode)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'OU',
                        style: TextStyle(
                          color: AppColors.getTextSecondary(isDarkMode),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(color: AppColors.getBorder(isDarkMode)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Google Button
                _buildGoogleButton(
                  onPressed: authVM.isLoading ? null : _handleGoogleLogin,
                  isDarkMode: isDarkMode,
                ),

                const SizedBox(height: 40),

                // Footer
                Center(
                  child: GestureDetector(
                    onTap: () => context.go(
                      '/home',
                    ), // Temporaire: vers Home directement
                    child: RichText(
                      text: TextSpan(
                        text: "Pas encore de compte ? ",
                        style: TextStyle(
                          color: AppColors.getTextSecondary(isDarkMode),
                        ),
                        children: [
                          TextSpan(
                            text: "S'inscrire",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label, bool isDarkMode) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.getTextPrimary(isDarkMode),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDarkMode,
    bool obscureText = false,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.getBorder(isDarkMode)),
        boxShadow: isDarkMode
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: AppColors.getTextPrimary(isDarkMode)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.getTextSecondary(isDarkMode).withOpacity(0.5),
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: AppColors.getTextSecondary(isDarkMode),
                  size: 20,
                )
              : null,
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required VoidCallback? onPressed,
    required String label,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildGoogleButton({
    required VoidCallback? onPressed,
    required bool isDarkMode,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.getBorder(isDarkMode)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: isDarkMode
              ? AppColors.darkSurface.withOpacity(0.3)
              : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/google_icon.svg',
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'Continuer avec Google',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.getTextPrimary(isDarkMode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
