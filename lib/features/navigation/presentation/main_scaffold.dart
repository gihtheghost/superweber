import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/app_localizations.dart';
import 'help_dialog.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;
  final String location;

  const MainScaffold({super.key, required this.child, required this.location});

  int _calculateSelectedIndex(BuildContext context) {
    if (location.startsWith('/settings')) return 2;
    if (location.startsWith('/records')) return 1;
    return 0; // /game
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = _calculateSelectedIndex(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: child,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
          child: Row(
            children: [
              _NavigationItem(
                icon: Icons.psychology,
                selected: selectedIndex == 0,
                tooltip: l10n.play,
                onTap: () => context.go('/game'),
              ),
              _NavigationItem(
                icon: Icons.format_list_bulleted,
                selected: selectedIndex == 1,
                tooltip: l10n.recordsTitle,
                onTap: () => context.go('/records'),
              ),
              _NavigationItem(
                icon: Icons.settings,
                selected: selectedIndex == 2,
                tooltip: l10n.settings,
                onTap: () => context.go('/settings'),
              ),
              _NavigationItem(
                icon: Icons.help_outline,
                selected: false,
                tooltip: l10n.help,
                onTap: () => showHelpDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final String tooltip;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.icon,
    required this.selected,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Icon(
              icon,
              size: 24,
              color: selected ? colors.primary : colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
