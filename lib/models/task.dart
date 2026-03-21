class Task {
  String nom;
  String description;
  DateTime date;
  Priority priorite;
  int dureeEstimee; // en minutes

  Task({
    required this.nom,
    required this.description,
    required this.date,
    required this.priorite,
    required this.dureeEstimee,
  });
}

enum Priority { haute, moyenne, basse }
