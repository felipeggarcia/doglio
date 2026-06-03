library;

import 'package:flutter/material.dart';
import '../utils/l10n_helper.dart';

/// Balão do carrinho — aparece sob o ícone de carrinho na AppBar.
class CartBubble {
  CartBubble._();
  static OverlayEntry? _entry;
  static VoidCallback? _dismissFn;

  static void show(BuildContext context, {bool appBarVisible = true}) {
    _remove();
    final message = context.l10n.cartItemAdded;
    final top = _top(context, appBarVisible: appBarVisible);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _AppBarBubble(
        message: message,
        icon: Icons.check_circle_outline,
        topOffset: top,
        rightOffset: 55,
        triangleRightPadding: 8,
        onRegisterDismiss: (fn) => _dismissFn = fn,
        onDone: _remove,
      ),
    );
    _entry = entry;
    Overlay.of(context).insert(entry);
  }

  /// Inicia dismiss animado rápido (ex.: ao rolar a tela).
  static void dismiss() => _dismissFn?.call();

  static void _remove() {
    _entry?.remove();
    _entry = null;
    _dismissFn = null;
  }
}

/// Balão dos favoritos — aparece sob o ícone de coração na AppBar.
class FavoriteBubble {
  FavoriteBubble._();
  static OverlayEntry? _entry;
  static VoidCallback? _dismissFn;

  static void show(
    BuildContext context, {
    required bool added,
    bool appBarVisible = true,
  }) {
    _remove();
    final message =
        added ? context.l10n.favoriteAdded : context.l10n.favoriteRemoved;
    final top = _top(context, appBarVisible: appBarVisible);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _AppBarBubble(
        message: message,
        icon: added ? Icons.favorite_border : Icons.heart_broken_outlined,
        topOffset: top,
        rightOffset: 8,
        triangleRightPadding: 12,
        onRegisterDismiss: (fn) => _dismissFn = fn,
        onDone: _remove,
      ),
    );
    _entry = entry;
    Overlay.of(context).insert(entry);
  }

  static void dismiss() => _dismissFn?.call();

  static void _remove() {
    _entry?.remove();
    _entry = null;
    _dismissFn = null;
  }
}

double _top(BuildContext context, {required bool appBarVisible}) {
  // Tenta posição real via RenderBox do ícone (não depende de padding do Scaffold)
  try {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      final screenHeight = MediaQuery.of(context).size.height;
      final bottom = box.localToGlobal(Offset(0, box.size.height)).dy;
      // Só usa se a posição for plausível para um ícone na AppBar (top 40% da tela)
      if (bottom > 20 && bottom < screenHeight * 0.4) {
        return bottom + 4;
      }
    }
  } catch (_) {}
  // Fallback: cálculo por viewPadding
  final statusBar = MediaQuery.of(context).viewPadding.top;
  return statusBar + (appBarVisible ? kToolbarHeight : 0) + 8;
}

// ─── Widget genérico ──────────────────────────────────────────────────────────

class _AppBarBubble extends StatefulWidget {
  const _AppBarBubble({
    required this.message,
    required this.icon,
    required this.topOffset,
    required this.rightOffset,
    required this.triangleRightPadding,
    required this.onRegisterDismiss,
    required this.onDone,
  });

  final String message;
  final IconData icon;
  final double topOffset;
  final double rightOffset;
  final double triangleRightPadding;
  final void Function(VoidCallback) onRegisterDismiss;
  final VoidCallback onDone;

  @override
  State<_AppBarBubble> createState() => _AppBarBubbleState();
}

class _AppBarBubbleState extends State<_AppBarBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.6),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    _ctrl.forward();

    // Registra callback de dismiss rápido para quem precisar acionar externamente
    widget.onRegisterDismiss(_fastDismiss);

    // Auto-dismiss normal após 2.2s
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!_dismissed && mounted) _beginDismiss(fast: false);
    });
  }

  void _fastDismiss() => _beginDismiss(fast: true);

  void _beginDismiss({required bool fast}) {
    if (_dismissed || !mounted) return;
    _dismissed = true;
    _ctrl
        .animateBack(
          0,
          duration: Duration(milliseconds: fast ? 120 : 280),
          curve: Curves.easeIn,
        )
        .then((_) {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Positioned(
      top: widget.topOffset,
      right: widget.rightOffset,
      child: FadeTransition(
        opacity: _opacity,
        child: SlideTransition(
          position: _slide,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(right: widget.triangleRightPadding),
                child: CustomPaint(
                  size: const Size(16, 9),
                  painter: _TrianglePainter(primary),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 220),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(widget.icon, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Triângulo ────────────────────────────────────────────────────────────────

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height)
        ..lineTo(size.width / 2, 0)
        ..lineTo(size.width, size.height)
        ..close(),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_TrianglePainter old) => old.color != color;
}
