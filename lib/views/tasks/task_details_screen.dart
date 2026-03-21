import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF101828)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Détails de la tâche',
          style: TextStyle(
            color: Color(0xFF101828),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF101828)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF101828)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFFF5A4A)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
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
                    // Chips
                    Row(
                      children: [
                        _buildChip(
                          'EN COURS',
                          const Color(0xFFEFF6FF),
                          const Color(0xFF1D4ED8),
                        ),
                        const SizedBox(width: 8),
                        _buildChip(
                          'PRIORITÉ HAUTE',
                          const Color(0xFFFFF7ED),
                          const Color(0xFFC2410C),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Title
                    const Text(
                      'Refonte du tableau de bord utilisateur',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF101828),
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Info Row
                    Row(
                      children: const [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: Color(0xFF667085),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Échéance: 24 Oct',
                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Color(0xFF667085),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Assigné à moi',
                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Progression
                    _buildSectionTitle('PROGRESSION'),
                    const SizedBox(height: 16),
                    _buildTimelineItem(
                      title: 'Tâche créée',
                      subtitle: 'Lundi, 10:30 par Sophie L.',
                      isActive: true,
                      isLast: false,
                    ),
                    _buildTimelineItem(
                      title: 'Début des travaux',
                      subtitle: 'Mardi, 09:15',
                      isActive: true,
                      isLast: false,
                    ),
                    _buildTimelineItem(
                      title: 'Révision finale',
                      subtitle: 'En attente',
                      isActive: false,
                      isLast: true,
                    ),

                    const SizedBox(height: 32),

                    // Sous-Tâches
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle('SOUS-TÂCHES'),
                        _buildChip(
                          '2/4 terminées',
                          const Color(0xFFFDECEE),
                          const Color(0xFFFF5A4A),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSubtaskItem(
                      'Audit de l\'existant',
                      isCompleted: true,
                    ),
                    const SizedBox(height: 12),
                    _buildSubtaskItem(
                      'Wireframes basse fidélité',
                      isCompleted: true,
                    ),
                    const SizedBox(height: 12),
                    _buildSubtaskItem(
                      'Maquettes haute fidélité',
                      isCompleted: false,
                    ),
                    const SizedBox(height: 12),
                    _buildSubtaskItem('Tests utilisateurs', isCompleted: false),

                    const SizedBox(height: 32),

                    // Notes
                    _buildSectionTitle('NOTES & INSTRUCTIONS'),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFFECDD3),
                        ), // soft red border
                      ),
                      child: const Text(
                        "Assurez-vous d'utiliser la nouvelle palette de couleurs définie dans le guide de style 2024. Le client a demandé une attention particulière sur la fluidité des graphiques de données en temps réel. Ne pas oublier de prévoir un mode sombre natif.",
                        style: TextStyle(
                          color: Color(0xFF475467),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Pièces Jointes
                    _buildSectionTitle('PIÈCES JOINTES'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildAttachmentItem(
                            Icons.description_outlined,
                            Colors.blueAccent,
                            'Spec_V2.pdf',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildAttachmentItem(
                            Icons.image_outlined,
                            Colors.purpleAccent,
                            'Styleguide.fig',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Sticky Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5A4A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Marquer comme terminé',
                    style: TextStyle(
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

  Widget _buildChip(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Color(0xFF667085),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFFFF5A4A)
                    : const Color(0xFFEAECF0),
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40, // line height
                margin: const EdgeInsets.only(top: 4, bottom: 4),
                color: isActive
                    ? const Color(0xFFFEE4E2)
                    : const Color(0xFFEAECF0),
              ),
            if (isLast) const SizedBox(height: 4), // Prevents cutoff if needed
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isActive
                    ? const Color(0xFF101828)
                    : const Color(0xFF98A2B3),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: isActive
                    ? const Color(0xFF667085)
                    : const Color(0xFF98A2B3),
              ),
            ),
            if (!isLast) const SizedBox(height: 4),
          ],
        ),
      ],
    );
  }

  Widget _buildSubtaskItem(String title, {required bool isCompleted}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(
            isCompleted
                ? Icons.check_circle_outline
                : Icons.radio_button_unchecked,
            color: isCompleted ? Colors.blueAccent : Colors.grey.shade400,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isCompleted
                  ? const Color(0xFF98A2B3)
                  : const Color(0xFF101828),
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentItem(IconData icon, Color iconColor, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF101828),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
