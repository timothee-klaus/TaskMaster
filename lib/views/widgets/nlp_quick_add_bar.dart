import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/repositories/ai_repository.dart';
import 'package:taskmaster/utils/app_colors.dart';
import 'package:taskmaster/viewmodels/settings_viewmodel.dart';
import 'package:taskmaster/viewmodels/task_viewmodel.dart';
import 'package:taskmaster/models/models.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class NlpQuickAddBar extends StatefulWidget {
  const NlpQuickAddBar({super.key});

  @override
  State<NlpQuickAddBar> createState() => _NlpQuickAddBarState();
}

class _NlpQuickAddBarState extends State<NlpQuickAddBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final stt.SpeechToText _speechToText = stt.SpeechToText();

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  bool _isLoading = false;
  bool _speechEnabled = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _controller.addListener(_updateAiBarStatus);
  }

  void _updateAiBarStatus() {
    if (!mounted) return;
    final hasText = _controller.text.trim().isNotEmpty;
    context.read<TaskViewModel>().setAiBarActive(_isListening || hasText);
  }

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    if (mounted) setState(() {});
  }

  void _startListening() async {
    if (!_speechEnabled) return;

    // Clear previous text
    _controller.clear();

    await _speechToText.listen(
      onResult: (result) {
        if (mounted) {
          setState(() {
            _controller.text = result.recognizedWords;
          });
          // Move cursor to end
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );

          if (result.finalResult && result.recognizedWords.trim().isNotEmpty) {
            _submit();
          }
        }
      },
      localeId: 'fr_FR',
      // Auto stop after a few seconds of silence
      pauseFor: const Duration(seconds: 3),
    );

    setState(() {
      _isListening = true;
    });
    _updateAiBarStatus();
  }

  void _toggleListening() {
    if (_isListening) {
      _submit();
    } else {
      _startListening();
    }
  }

  Future<void> _submit() async {
    if (_isListening) await _speechToText.stop();

    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isListening = false;
      _isLoading = true;
    });
    _updateAiBarStatus();

    try {
      final aiRepo = context.read<AiRepository>();
      final taskVM = context.read<TaskViewModel>();
      final Task? parsedTask = await aiRepo.parseTaskFromNaturalLanguage(text);

      if (!mounted) return;

      if (parsedTask != null) {
        // If the parsed task has enough info, just add it!
        if (parsedTask.title != null && parsedTask.title!.isNotEmpty) {
          final description = parsedTask.description ?? '';
          final bool needsPlanning = description.contains(
            '[REQUÊTE_PLANIFICATION]',
          );

          if (needsPlanning) {
            parsedTask.description = description
                .replaceAll('[REQUÊTE_PLANIFICATION]', '')
                .trim();
          }

          await taskVM.addTask(parsedTask);
          _controller.clear();

          if (mounted) {
            if (needsPlanning) {
              // Trigger smart planning and go to details to see the result
              taskVM.generateSmartSubtasks(parsedTask);
              context.push('/task-details', extra: parsedTask);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Planification de la tâche en cours...'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tâche ajoutée : ${parsedTask.title}'),
                  action: SnackBarAction(
                    label: 'MODIFIER',
                    onPressed: () {
                      if (mounted)
                        context.push('/create-task', extra: parsedTask);
                    },
                  ),
                ),
              );
            }
          }
        } else {
          context.push('/create-task', extra: parsedTask);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible d\'analyser votre demande.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur : $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _updateAiBarStatus();
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateAiBarStatus);
    _controller.dispose();
    _speechToText.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<SettingsViewModel>().isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.getSurface(isDarkMode),
        border: Border(
          top: BorderSide(color: AppColors.getBorder(isDarkMode), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: _toggleListening,
                  child: ScaleTransition(
                    scale: _isListening
                        ? _pulseAnimation
                        : const AlwaysStoppedAnimation(1.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _isListening
                            ? AppColors.error.withValues(alpha: 0.1)
                            : AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: _isListening
                            ? AppColors.error
                            : AppColors.primary,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: !_isLoading,
                style: TextStyle(color: AppColors.getTextPrimary(isDarkMode)),
                decoration: InputDecoration(
                  hintText: _isListening
                      ? 'Écoute en cours...'
                      : 'Dictez ou tapez votre tâche...',
                  hintStyle: TextStyle(
                    color: _isListening
                        ? AppColors.error
                        : AppColors.getTextSecondary(
                            isDarkMode,
                          ).withValues(alpha: 0.5),
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _submit(),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, child) {
                final hasText = value.text.trim().isNotEmpty;
                if (!hasText) return const SizedBox.shrink();

                return IconButton(
                  icon: const Icon(
                    Icons.send_rounded,
                    color: AppColors.primary,
                  ),
                  onPressed: _isLoading ? null : _submit,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
