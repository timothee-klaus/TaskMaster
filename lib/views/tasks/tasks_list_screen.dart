import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TasksListScreen extends StatefulWidget {
  const TasksListScreen({super.key});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen> {
  // Option pour basculer facilement entre la liste vide et la liste pleine
  bool _isEmpty = true;

  @override
  Widget build(BuildContext context) {
    if (_isEmpty) {
      return _buildEmptyState(context);
    }
    return _buildTasksList(context);
  }

  Widget _buildEmptyState(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const Icon(Icons.menu, color: Color(0xFF101828)),
        title: GestureDetector(
          // Bascule de test cachée : Appuyez sur le titre pour afficher la liste pleine
          onTap: () => setState(() => _isEmpty = !_isEmpty),
          child: const Text(
            'Mes Tâches',
            style: TextStyle(
              color: Color(0xFF101828),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: const [
          Icon(Icons.search, color: Color(0xFF101828)),
          SizedBox(width: 16),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.grey.shade100, height: 1.0),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Illustration Header
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Pink Background Circle
                    Container(
                      width: 160,
                      height: 160,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF1F2), // Light pink
                        shape: BoxShape.circle,
                      ),
                    ),
                    // Small dots
                    Positioned(
                      top: 40,
                      right: 15,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade200,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      left: 15,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD4CE),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    // Main Icon
                    const Icon(
                      Icons.assignment_late_outlined,
                      size: 80,
                      color: Color(0xFFFF998E),
                    ),
                    // Plus Badge
                    Positioned(
                      top: 55,
                      right: 55,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_circle_outline,
                          color: Color(0xFFFF5A4A),
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Aucune tâche pour le moment.',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF101828),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Commencez par organiser votre journée en\najoutant une nouvelle tâche. Tout commence\npar un petit pas.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF667085),
                ),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/create-task'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5A4A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  label: const Text(
                    'Créer une tâche',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTasksList(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDECEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.menu,
                    color: Color(0xFFFF5A4A),
                    size: 24,
                  ),
                ),
                GestureDetector(
                  // Bascule de test cachée : Appuyez sur le titre pour afficher la page vide
                  onTap: () => setState(() => _isEmpty = !_isEmpty),
                  child: const Text(
                    'TaskMaster',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF101828),
                    ),
                  ),
                ),
                const Icon(
                  Icons.filter_list,
                  color: Color(0xFF101828),
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher une tâche...',
                  hintStyle: TextStyle(color: Color(0xFF98A2B3)),
                  icon: Icon(Icons.search, color: Color(0xFF98A2B3)),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Segments
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F7),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Jour',
                          style: TextStyle(
                            color: Color(0xFFFF5A4A),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Semaine',
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Mois',
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Mes Tâches',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF101828),
                  ),
                ),
                Text(
                  "4 tâches aujourd'hui",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF667085),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Task Items
            GestureDetector(
              onTap: () => context.push('/task-details'),
              child: _buildTaskCard(
                chipLabel: 'HAUTE',
                chipColor: const Color(0xFFFDECEE),
                chipTextColor: const Color(0xFFFF5A4A),
                time: '10:30 AM',
                title: "Révision design App Mobile",
                date: "Aujourd'hui, 24 Mai",
                isCompleted: false,
              ),
            ),
            const SizedBox(height: 16),
            _buildTaskCard(
              chipLabel: 'MOYENNE',
              chipColor: const Color(0xFFFEF0C7),
              chipTextColor: const Color(0xFFDC6803),
              time: '14:00 PM',
              title: "Meeting équipe Marketing",
              date: "Demain, 25 Mai",
              isCompleted: false,
            ),
            const SizedBox(height: 16),
            _buildTaskCard(
              chipLabel: 'BASSE',
              chipColor: const Color(0xFFD1FADF),
              chipTextColor: const Color(0xFF039855),
              time: '17:00 PM',
              title: "Achat fournitures bureau",
              date: "26 Mai",
              isCompleted: false,
            ),
            const SizedBox(height: 16),
            _buildCompletedTask(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required String chipLabel,
    required Color chipColor,
    required Color chipTextColor,
    required String time,
    required String title,
    required String date,
    required bool isCompleted,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: chipColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        chipLabel,
                        style: TextStyle(
                          color: chipTextColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      time,
                      style: const TextStyle(
                        color: Color(0xFF98A2B3),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF101828),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Color(0xFF98A2B3),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Color(0xFF667085),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 2),
            ),
            child: const Icon(Icons.check, color: Colors.transparent, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedTask() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F4F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'TERMINÉ',
                    style: TextStyle(
                      color: Color(0xFF98A2B3),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Envoyer rapport hebdomadaire",
                  style: TextStyle(
                    color: Color(0xFF98A2B3),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.done_all, size: 16, color: Color(0xFFD0D5DD)),
                    SizedBox(width: 6),
                    Text(
                      "Terminé à 09:15",
                      style: TextStyle(color: Color(0xFF98A2B3), fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF5A9CFF),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
