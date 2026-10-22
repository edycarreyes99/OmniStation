import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../domain/entities/memory_card_data.dart';
import '../../domain/entities/storage_breakdown.dart';

class StorageScreen extends ConsumerStatefulWidget {
  const StorageScreen({super.key});

  @override
  ConsumerState<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends ConsumerState<StorageScreen> {
  MemoryCardData? _ps1Card;
  MemoryCardData? _ps2Card;
  StorageBreakdown? _breakdown;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadStorageData();
  }

  Future<void> _loadStorageData() async {
    final useCase = ref.read(manageMemoryCardUseCaseProvider);
    final card1Res = await useCase.getCard(1, CardType.ps1);
    final card2Res = await useCase.getCard(2, CardType.ps2);
    final breakdownRes = await useCase.getStorageBreakdown();

    if (mounted) {
      setState(() {
        _ps1Card = card1Res.getOrElse((_) => const MemoryCardData(
              slot: 1,
              type: CardType.ps1,
              blocksFree: 15,
              totalBlocks: 16,
              isFormatted: true,
            ));
        _ps2Card = card2Res.getOrElse((_) => const MemoryCardData(
              slot: 2,
              type: CardType.ps2,
              blocksFree: 8191,
              totalBlocks: 8192,
              isFormatted: true,
            ));
        _breakdown = breakdownRes.getOrElse((_) => StorageBreakdown.empty);
        _isLoading = false;
      });
    }
  }

  Future<void> _formatCard(int slot, CardType type) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.storageFormat),
        content: Text(l10n.storageFormatConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.storageFormat),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(manageMemoryCardUseCaseProvider).formatCard(slot, type);
      await _loadStorageData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.storageFormatSuccess)),
        );
      }
    }
  }

  Future<void> _clearCache() async {
    final l10n = AppLocalizations.of(context);
    await ref.read(manageMemoryCardUseCaseProvider).clearCache();
    await _loadStorageData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.storageClearCacheSuccess)),
      );
    }
  }

  String _formatBytes(int bytes, AppLocalizations l10n) {
    if (bytes >= 1024 * 1024 * 1024) {
      final gb = (bytes / (1024 * 1024 * 1024)).toStringAsFixed(2);
      return l10n.unitGigabytes(gb);
    } else if (bytes >= 1024 * 1024) {
      final mb = (bytes / (1024 * 1024)).toStringAsFixed(1);
      return l10n.unitMegabytes(mb);
    } else if (bytes >= 1024) {
      final kb = (bytes / 1024).toStringAsFixed(0);
      return l10n.unitKilobytes(kb);
    }
    return l10n.unitKilobytes('0');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navStorage),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: l10n.actionRestart,
            onPressed: _loadStorageData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Real Filesystem Storage Usage Breakdown Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.pie_chart_rounded,
                                size: 28, color: theme.colorScheme.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.storageTotalAppSpace,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    _formatBytes(
                                        _breakdown?.totalUsedBytes ?? 0, l10n),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.cleaning_services_rounded,
                                  size: 18),
                              label: Text(l10n.storageClearCache),
                              onPressed: _clearCache,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 12),
                        _buildStorageRow(
                          icon: Icons.videogame_asset_rounded,
                          label: l10n.storageGamesSpace,
                          sizeStr: _formatBytes(
                              _breakdown?.gamesBytes ?? 0, l10n),
                          theme: theme,
                        ),
                        const SizedBox(height: 8),
                        _buildStorageRow(
                          icon: Icons.save_rounded,
                          label: l10n.storageSavesSpace,
                          sizeStr: _formatBytes(
                              _breakdown?.savesBytes ?? 0, l10n),
                          theme: theme,
                        ),
                        const SizedBox(height: 8),
                        _buildStorageRow(
                          icon: Icons.sd_card_rounded,
                          label: l10n.storageCardsSpace,
                          sizeStr: _formatBytes(
                              _breakdown?.memoryCardsBytes ?? 0, l10n),
                          theme: theme,
                        ),
                        const SizedBox(height: 8),
                        _buildStorageRow(
                          icon: Icons.cached_rounded,
                          label: l10n.settingsGeneral,
                          sizeStr: _formatBytes(
                              _breakdown?.cacheBytes ?? 0, l10n),
                          theme: theme,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Real PS1 Memory Card (128 KB MCD)
                _buildCardTile(
                  title: l10n.storageMemoryCardSlot1,
                  subtitle: l10n.storagePs1Capacity,
                  card: _ps1Card,
                  onFormat: () => _formatCard(1, CardType.ps1),
                  icon: Icons.sd_card_alert_rounded,
                ),
                const SizedBox(height: 16),

                // Real PS2 Memory Card (8 MB VMC)
                _buildCardTile(
                  title: l10n.storageMemoryCardSlot2,
                  subtitle: l10n.storagePs2Capacity,
                  card: _ps2Card,
                  onFormat: () => _formatCard(2, CardType.ps2),
                  icon: Icons.memory_rounded,
                ),
                const SizedBox(height: 16),

                // PS3 Virtual HDD Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.dns_rounded, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.storagePs3Hdd,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Chip(
                              label: Text(l10n.storagePfdValid,
                                  style: const TextStyle(fontSize: 11)),
                              backgroundColor: const Color(0x3300E5FF),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const LinearProgressIndicator(
                          value: 0.05,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                l10n.storagePs3HddPath,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatBytes(
                                  _breakdown?.savesBytes ?? 0, l10n),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStorageRow({
    required IconData icon,
    required String label,
    required String sizeStr,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.onSurface.withAlpha(160)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          sizeStr,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildCardTile({
    required String title,
    required String subtitle,
    required MemoryCardData? card,
    required VoidCallback onFormat,
    required IconData icon,
  }) {
    final l10n = AppLocalizations.of(context);
    final free = card?.blocksFree ?? 0;
    final total = card?.totalBlocks ?? 1;
    final ratio = 1.0 - (free / total);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onFormat,
                  child: Text(l10n.storageFormat),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: ratio.clamp(0.0, 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.storageBlocksFree(free),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
