import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:taskmaster/views/auth/login_screen.dart';
import 'package:taskmaster/views/auth/register_screen.dart';
import 'package:taskmaster/views/home/home_screen.dart';
import 'package:taskmaster/views/tasks/create_task_screen.dart';
import 'package:taskmaster/views/tasks/tasks_list_screen.dart';
import 'package:taskmaster/views/tasks/task_details_screen.dart';
import 'package:taskmaster/views/agenda/agenda_screen.dart';
import 'package:taskmaster/views/settings/settings_screen.dart';
import 'package:taskmaster/views/main_layout.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/create-task',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CreateTaskScreen(),
    ),
    GoRoute(
      path: '/task-details',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TaskDetailsScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/tasks',
          builder: (context, state) => const TasksListScreen(),
        ),
        GoRoute(
          path: '/agenda',
          builder: (context, state) => const AgendaScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
  ],
);
