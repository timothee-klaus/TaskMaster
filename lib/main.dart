import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:taskmaster/utils/app_router.dart';
import 'package:taskmaster/utils/app_theme.dart';
import 'package:taskmaster/services/isar_service.dart';
import 'package:taskmaster/services/auth_service.dart';
import 'package:taskmaster/services/api/dio_client.dart';
import 'package:taskmaster/services/api/ai_service.dart';
import 'package:taskmaster/repositories/auth_repository.dart';
import 'package:taskmaster/repositories/task_repository.dart';
import 'package:taskmaster/repositories/user_repository.dart';
import 'package:taskmaster/repositories/ai_repository.dart';
import 'package:taskmaster/services/api/google_calendar_service.dart';
import 'package:taskmaster/services/notification_service.dart';
import 'package:taskmaster/viewmodels/auth_viewmodel.dart';
import 'package:taskmaster/viewmodels/task_viewmodel.dart';
import 'package:taskmaster/viewmodels/settings_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load hidden environment variables securely
  await dotenv.load(fileName: ".env");

  // 1. Initialisation des Services
  final isarService = IsarService();
  await isarService.db; // Attend l'ouverture de la base locale
  final authService = AuthService();
  final dioClient = DioClient();
  final aiService = AiService(dioClient);
  final notificationService = NotificationService();
  await notificationService.initialize();

  // 2. Initialisation des Repositories
  final userRepository = UserRepository(isarService);
  final taskRepository = TaskRepository(isarService);
  final authRepository = AuthRepository(authService, userRepository);
  final aiRepository = AiRepository(aiService);
  final googleCalendarService = GoogleCalendarService();

  // 3. Lancement de l'App avec MultiProvider
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: notificationService),
        ChangeNotifierProvider(create: (_) => AuthViewModel(authRepository)),
        ChangeNotifierProvider(
          create: (_) => TaskViewModel(
            taskRepository,
            aiRepository,
            userRepository,
            notificationService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              SettingsViewModel(userRepository, googleCalendarService),
        ),
      ],
      child: const TaskMasterApp(),
    ),
  );
}

class TaskMasterApp extends StatelessWidget {
  const TaskMasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsVM = context.watch<SettingsViewModel>();

    return MaterialApp.router(
      title: 'TaskMaster',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settingsVM.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
