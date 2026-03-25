import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/utils/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final bool isDarkMode;

  const SectionTitle(this.title, {super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.getTextSecondary(isDarkMode).withValues(alpha: 0.8),
        letterSpacing: 1.2,
      ),
    );
  }
}

class FormLabel extends StatelessWidget {
  final String label;
  final bool isDarkMode;

  const FormLabel(this.label, {super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: AppColors.getTextPrimary(isDarkMode),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final int maxLines;
  final TextEditingController? controller;
  final bool isDarkMode;

  const CustomTextField(
    this.hint, {
    super.key,
    this.maxLines = 1,
    this.controller,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: AppColors.getTextPrimary(isDarkMode)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.getTextSecondary(isDarkMode).withValues(alpha: 0.5),
          fontSize: 15,
        ),
        filled: true,
        fillColor: AppColors.getSurface(isDarkMode),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.getBorder(isDarkMode),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.getBorder(isDarkMode),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

class DateTimePickerBtn extends StatelessWidget {
  final DateTime dueDate;
  final VoidCallback onTap;
  final bool isDarkMode;

  const DateTimePickerBtn({
    super.key,
    required this.dueDate,
    required this.onTap,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.getSurface(isDarkMode),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.getBorder(isDarkMode)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : const Color(0xFFFDECEE),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Échéance',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.getTextPrimary(isDarkMode),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMM yyyy, HH:mm').format(dueDate),
                    style: TextStyle(
                      color: AppColors.getTextSecondary(isDarkMode),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF98A2B3)),
          ],
        ),
      ),
    );
  }
}

class PriorityDropdown extends StatelessWidget {
  final TaskPriority value;
  final ValueChanged<TaskPriority?> onChanged;
  final bool isDarkMode;

  const PriorityDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.getSurface(isDarkMode),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.getBorder(isDarkMode)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TaskPriority>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.getTextSecondary(isDarkMode),
          ),
          items: TaskPriority.values.map((p) {
            String label = '';
            switch (p) {
              case TaskPriority.low:
                label = 'BASSE';
                break;
              case TaskPriority.medium:
                label = 'MOYENNE';
                break;
              case TaskPriority.high:
                label = 'HAUTE';
                break;
            }
            return DropdownMenuItem(
              value: p,
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.getTextSecondary(isDarkMode),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class DurationSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const DurationSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        activeTrackColor: const Color(0xFFFF5A4A),
        inactiveTrackColor: Colors.grey.shade200,
        thumbColor: const Color(0xFFFF5A4A),
        overlayColor: const Color(0xFFFF5A4A).withValues(alpha: 0.2),
      ),
      child: Slider(value: value, min: 0, max: 8, onChanged: onChanged),
    );
  }
}

class AiAutoPlanSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isDarkMode;

  const AiAutoPlanSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.primary.withValues(alpha: 0.1)
            : const Color(0xFFFDECEE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? AppColors.primary.withValues(alpha: 0.3)
              : const Color(0xFFFFD4CE),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Génération IA des sous-tâches',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.getTextPrimary(isDarkMode),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Décomposer via Groq Llama3',
                  style: TextStyle(
                    color: AppColors.getTextSecondary(isDarkMode),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFFFF5A4A),
          ),
        ],
      ),
    );
  }
}

class FlexibleTimeSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isDarkMode;

  const FlexibleTimeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppColors.info.withValues(alpha: 0.1)
            : const Color(0xFFE8F5FD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? AppColors.info.withValues(alpha: 0.3)
              : const Color(0xFFB3E5FC),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.wb_sunny_outlined, color: AppColors.info),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suggestion intelligente de créneau',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.getTextPrimary(isDarkMode),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pas d\'heure fixe, l\'IA propose le meilleur moment',
                  style: TextStyle(
                    color: AppColors.getTextSecondary(isDarkMode),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: AppColors.info,
          ),
        ],
      ),
    );
  }
}
