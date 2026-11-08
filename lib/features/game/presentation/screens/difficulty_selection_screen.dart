import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../domain/models/difficulty_level.dart';
import '../controllers/game_controller.dart';

class DifficultySelectionScreen extends ConsumerStatefulWidget {
  const DifficultySelectionScreen({super.key});

  @override
  ConsumerState<DifficultySelectionScreen> createState() =>
      _DifficultySelectionScreenState();
}

class _DifficultySelectionScreenState
    extends ConsumerState<DifficultySelectionScreen> {
  late DifficultyLevel _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _selectedDifficulty = ref.read(gameControllerProvider).difficulty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final info = switch (_selectedDifficulty) {
      DifficultyLevel.easy => (
          title: l10n.easy,
          desc: l10n.easyDesc,
          ops: '+, -, *, /, (, ), √, ∛, !, **, |x|, ⌊x⌋, ⌈x⌉',
        ),
      DifficultyLevel.intermediate => (
          title: l10n.intermediate,
          desc: l10n.intermediateDesc,
          ops: '+, -, *, /, (, ), √, ∛, !, **, |x|',
        ),
      DifficultyLevel.advanced => (
          title: l10n.advanced,
          desc: l10n.advancedDesc,
          ops: '+, -, *, /, (, ), √, !, |x|',
        ),
      DifficultyLevel.hard => (
          title: l10n.hard,
          desc: l10n.hardDesc,
          ops: '+, -, *, /, (, ), |x|',
        ),
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.selectDifficultyTitle,
          style: GoogleFonts.gaegu(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Seletor de botões de dificuldade
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: DifficultyLevel.values.map((level) {
                    final isSelected = level == _selectedDifficulty;
                    final label = switch (level) {
                      DifficultyLevel.easy => l10n.easy,
                      DifficultyLevel.intermediate => l10n.intermediate,
                      DifficultyLevel.advanced => l10n.advanced,
                      DifficultyLevel.hard => l10n.hard,
                    };
                    return ChoiceChip(
                      label: Text(label),
                      selected: isSelected,
                      labelStyle: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) =>
                          setState(() => _selectedDifficulty = level),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                // Cartão com a explicação e operadores
                Expanded(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            info.title,
                            style: GoogleFonts.gaegu(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            info.desc,
                            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
                          ),
                          const Spacer(),
                          Text(
                            l10n.operators,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              info.ops,
                              style: const TextStyle(
                                fontSize: 16,
                                letterSpacing: 1.2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Botão de Confirmar
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    ref
                        .read(gameControllerProvider.notifier)
                        .setDifficulty(_selectedDifficulty);
                    context.go('/game');
                  },
                  child: Text(
                    l10n.confirm,
                    style: GoogleFonts.gaegu(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
