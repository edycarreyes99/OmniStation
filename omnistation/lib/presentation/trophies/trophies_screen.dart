import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/injection.dart';
import '../../core/l10n/generated/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../domain/entities/trophy_data.dart';

class TrophiesScreen extends ConsumerStatefulWidget {
  const TrophiesScreen({super.key});

  @override
  ConsumerState<TrophiesScreen> createState() => _TrophiesScreenState();
}

class _TrophiesScreenState extends ConsumerState<TrophiesScreen> {
  List<TrophyData> _trophies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadTrophies();
  }

  Future<void> _loadTrophies() async {
    final useCase = ref.read(manageTrophiesUseCaseProvider);
    final res = await useCase.getTrophies('NPWR00001_00');
    if (mounted) {
      setState(() {
        _trophies = res.getOrElse((_) => []);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.navTrophies),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: l10n.actionRestart,
            onPressed: _loadTrophies,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _trophies.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          size: 72,
                          color: theme.colorScheme.onSurface.withAlpha(120),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.emptyTrophiesTitle,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.emptyTrophiesDesc,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withAlpha(160),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _trophies.length,
                  itemBuilder: (context, index) {
                    final trophy = _trophies[index];
                    final color = _getTrophyColor(trophy.grade);
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          trophy.isUnlocked
                              ? Icons.emoji_events_rounded
                              : Icons.lock_outline_rounded,
                          color: trophy.isUnlocked
                              ? color
                              : theme.colorScheme.onSurface.withAlpha(100),
                          size: 36,
                        ),
                        title: Text(
                          _getTrophyName(trophy, l10n),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: trophy.isUnlocked
                                ? theme.colorScheme.onSurface
                                : theme.colorScheme.onSurface.withAlpha(140),
                          ),
                        ),
                        subtitle: Text(
                          _getTrophyDescription(trophy, l10n),
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withAlpha(160),
                          ),
                        ),
                        trailing: Chip(
                          label: Text(
                            _getTrophyGradeLabel(trophy.grade, l10n),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          backgroundColor: color.withAlpha(30),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _getTrophyName(TrophyData trophy, AppLocalizations l10n) {
    switch (trophy.id) {
      case 1:
        return l10n.trophyPioneerTitle;
      case 2:
        return l10n.trophyVeteranTitle;
      case 3:
        return l10n.trophyCellMasterTitle;
      case 4:
        return l10n.trophyArchitectTitle;
      default:
        return trophy.name;
    }
  }

  String _getTrophyDescription(TrophyData trophy, AppLocalizations l10n) {
    switch (trophy.id) {
      case 1:
        return l10n.trophyPioneerDesc;
      case 2:
        return l10n.trophyVeteranDesc;
      case 3:
        return l10n.trophyCellMasterDesc;
      case 4:
        return l10n.trophyArchitectDesc;
      default:
        return trophy.description;
    }
  }

  Color _getTrophyColor(TrophyGrade grade) {
    switch (grade) {
      case TrophyGrade.bronze:
        return AppColors.trophyBronze;
      case TrophyGrade.silver:
        return AppColors.trophySilver;
      case TrophyGrade.gold:
        return AppColors.trophyGold;
      case TrophyGrade.platinum:
        return AppColors.trophyPlatinum;
    }
  }

  String _getTrophyGradeLabel(TrophyGrade grade, AppLocalizations l10n) {
    switch (grade) {
      case TrophyGrade.bronze:
        return l10n.trophyBronze;
      case TrophyGrade.silver:
        return l10n.trophySilver;
      case TrophyGrade.gold:
        return l10n.trophyGold;
      case TrophyGrade.platinum:
        return l10n.trophyPlatinum;
    }
  }
}
