/// Real filesystem storage breakdown for OmniStation.
class StorageBreakdown {
  final int totalUsedBytes;
  final int gamesBytes;
  final int savesBytes;
  final int memoryCardsBytes;
  final int cacheBytes;
  final int freeDeviceBytes;

  const StorageBreakdown({
    required this.totalUsedBytes,
    required this.gamesBytes,
    required this.savesBytes,
    required this.memoryCardsBytes,
    required this.cacheBytes,
    required this.freeDeviceBytes,
  });

  static const StorageBreakdown empty = StorageBreakdown(
    totalUsedBytes: 0,
    gamesBytes: 0,
    savesBytes: 0,
    memoryCardsBytes: 0,
    cacheBytes: 0,
    freeDeviceBytes: 0,
  );
}
