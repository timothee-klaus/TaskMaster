import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/models/models.dart';
import 'package:taskmaster/viewmodels/task_viewmodel.dart';
import 'package:taskmaster/viewmodels/settings_viewmodel.dart';
import 'package:taskmaster/utils/app_colors.dart';
import 'package:taskmaster/views/tasks/widgets/create_task_widgets.dart';

class CreateTaskScreen extends StatefulWidget {
  final Task? taskToEdit;
  const CreateTaskScreen({super.key, this.taskToEdit});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool _autoPlan = true;
  bool _isFlexible = false;
  double _duration = 2.5; // in hours
  TaskPriority _priority = TaskPriority.medium;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      final t = widget.taskToEdit!;
      _titleController.text = t.title ?? '';
      _descController.text = t.description ?? '';
      _autoPlan = false;
      _isFlexible = t.isFlexible;
      _duration = (t.estimatedDurationMinutes / 60.0);
      _priority = t.priority;
      if (t.dueDate != null) {
        _dueDate = t.dueDate!;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un titre.')),
      );
      return;
    }

    final taskVM = context.read<TaskViewModel>();

    final newTask = widget.taskToEdit ?? Task();
    newTask
      ..title = _titleController.text.trim()
      ..description = _descController.text.trim()
      ..dueDate = _dueDate
      ..priority = _priority
      ..status = widget.taskToEdit?.status ?? TaskStatus.todo
      ..estimatedDurationMinutes = (_duration * 60).toInt()
      ..autoSchedulingEnabled = _autoPlan
      ..isFlexible = _isFlexible;

    // Save task instantaneously
    taskVM.addTask(newTask).then((_) {
      // Autogenerate AI Subtasks if requested in background
      if (_autoPlan) {
        taskVM.generateSmartSubtasks(newTask);
      }
    });

    context.pop();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDate),
      );
      if (time != null) {
        setState(() {
          _dueDate = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsVM = context.watch<SettingsViewModel>();
    final isDarkMode = settingsVM.isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getBackground(isDarkMode),
      appBar: AppBar(
        backgroundColor: AppColors.getBackground(isDarkMode),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.getTextPrimary(isDarkMode),
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.taskToEdit != null ? 'Modifier la tâche' : 'Créer une tâche',
          style: TextStyle(
            color: AppColors.getTextPrimary(isDarkMode),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(
                      'INFORMATIONS GÉNÉRALES',
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 16),
                    FormLabel('Titre de la tâche', isDarkMode: isDarkMode),
                    const SizedBox(height: 8),
                    CustomTextField(
                      'Ex: Finaliser le rapport trimestriel',
                      controller: _titleController,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 24),
                    FormLabel('Description', isDarkMode: isDarkMode),
                    const SizedBox(height: 8),
                    CustomTextField(
                      'Ajouter des détails sur les objectifs...',
                      maxLines: 4,
                      controller: _descController,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 32),

                    SectionTitle('PLANIFICATION', isDarkMode: isDarkMode),
                    const SizedBox(height: 16),

                    DateTimePickerBtn(
                      dueDate: _dueDate,
                      onTap: _pickDateTime,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 24),

                    FormLabel('Priorité', isDarkMode: isDarkMode),
                    const SizedBox(height: 8),
                    PriorityDropdown(
                      value: _priority,
                      onChanged: (val) {
                        if (val != null) setState(() => _priority = val);
                      },
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 32),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Durée estimée',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.getTextPrimary(isDarkMode),
                          ),
                        ),
                        Text(
                          '${_duration.toStringAsFixed(1).replaceAll('.0', '')} h',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DurationSlider(
                      value: _duration,
                      onChanged: (val) => setState(() => _duration = val),
                    ),
                    const SizedBox(height: 32),

                    AiAutoPlanSwitch(
                      value: _autoPlan,
                      onChanged: (val) => setState(() => _autoPlan = val),
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 16),
                    FlexibleTimeSwitch(
                      value: _isFlexible,
                      onChanged: (val) => setState(() => _isFlexible = val),
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 32),

                    // Assignees
                    SizedBox(
                      height: 40,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            child: _buildAvatar(
                              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
                              isDarkMode,
                            ),
                          ),
                          Positioned(
                            left: 24, // overlapping
                            child: _buildAvatar(
                              'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&q=80',
                              isDarkMode,
                            ),
                          ),
                          Positioned(
                            left: 48, // overlapping
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? AppColors.darkSurface
                                    : const Color(0xFFF2F4F7),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.getSurface(isDarkMode),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: AppColors.getTextSecondary(isDarkMode),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: AppColors.getSurface(isDarkMode),
                boxShadow: isDarkMode
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        ),
                      ],
                border: isDarkMode
                    ? Border(top: BorderSide(color: AppColors.darkBorder))
                    : null,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5A4A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    widget.taskToEdit != null
                        ? 'Enregistrer'
                        : 'Créer l\'objectif',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String url, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.getSurface(isDarkMode), width: 2),
      ),
      child: CircleAvatar(radius: 16, backgroundImage: NetworkImage(url)),
    );
  }
}
