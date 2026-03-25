import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/viewmodels/task_viewmodel.dart';
import 'package:taskmaster/viewmodels/settings_viewmodel.dart';
import 'package:taskmaster/models/models.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:go_router/go_router.dart';
import 'package:taskmaster/utils/app_colors.dart';
import 'package:taskmaster/views/widgets/nlp_quick_add_bar.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  late DateTime _currentMonth;
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    // Tente de charger le format français si possible, sinon repli sur le défaut
    initializeDateFormatting('fr_FR', null).catchError((_) {});
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month, 1);
    _selectedDay = now.day;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskVM = context.read<TaskViewModel>();
      taskVM.setAgendaDate(now);
      // fetchGoogleEvents est déjà appelé dans setAgendaDate
    });
  }

  void _onDaySelected(int day) {
    setState(() => _selectedDay = day);
    final date = DateTime(_currentMonth.year, _currentMonth.month, day);
    context.read<TaskViewModel>().setAgendaDate(date);
    // fetchGoogleEvents est appelé automatiquement par setAgendaDate
  }

  @override
  Widget build(BuildContext context) {
    final taskVM = context.watch<TaskViewModel>();
    final settingsVM = context.watch<SettingsViewModel>();
    final isDarkMode = settingsVM.isDarkMode;
    final agendaTasks = taskVM.agendaTasks;
    // Calculation du nombre de jours
    final daysInMonth = DateUtils.getDaysInMonth(
      _currentMonth.year,
      _currentMonth.month,
    );
    final monthName = DateFormat('MMMM yyyy', 'fr_FR').format(_currentMonth);

    return Scaffold(
      backgroundColor: AppColors.getBackground(isDarkMode),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Agenda',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: AppColors.getTextPrimary(isDarkMode),
                      letterSpacing: -0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push('/settings'),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: taskVM.userProfile?.avatarUrl != null
                          ? NetworkImage(taskVM.userProfile!.avatarUrl!)
                          : const NetworkImage(
                              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
                            ),
                    ),
                  ),
                ],
              ),
            ),

            // Month Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        monthName[0].toUpperCase() +
                            monthName.substring(1), // Capitalize
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(isDarkMode),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.getTextSecondary(isDarkMode),
                        size: 20,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildMonthNavButton(
                        icon: Icons.chevron_left,
                        onTap: () {
                          setState(() {
                            _currentMonth = DateTime(
                              _currentMonth.year,
                              _currentMonth.month - 1,
                              1,
                            );
                            _selectedDay = 1;
                            _onDaySelected(_selectedDay);
                          });
                        },
                        isDarkMode: isDarkMode,
                      ),
                      const SizedBox(width: 8),
                      _buildMonthNavButton(
                        icon: Icons.chevron_right,
                        onTap: () {
                          setState(() {
                            _currentMonth = DateTime(
                              _currentMonth.year,
                              _currentMonth.month + 1,
                              1,
                            );
                            _selectedDay = 1;
                            _onDaySelected(_selectedDay);
                          });
                        },
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Horizontal Days
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: daysInMonth,
                itemBuilder: (context, index) {
                  final day = index + 1;
                  final isSelected = day == _selectedDay;

                  final dateToCheck = DateTime(
                    _currentMonth.year,
                    _currentMonth.month,
                    day,
                  );
                  final weekDays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                  final dayName = weekDays[dateToCheck.weekday - 1];

                  return GestureDetector(
                    onTap: () => _onDaySelected(day),
                    child: Container(
                      width: 56,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.getSurface(isDarkMode),
                        borderRadius: BorderRadius.circular(16),
                        border: isSelected
                            ? null
                            : Border.all(
                                color: isDarkMode
                                    ? AppColors.darkBorder
                                    : Colors.transparent,
                              ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayName,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white70
                                  : AppColors.getTextSecondary(isDarkMode),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            day.toString(),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.getTextPrimary(isDarkMode),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // Timeline
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(isDarkMode),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: isDarkMode
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 32, bottom: 100),
                  child: agendaTasks.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? AppColors.darkSurface.withOpacity(0.5)
                                        : AppColors.getSurface(isDarkMode),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.event_available_rounded,
                                    size: 64,
                                    color: AppColors.primary.withOpacity(0.5),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Journée libre !',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.getTextPrimary(isDarkMode),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                  ),
                                  child: Text(
                                    'Vous n\'avez aucune tâche prévue aujourd\'hui. Profitez-en pour vous détendre ou planifier de nouveaux objectifs.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.getTextSecondary(
                                        isDarkMode,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            ...(() {
                              final List<Widget> mergedItems = [];

                              for (final task in agendaTasks) {
                                final timeStr = task.dueDate != null
                                    ? DateFormat('HH:mm').format(task.dueDate!)
                                    : 'Journée';
                                bool isActive =
                                    task.status == TaskStatus.inProgress;

                                Color bgColor = AppColors.getSurface(
                                  isDarkMode,
                                );
                                Color accentColor = AppColors.primary;

                                switch (task.priority) {
                                  case TaskPriority.high:
                                    bgColor = isDarkMode
                                        ? const Color(0xFF442323)
                                        : const Color(0xFFFDECEE);
                                    accentColor = const Color(0xFFFF5A4A);
                                    break;
                                  case TaskPriority.medium:
                                    bgColor = isDarkMode
                                        ? const Color(0xFF443923)
                                        : const Color(0xFFFEF0C7);
                                    accentColor = const Color(0xFFDC6803);
                                    break;
                                  case TaskPriority.low:
                                    bgColor = isDarkMode
                                        ? const Color(0xFF232D44)
                                        : const Color(0xFFF8F9FC);
                                    accentColor = const Color(0xFF475467);
                                    break;
                                }

                                mergedItems.add(
                                  _buildTimelineEvent(
                                    context,
                                    timeStr,
                                    task.title ?? '',
                                    (task.description != null &&
                                            task.description!.isNotEmpty)
                                        ? task.description!
                                        : 'Tâche locale',
                                    bgColor,
                                    accentColor,
                                    isDarkMode: isDarkMode,
                                    isActive: isActive,
                                  ),
                                );
                              }

                              return mergedItems;
                            })(),
                          ],
                        ),
                ),
              ),
            ),
            const NlpQuickAddBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthNavButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: isDarkMode ? Border.all(color: AppColors.darkBorder) : null,
        ),
        child: Icon(
          icon,
          color: AppColors.getTextPrimary(isDarkMode),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildTimelineEvent(
    BuildContext context,
    String time,
    String title,
    String subtitle,
    Color bgColor,
    Color accentColor, {
    required bool isDarkMode,
    bool isActive = false,
    bool isGoogle = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 45,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    color: isActive
                        ? AppColors.getTextPrimary(isDarkMode)
                        : AppColors.getTextSecondary(isDarkMode),
                  ),
                ),
                if (isGoogle)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'G',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: isActive
                      ? accentColor
                      : (isDarkMode ? AppColors.darkBackground : Colors.white),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive
                        ? accentColor
                        : AppColors.getBorder(isDarkMode),
                    width: 3,
                  ),
                ),
              ),
              Container(
                width: 2,
                height: 80,
                color: AppColors.getBorder(isDarkMode),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
                border: isActive
                    ? Border.all(
                        color: accentColor.withOpacity(0.3),
                        width: 1.5,
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.getTextPrimary(isDarkMode),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextTertiary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isActive)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 12,
                            backgroundImage: NetworkImage(
                              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'En cours...',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
