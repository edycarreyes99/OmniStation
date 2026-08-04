import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/logging/app_logger.dart';
import '../../domain/entities/game_title.dart';
import '../common/error_notification_banner.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  final Function(GameTitle) onGameSelected;

  const LibraryScreen({super.key, required this.onGameSelected});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  ConsolePlatform? _selectedPlatform;

  Future<void> _pickAndImportGame({List<String>? customExtensions}) async {
    final l10n = AppLocalizations.of(context);
    final extensions = customExtensions ??
        ['smc', 'sfc', 'msc', 'iso', 'bin', 'cue', 'pkg', 'pup', 'chd', 'cso', 'zso', 'zip'];

    try {
      AppLogger.info('LibraryUI', 'Opening file picker for extensions: $extensions');
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: extensions,
      );

      if (files.isNotEmpty) {
        final path = files.first.path;
        AppLogger.info('LibraryUI', 'File selected by user: $path');
        if (path != null && mounted) {
          final success = await ref
              .read(gameLibraryNotifierProvider.notifier)
              .importGameFile(path);

          if (success && mounted) {
            final filename = path.split(Platform.pathSeparator).last;
            AppLogger.info('LibraryUI', 'Game imported successfully to library: $filename');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.msgGameImportSuccess(filename))),
            );
          } else if (!success && mounted) {
            final failure = ref.read(lastFailureProvider);
            AppLogger.error('LibraryUI', 'Import failed for $path: $failure');
            if (failure != null) {
              ErrorNotificationBanner.showErrorSnackBar(context, failure);
            }
          }
        }
      } else {
        AppLogger.debug('LibraryUI', 'User cancelled file picker dialog');
      }
    } catch (e, st) {
      AppLogger.error('LibraryUI', 'Exception during game import: $e', e, st);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.msgGameImportFailed(e.toString()))),
        );
      }
    }
  }

  Future<void> _confirmDeleteGame(GameTitle game) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.actionDeleteGame),
        content: Text(l10n.dialogDeleteGameConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.actionDeleteGame),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await ref.read(gameLibraryNotifierProvider.notifier).removeGame(game.id);
    }
  }

  String _formatFileSize(int bytes, AppLocalizations l10n) {
    if (bytes >= 1024 * 1024 * 1024) {
      final gb = (bytes / (1024 * 1024 * 1024)).toStringAsFixed(1);
      return l10n.unitGigabytes(gb);
    } else if (bytes >= 1024 * 1024) {
      final mb = (bytes / (1024 * 1024)).toStringAsFixed(1);
      return l10n.unitMegabytes(mb);
    } else if (bytes >= 1024) {
      final kb = (bytes / 1024).toStringAsFixed(0);
      return l10n.unitKilobytes(kb);
    }
    return l10n.unitKilobytes('1');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final libraryState = ref.watch(gameLibraryNotifierProvider);

    final filteredGames = _selectedPlatform == null
        ? libraryState.games
        : libraryState.games.where((g) => g.platform == _selectedPlatform).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navLibrary),
        actions: [
          IconButton(
            icon: const Icon(Icons.install_mobile_rounded),
            tooltip: l10n.actionInstallPkg,
            onPressed: () => _pickAndImportGame(customExtensions: ['pkg', 'pup']),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: l10n.actionImportGame,
            onPressed: () => _pickAndImportGame(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Platform Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: Text(l10n.filterAll),
                  selected: _selectedPlatform == null,
                  onSelected: (_) => setState(() => _selectedPlatform = null),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l10n.platformSnes),
                  selected: _selectedPlatform == ConsolePlatform.snes,
                  onSelected: (_) => setState(() => _selectedPlatform = ConsolePlatform.snes),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l10n.platformPs1),
                  selected: _selectedPlatform == ConsolePlatform.ps1,
                  onSelected: (_) => setState(() => _selectedPlatform = ConsolePlatform.ps1),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l10n.platformPs2),
                  selected: _selectedPlatform == ConsolePlatform.ps2,
                  onSelected: (_) => setState(() => _selectedPlatform = ConsolePlatform.ps2),
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text(l10n.platformPs3),
                  selected: _selectedPlatform == ConsolePlatform.ps3,
                  onSelected: (_) => setState(() => _selectedPlatform = ConsolePlatform.ps3),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content Area
          Expanded(
            child: filteredGames.isEmpty
                ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.sports_esports_outlined,
                                size: 72,
                                color: theme.colorScheme.onSurface.withAlpha(120),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.emptyLibraryTitle,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.emptyLibraryDesc,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurface.withAlpha(160),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              FilledButton.icon(
                                icon: const Icon(Icons.file_open_rounded),
                                label: Text(l10n.actionImportGame),
                                onPressed: () => _pickAndImportGame(),
                              ),
                            ],
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 280,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredGames.length,
                        itemBuilder: (context, index) {
                          final game = filteredGames[index];
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () async {
                                AppLogger.info('LibraryUI', 'User selected game: "${game.title}" (Path: ${game.path})');
                                final success = await ref
                                    .read(emulationSessionControllerProvider.notifier)
                                    .loadAndBootGame(game.path);
                                if (success) {
                                  AppLogger.info('LibraryUI', 'Game "${game.title}" booted successfully, transitioning to Viewport');
                                  widget.onGameSelected(game);
                                } else {
                                  final failure = ref
                                      .read(emulationSessionControllerProvider.notifier)
                                      .lastFailure;
                                  AppLogger.error('LibraryUI', 'Failed to boot game "${game.title}": $failure');
                                  if (failure != null && context.mounted) {
                                    ErrorNotificationBanner.showErrorSnackBar(context, failure);
                                  }
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            theme.colorScheme.primary.withAlpha(200),
                                            theme.colorScheme.surface,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Center(
                                            child: Icon(
                                              _getPlatformIcon(game.platform),
                                              size: 54,
                                              color: Colors.white70,
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: IconButton(
                                              icon: const Icon(Icons.delete_outline_rounded, size: 20),
                                              tooltip: l10n.actionDeleteGame,
                                              onPressed: () => _confirmDeleteGame(game),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          game.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                _getPlatformLabel(game.platform, l10n),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: theme.colorScheme.onSurface.withAlpha(160),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              game.fileSizeBytes > 0
                                                  ? _formatFileSize(game.fileSizeBytes, l10n)
                                                  : game.serial,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: theme.colorScheme.primary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  IconData _getPlatformIcon(ConsolePlatform platform) {
    switch (platform) {
      case ConsolePlatform.snes:
        return Icons.videogame_asset_rounded;
      case ConsolePlatform.ps1:
        return Icons.album_rounded;
      case ConsolePlatform.ps2:
        return Icons.disc_full_rounded;
      case ConsolePlatform.ps3:
        return Icons.blur_circular_rounded;
    }
  }

  String _getPlatformLabel(ConsolePlatform platform, AppLocalizations l10n) {
    switch (platform) {
      case ConsolePlatform.snes:
        return l10n.platformSnes;
      case ConsolePlatform.ps1:
        return l10n.platformPs1;
      case ConsolePlatform.ps2:
        return l10n.platformPs2;
      case ConsolePlatform.ps3:
        return l10n.platformPs3;
    }
  }
}
