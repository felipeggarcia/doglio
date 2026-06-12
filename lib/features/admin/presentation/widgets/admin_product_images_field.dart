/// Grade de imagens do form de produto admin com drag-to-reorder ao vivo.
///
/// [orderedImages] é uma lista unificada de [AdminProductImage] (existentes)
/// ou [String] (caminhos de novas imagens). A posição 0 é a foto de capa.
/// Long press inicia o drag; o layout reordena em tempo real enquanto arrasta.
library;

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/utils/l10n_helper.dart';
import '../../domain/entities/admin_product.dart';

class AdminProductImagesField extends StatefulWidget {
  const AdminProductImagesField({
    super.key,
    required this.orderedImages,
    required this.removedImageIds,
    required this.onToggleExisting,
    required this.onRemoveNew,
    required this.onAddPressed,
    required this.onReorder,
    this.enabled = true,
  });

  /// Cada entrada é [AdminProductImage] (existente) ou [String] (novo path).
  final List<Object> orderedImages;
  final Set<String> removedImageIds;
  final ValueChanged<String> onToggleExisting;

  /// Recebe o índice ORIGINAL em [orderedImages] da nova imagem a remover.
  final ValueChanged<int> onRemoveNew;
  final VoidCallback onAddPressed;
  final void Function(int oldIndex, int newIndex) onReorder;
  final bool enabled;

  @override
  State<AdminProductImagesField> createState() =>
      _AdminProductImagesFieldState();
}

class _AdminProductImagesFieldState extends State<AdminProductImagesField> {
  /// Índice original do item sendo arrastado; null se nenhum drag ativo.
  int? _dragFrom;

  /// Slot de display atual onde o item seria solto; null se fora de qualquer slot.
  int? _dragTo;

  /// Ordem de exibição: _displayOrder[j] = índice original do item no slot j.
  /// Durante drag, reflete a posição temporária do item arrastado.
  List<int> get _displayOrder {
    final n = widget.orderedImages.length;
    final indices = List<int>.generate(n, (i) => i);
    if (_dragFrom == null || _dragTo == null || _dragFrom == _dragTo) {
      return indices;
    }
    final item = indices.removeAt(_dragFrom!);
    indices.insert(_dragTo!, item);
    return indices;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        const cols = 3;
        final size = (constraints.maxWidth - spacing * (cols - 1)) / cols;
        final order = _displayOrder;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (var j = 0; j < widget.orderedImages.length; j++)
              _buildSlot(context, displayPos: j, originalIdx: order[j], size: size),
            _AddTile(size: size, onTap: widget.enabled ? widget.onAddPressed : null),
          ],
        );
      },
    );
  }

  Widget _buildSlot(
    BuildContext context, {
    required int displayPos,
    required int originalIdx,
    required double size,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final isDragging = originalIdx == _dragFrom;
    final isTarget = _dragTo == displayPos && _dragFrom != null && !isDragging;
    final isCover = displayPos == 0 && !isDragging;
    final entry = widget.orderedImages[originalIdx];

    if (!widget.enabled) {
      return SizedBox(
        width: size,
        height: size,
        child: _buildContent(entry, originalIdx: originalIdx, isCover: isCover),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: DragTarget<int>(
        onWillAcceptWithDetails: (_) => true,
        onAcceptWithDetails: (details) {
          widget.onReorder(details.data, displayPos);
          setState(() { _dragFrom = null; _dragTo = null; });
        },
        onMove: (_) {
          if (_dragFrom != null && _dragTo != displayPos) {
            setState(() => _dragTo = displayPos);
          }
        },
        onLeave: (_) {
          if (_dragTo == displayPos) setState(() => _dragTo = null);
        },
        builder: (_, _, _) {
          return LongPressDraggable<int>(
            data: originalIdx,
            delay: const Duration(milliseconds: 350),
            hapticFeedbackOnStart: true,
            onDragStarted: () => setState(() { _dragFrom = originalIdx; _dragTo = displayPos; }),
            onDragEnd: (_) {
              if (_dragFrom != null) setState(() { _dragFrom = null; _dragTo = null; });
            },
            onDraggableCanceled: (_, _) => setState(() { _dragFrom = null; _dragTo = null; }),
            feedback: Material(
              color: Colors.transparent,
              elevation: 8,
              borderRadius: BorderRadius.circular(12),
              child: Opacity(
                opacity: 0.88,
                child: SizedBox(
                  width: size,
                  height: size,
                  child: _buildContent(entry, originalIdx: originalIdx, isCover: false),
                ),
              ),
            ),
            // childWhenDragging precisa manter o tamanho para não deslocar o Wrap.
            childWhenDragging: SizedBox(width: size, height: size),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: isTarget
                    ? Border.all(color: scheme.primary, width: 2.5)
                    : Border.all(color: Colors.transparent),
              ),
              padding: isTarget ? const EdgeInsets.all(2) : EdgeInsets.zero,
              child: isDragging
                  ? _Placeholder(size: size)
                  : _buildContent(entry, originalIdx: originalIdx, isCover: isCover),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(Object entry, {required int originalIdx, required bool isCover}) {
    if (entry is AdminProductImage) {
      return _ExistingTile(
        image: entry,
        markedForRemoval: widget.removedImageIds.contains(entry.id),
        isCover: isCover && !widget.removedImageIds.contains(entry.id),
        onTap: widget.enabled ? () => widget.onToggleExisting(entry.id) : null,
      );
    }
    return _NewTile(
      path: entry as String,
      isCover: isCover,
      onRemove: widget.enabled ? () => widget.onRemoveNew(originalIdx) : null,
    );
  }
}

// ─── Placeholder do slot vazio durante drag ────────────────────────────────────

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.35),
          style: BorderStyle.solid,
        ),
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.25),
      ),
    );
  }
}

