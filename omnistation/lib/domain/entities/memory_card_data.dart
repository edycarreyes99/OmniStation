enum CardType {
  ps1,
  ps2,
}

class MemoryCardData {
  final int slot;
  final CardType type;
  final int blocksFree;
  final int totalBlocks;
  final bool isFormatted;

  const MemoryCardData({
    required this.slot,
    required this.type,
    required this.blocksFree,
    required this.totalBlocks,
    required this.isFormatted,
  });

  MemoryCardData copyWith({
    int? slot,
    CardType? type,
    int? blocksFree,
    int? totalBlocks,
    bool? isFormatted,
  }) {
    return MemoryCardData(
      slot: slot ?? this.slot,
      type: type ?? this.type,
      blocksFree: blocksFree ?? this.blocksFree,
      totalBlocks: totalBlocks ?? this.totalBlocks,
      isFormatted: isFormatted ?? this.isFormatted,
    );
  }
}
