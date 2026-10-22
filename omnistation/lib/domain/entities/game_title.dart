enum ConsolePlatform {
  snes,
  ps1,
  ps2,
  ps3,
}

class GameTitle {
  final String id;
  final String title;
  final ConsolePlatform platform;
  final String path;
  final String category;
  final String serial;
  final int fileSizeBytes;
  final DateTime? dateAdded;

  const GameTitle({
    required this.id,
    required this.title,
    required this.platform,
    required this.path,
    this.category = 'DG',
    required this.serial,
    this.fileSizeBytes = 0,
    this.dateAdded,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'platform': platform.name,
        'path': path,
        'category': category,
        'serial': serial,
        'fileSizeBytes': fileSizeBytes,
        'dateAdded': dateAdded?.toIso8601String(),
      };

  factory GameTitle.fromJson(Map<String, dynamic> json) => GameTitle(
        id: json['id'] as String,
        title: json['title'] as String,
        platform: ConsolePlatform.values.byName(json['platform'] as String),
        path: json['path'] as String,
        category: json['category'] as String? ?? 'DG',
        serial: json['serial'] as String? ?? 'OMNI00001',
        fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt() ?? 0,
        dateAdded: json['dateAdded'] != null
            ? DateTime.tryParse(json['dateAdded'] as String)
            : null,
      );

  GameTitle copyWith({
    String? id,
    String? title,
    ConsolePlatform? platform,
    String? path,
    String? category,
    String? serial,
    int? fileSizeBytes,
    DateTime? dateAdded,
  }) {
    return GameTitle(
      id: id ?? this.id,
      title: title ?? this.title,
      platform: platform ?? this.platform,
      path: path ?? this.path,
      category: category ?? this.category,
      serial: serial ?? this.serial,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameTitle &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