// ─── Tile de imagem existente ──────────────────────────────────────────────────

class _ExistingTile extends StatelessWidget {
  const _ExistingTile({
    required this.image,
    required this.markedForRemoval,
    required this.isCover,
    this.onTap,
  });

  final AdminProductImage image;
  final bool markedForRemoval;
  final bool isCover;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: markedForRemoval
              ? Border.all(color: scheme.error, width: 2)
              : Border.all(color: scheme.outline.withValues(alpha: 0.3)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: ApiConfig.normalizeImageUrl(image.url),
                httpHeaders: const {'Host': ApiConfig.virtualHost},
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Container(
                  color: scheme.surfaceContainerHighest,
                  child: const Icon(Icons.broken_image_outlined),
                ),
              ),
              if (markedForRemoval)
                Container(
                  color: Colors.black54,
                  child: Icon(Icons.delete_outline, color: scheme.onError),
                ),
              if (!markedForRemoval && onTap != null)
                Positioned(
                  top: 4,
                  right: 4,
                  child: _Badge(
                    color: Colors.black38,
                    child: const Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              if (isCover)
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: _Badge(
                    color: Colors.black54,
                    child: const Icon(Icons.star, size: 12, color: Colors.amber),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Tile de nova imagem (local) ───────────────────────────────────────────────

class _NewTile extends StatelessWidget {
  const _NewTile({required this.path, required this.isCover, this.onRemove});

  final String path;
  final bool isCover;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(path), fit: BoxFit.cover),
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onRemove,
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
          ),
          if (isCover)
            Positioned(
              bottom: 4,
              left: 4,
              child: _Badge(
                color: Colors.black54,
                child: const Icon(Icons.star, size: 12, color: Colors.amber),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Tile "adicionar" ─────────────────────────────────────────────────────────

class _AddTile extends StatelessWidget {
  const _AddTile({required this.size, this.onTap});

  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final disabled = onTap == null;

    return SizedBox(
      width: size,
      height: size,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: disabled
                  ? scheme.outline.withValues(alpha: 0.4)
                  : scheme.outline,
            ),
            color: disabled
                ? scheme.surfaceContainerHighest.withValues(alpha: 0.5)
                : scheme.surfaceContainerHighest,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                color: disabled
                    ? scheme.onSurfaceVariant.withValues(alpha: 0.4)
                    : scheme.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.adminProductAddImages,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: disabled
                          ? scheme.onSurfaceVariant.withValues(alpha: 0.4)
                          : scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Helper ───────────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  const _Badge({required this.color, required this.child});
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      padding: const EdgeInsets.all(3),
      child: child,
    );
  }
}
