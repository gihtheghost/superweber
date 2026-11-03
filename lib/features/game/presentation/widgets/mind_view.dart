import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../domain/models/game_state.dart';
import '../../domain/models/operator_token.dart';
import '../controllers/game_controller.dart';

abstract class _PlateItem {
  final GlobalKey key;
  _PlateItem({required this.key});
}

class _DigitItem extends _PlateItem {
  final int digitIndex;
  final int digit;
  _DigitItem({
    required this.digitIndex,
    required this.digit,
    required super.key,
  });
}

class _OperatorItem extends _PlateItem {
  final int slotIndex;
  final int tokenIndex;
  final OperatorToken token;
  _OperatorItem({
    required this.slotIndex,
    required this.tokenIndex,
    required this.token,
    required super.key,
  });
}

class _ItemCenter {
  final double x;
  final _PlateItem item;
  _ItemCenter(this.x, this.item);
}

class _TargetGap {
  final int slotIndex;
  final int insertIndex;
  const _TargetGap(this.slotIndex, this.insertIndex);
}

class MindView extends ConsumerStatefulWidget {
  const MindView({super.key});

  @override
  ConsumerState<MindView> createState() => _MindViewState();
}

class _MindViewState extends ConsumerState<MindView> {
  static const String weberSombraUrl =
      'https://raw.githubusercontent.com/tiribsil/superweber/main/assets/weber_sombra.png';
  static const String cerebroUrl =
      'https://raw.githubusercontent.com/tiribsil/superweber/main/assets/cerebro.png';
  static const String placaUrl =
      'https://raw.githubusercontent.com/tiribsil/superweber/main/assets/placa.png';

  final GlobalKey _plateKey = GlobalKey();
  final List<GlobalKey> _digitKeys = List.generate(4, (_) => GlobalKey());
  final Map<String, GlobalKey> _operatorKeys = {};

  int? _hoverGapIndex;

  GlobalKey _getOperatorKey(int slotIndex, int tokenIndex) {
    final id = '$slotIndex:$tokenIndex';
    return _operatorKeys.putIfAbsent(id, () => GlobalKey());
  }

  List<_PlateItem> _buildItemsList(GameState state) {
    final items = <_PlateItem>[];

    // Slot 0 operators
    for (int i = 0; i < state.slots[0].length; i++) {
      items.add(
        _OperatorItem(
          slotIndex: 0,
          tokenIndex: i,
          token: state.slots[0][i],
          key: _getOperatorKey(0, i),
        ),
      );
    }

    // Digit 0
    items.add(
      _DigitItem(digitIndex: 0, digit: state.digits[0], key: _digitKeys[0]),
    );

    // Slot 1 operators
    for (int i = 0; i < state.slots[1].length; i++) {
      items.add(
        _OperatorItem(
          slotIndex: 1,
          tokenIndex: i,
          token: state.slots[1][i],
          key: _getOperatorKey(1, i),
        ),
      );
    }

    // Digit 1
    items.add(
      _DigitItem(digitIndex: 1, digit: state.digits[1], key: _digitKeys[1]),
    );

    // Slot 2 operators
    for (int i = 0; i < state.slots[2].length; i++) {
      items.add(
        _OperatorItem(
          slotIndex: 2,
          tokenIndex: i,
          token: state.slots[2][i],
          key: _getOperatorKey(2, i),
        ),
      );
    }

    // Digit 2
    items.add(
      _DigitItem(digitIndex: 2, digit: state.digits[2], key: _digitKeys[2]),
    );

    // Slot 3 operators
    for (int i = 0; i < state.slots[3].length; i++) {
      items.add(
        _OperatorItem(
          slotIndex: 3,
          tokenIndex: i,
          token: state.slots[3][i],
          key: _getOperatorKey(3, i),
        ),
      );
    }

    // Digit 3
    items.add(
      _DigitItem(digitIndex: 3, digit: state.digits[3], key: _digitKeys[3]),
    );

    // Slot 4 operators
    for (int i = 0; i < state.slots[4].length; i++) {
      items.add(
        _OperatorItem(
          slotIndex: 4,
          tokenIndex: i,
          token: state.slots[4][i],
          key: _getOperatorKey(4, i),
        ),
      );
    }

    return items;
  }

  double _getDropX(Offset globalOffset, double chipSize) {
    final plateBox = _plateKey.currentContext?.findRenderObject() as RenderBox?;
    if (plateBox == null) return 0.0;
    final chipCenter = Offset(chipSize / 2, chipSize / 2);
    return plateBox.globalToLocal(globalOffset + chipCenter).dx;
  }

