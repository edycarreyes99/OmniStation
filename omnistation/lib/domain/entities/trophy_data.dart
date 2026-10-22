enum TrophyGrade {
  bronze,
  silver,
  gold,
  platinum,
}

class TrophyData {
  final int id;
  final String name;
  final String description;
  final TrophyGrade grade;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const TrophyData({
    required this.id,
    required this.name,
    required this.description,
    required this.grade,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  TrophyData copyWith({
    int? id,
    String? name,
    String? description,
    TrophyGrade? grade,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return TrophyData(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      grade: grade ?? this.grade,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}