  List<_ItemCenter> _getItemCenters(List<_PlateItem> items) {
    final plateBox = _plateKey.currentContext?.findRenderObject() as RenderBox?;
    if (plateBox == null) return [];

    final centers = <_ItemCenter>[];
    for (final item in items) {
      final box = item.key.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        final localCenter = plateBox.globalToLocal(
          box.localToGlobal(Offset(box.size.width / 2, box.size.height / 2)),
        );
        centers.add(_ItemCenter(localCenter.dx, item));
      }
    }
    return centers;
  }

  int _calculateGapIndex(double dropX, List<_ItemCenter> itemCenters) {
    final n = itemCenters.length;
    if (n == 0) return 1;
    if (dropX < itemCenters.first.x) return 0;
    if (dropX >= itemCenters.last.x) return n;

    for (int i = 0; i < n - 1; i++) {
      if (dropX >= itemCenters[i].x && dropX < itemCenters[i + 1].x) {
        return i + 1;
      }
    }
    return n;
  }

  _TargetGap _resolveGap(
    int gapIndex,
    List<_PlateItem> items,
    List<List<OperatorToken>> slots,
  ) {
    if (items.isEmpty) {
      return const _TargetGap(1, 0);
    }
    if (gapIndex <= 0) {
      return const _TargetGap(0, 0);
    }
    if (gapIndex >= items.length) {
      return _TargetGap(4, slots[4].length);
    }

    final leftItem = items[gapIndex - 1];

    if (leftItem is _OperatorItem) {
      return _TargetGap(leftItem.slotIndex, leftItem.tokenIndex + 1);
    }

    final d = (leftItem as _DigitItem).digitIndex;
    return _TargetGap(d + 1, 0);
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameControllerProvider);
    final gameNotifier = ref.read(gameControllerProvider.notifier);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final maxHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : MediaQuery.sizeOf(context).height;
        final scale = (maxWidth / 400).clamp(0.75, 1.25).toDouble();
        final chipSize = (maxWidth * 0.05).clamp(36.0, 52.0).toDouble();
        final digitFontSize = (maxWidth * 0.09).clamp(24.0, 44.0).toDouble();
        final compactActions = maxWidth < 380;
        final horizontalInset = maxWidth < 380 ? 8.0 : 16.0;
        const plateActionExtent = 56.0; // 48px button + 8px gap.

        return Container(
          color: theme.colorScheme.surface,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 1. Sombra do Weber (Fundo: preenche a altura sem esticar horizontalmente)
              Positioned.fill(
                child: Image.network(
                  weberSombraUrl,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center,
                ),
              ),

              // 2. Cérebro do Weber (na frente da sombra)
              Positioned(
                height: maxHeight * 0.6, // Permite que a imagem do cérebro se ajuste à altura do Stack
                child: Image.network(
                  // ou Image.asset se for local
                  cerebroUrl,
                  fit: BoxFit
                      .contain, // Mantém a proporção do cérebro centralizado
                  alignment: Alignment.center,
                ),
              ),

              // 2. Active Brain Interactive Content Area
              SafeArea(
                child: Column(
                  children: [
                    // Top control bar: Hearts under Weber on the left & Skip / Surrender buttons on the right
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalInset,
                        vertical: 8.0 * scale,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Hearts representing lives (positioned directly under Weber)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: maxWidth < 380 ? 4 : 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHigh
                                  .withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.outline.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(3, (index) {
                                final isAlive = index < gameState.hp;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 1.0,
                                  ),
                                  child: Icon(
                                    isAlive
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isAlive
                                        ? Colors.redAccent
                                        : theme.colorScheme.outline.withValues(
                                            alpha: 0.4,
                                          ),
                                    size: (maxWidth * 0.035)
                                        .clamp(12.0, 16.0)
                                        .toDouble(),
                                  ),
                                );
                              }),
                            ),
                          ),

                          // Actions: Skip plate (mandatory per spec rule 67) & Surrender (adjustment 9)
                          if (compactActions)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton.filledTonal(
                                  tooltip: l10n.translate('skip'),
                                  icon: const Icon(Icons.skip_next),
                                  onPressed: () => gameNotifier.skipPlate(),
                                ),
                                IconButton.filledTonal(
                                  tooltip: l10n.translate('surrender'),
                                  style: IconButton.styleFrom(
                                    foregroundColor: theme.colorScheme.error,
                                  ),
                                  icon: const Icon(Icons.flag_outlined),
                                  onPressed: () => gameNotifier.surrender(),
                                ),
                              ],
                            )
                          else
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FilledButton.tonalIcon(
                                  icon: const Icon(Icons.skip_next, size: 18),
                                  label: Text(l10n.translate('skip')),
                                  onPressed: () => gameNotifier.skipPlate(),
                                ),
                                const SizedBox(width: 8),
                                FilledButton.tonalIcon(
                                  style: FilledButton.styleFrom(
                                    foregroundColor: theme.colorScheme.error,
                                  ),
                                  icon: const Icon(
                                    Icons.flag_outlined,
                                    size: 18,
                                  ),
                                  label: Text(l10n.translate('surrender')),
                                  onPressed: () => gameNotifier.surrender(),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    // Error / Status banner
                    if (gameState.lastError != null)
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.redAccent),
                        ),
                        child: Text(
                          gameState.lastError!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const Spacer(),

                    // LaTeX Formula Display
                    _buildLatexDisplay(context, gameState, maxWidth),

                    SizedBox(height: 4 * scale),

                    // Draggable operators palette tray
                    _buildOperatorsArea(
                      context,
                      gameState,
                      maxWidth,
                      scale,
                      chipSize,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              // Spatial drag-and-drop equation plate
              Positioned(
                top: maxHeight * 0.33,
                left: 0,
                right: 0,
                child: Center(
                  child: Transform.translate(
                    // Offset the whole group so the plate itself remains centered.
                    offset: Offset(plateActionExtent / 2, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildPlateWithSlots(
                          context,
                          gameState,
                          gameNotifier,
                          maxWidth - (plateActionExtent * 2),
                          scale,
                          digitFontSize,
                          chipSize,
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: IconButton.filledTonal(
                            tooltip: l10n.translate('clear'),
                            icon: const Icon(
                              Icons.cleaning_services_rounded,
                              size: 24,
                            ),
                            onPressed: () => gameNotifier.clearSlots(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlateWithSlots(
    BuildContext context,
    GameState state,
    GameController controller,
    double maxWidth,
    double scale,
    double digitFontSize,
    double chipSize,
  ) {
    final items = _buildItemsList(state);

    return DragTarget<OperatorToken>(
      onWillAcceptWithDetails: (details) => true,
      onMove: (details) {
        final centers = _getItemCenters(items);
        if (centers.isNotEmpty) {
          final dropX = _getDropX(details.offset, chipSize);
          final gap = _calculateGapIndex(dropX, centers);
          if (_hoverGapIndex != gap) {
            setState(() {
              _hoverGapIndex = gap;
            });
          }
        }
      },
      onLeave: (data) {
        if (_hoverGapIndex != null) {
          setState(() {
            _hoverGapIndex = null;
          });
        }
      },
      onAcceptWithDetails: (details) {
        final centers = _getItemCenters(items);
        final dropX = _getDropX(details.offset, chipSize);
        final gap = _calculateGapIndex(dropX, centers);
        final target = _resolveGap(gap, items, state.slots);

        setState(() {
          _hoverGapIndex = null;
        });

        controller.addOperatorToSlot(
          target.slotIndex,
          details.data,
          insertIndex: target.insertIndex,
        );
      },
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        final rowChildren = <Widget>[];
        for (int i = 0; i < items.length; i++) {
          if (_hoverGapIndex == i) {
            rowChildren.add(_buildInsertionIndicator(digitFontSize));
          }
          final item = items[i];
          if (item is _DigitItem) {
            rowChildren.add(_buildDigitTile(item, digitFontSize, scale));
          } else if (item is _OperatorItem) {
            rowChildren.add(_buildOperatorTile(item, controller, scale));
          }
        }

        if (_hoverGapIndex == items.length) {
          rowChildren.add(_buildInsertionIndicator(digitFontSize));
        }

        return Container(
          key: _plateKey,
          constraints: BoxConstraints(maxWidth: maxWidth * 0.92),
          padding: EdgeInsets.fromLTRB(
            20 * scale,
            20 * scale,
            20 * scale,
            4 * scale,
          ),
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: NetworkImage(placaUrl), // ou AssetImage(placaUrl)
              fit: BoxFit.fill, // A placa estica confortavelmente conforme novos operadores entram
            ),
            border: isHovered
                ? Border.all(color: Colors.amberAccent, width: 2.5)
                : null,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: rowChildren,
            ),
          ),
        );
      },
    );
  }

  Widget _buildInsertionIndicator(double digitFontSize) {
    return Container(
      width: 3,
      height: digitFontSize * 1.1,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.amberAccent,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Colors.amberAccent.withValues(alpha: 0.8),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildDigitTile(_DigitItem item, double digitFontSize, double scale) {
    return Container(
      key: item.key,
      padding: EdgeInsets.symmetric(
        horizontal: 10 * scale,
        vertical: 4 * scale,
      ),
      child: Text(
        '${item.digit}',
        style: TextStyle(
          color: Colors.black,
          fontSize: digitFontSize,
          fontWeight: FontWeight.w900,
          fontFamily: 'Courier',
          letterSpacing: scale,
        ),
      ),
    );
  }

  Widget _buildOperatorTile(
    _OperatorItem item,
    GameController controller,
    double scale,
  ) {
    return Container(
      key: item.key,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        onTap: () =>
            controller.removeOperatorFromSlot(item.slotIndex, item.tokenIndex),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 7 * scale,
            vertical: 4 * scale,
          ),
          decoration: BoxDecoration(
            color: Colors.purple.shade700,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purpleAccent, width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            item.token.label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20 * scale,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLatexDisplay(
    BuildContext context,
    GameState state,
    double maxWidth,
  ) {
    final theme = Theme.of(context);
    final latex = state.evaluation.latex;

    final formulaFontSize = (maxWidth * 0.05).clamp(16.0, 24.0).toDouble();
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth * 0.9),
      margin: EdgeInsets.symmetric(horizontal: maxWidth * 0.05),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.85,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: state.evaluation.isSolved
              ? Colors.greenAccent
              : theme.colorScheme.outlineVariant,
          width: state.evaluation.isSolved ? 2 : 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Math.tex(
              latex.isEmpty ? r'\dots' : latex,
              textStyle: TextStyle(
                fontSize: formulaFontSize,
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              mathStyle: MathStyle.display,
              // onErrorFallback: (err) => Text(
              //   latex,
              //   style: TextStyle(
              //     fontSize: formulaFontSize * 0.82,
              //     color: theme.colorScheme.onSurface,
              //     fontFamily: 'monospace',
              //   ),
              // ),
            ),
          ),
          // if (state.evaluation.errorMessage != null &&
          //     !state.evaluation.isSolved)
          //   Padding(
          //     padding: const EdgeInsets.only(top: 6.0),
          //     child: Text(
          //       state.evaluation.errorMessage!,
          //       style: TextStyle(
          //         fontSize: 11,
          //         color: theme.colorScheme.error,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _buildOperatorsArea(
    BuildContext context,
    GameState state,
    double maxWidth,
    double scale,
    double chipSize,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.025),
      child: _buildOperatorsTray(context, state, maxWidth, scale, chipSize),
    );
  }

  Widget _buildOperatorsTray(
    BuildContext context,
    GameState state,
    double maxWidth,
    double scale,
    double chipSize,
  ) {
    final theme = Theme.of(context);
    final available = state.difficulty.availableOperators;
    final chipSpacing = (scale * 6).clamp(4.0, 8.0).toDouble();
    final trayMaxHeight = chipSize * 2 + chipSpacing + (24 * scale) + 2;

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth * 0.95,
        maxHeight: trayMaxHeight,
      ),
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(12 * scale),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          spacing: chipSpacing,
          runSpacing: chipSpacing,
          alignment: WrapAlignment.center,
          children: available.map((op) {
            return Draggable<OperatorToken>(
              data: op,
              feedback: Material(
                color: Colors.transparent,
                child: Container(
                  width: chipSize,
                  height: chipSize,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.6),
                        blurRadius: 12,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    op.label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: chipSize * 0.42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: _buildOperatorChip(context, op, chipSize),
              ),
              child: _buildOperatorChip(context, op, chipSize),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOperatorChip(
    BuildContext context,
    OperatorToken op,
    double chipSize,
  ) {
    final theme = Theme.of(context);
    return Container(
      width: chipSize,
      height: chipSize,
      decoration: BoxDecoration(
        color: op.type == OperatorType.equals
            ? Colors.amber.shade700
            : theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: op.type == OperatorType.equals
              ? Colors.amberAccent
              : theme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        op.label,
        style: TextStyle(
          color: op.type == OperatorType.equals
              ? Colors.white
              : theme.colorScheme.onPrimaryContainer,
          fontSize: chipSize * 0.42,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
