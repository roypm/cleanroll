import 'package:flutter/material.dart';

import '../app/theme.dart';

class SwipeablePhoto extends StatefulWidget {
  const SwipeablePhoto({
    super.key,
    required this.child,
    required this.onKeep,
    required this.onDelete,
    this.keepLabel = 'KEEP',
    this.deleteLabel = 'DELETE',
  });

  final Widget child;
  final VoidCallback onKeep;
  final VoidCallback onDelete;
  final String keepLabel;
  final String deleteLabel;

  @override
  State<SwipeablePhoto> createState() => _SwipeablePhotoState();
}

class _SwipeablePhotoState extends State<SwipeablePhoto>
    with SingleTickerProviderStateMixin {
  double _dx = 0;
  double _rotation = 0;
  late final AnimationController _settle;

  static const _threshold = 120.0;

  @override
  void initState() {
    super.initState();
    _settle = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
  }

  @override
  void dispose() {
    _settle.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dx += details.delta.dx;
      _rotation = _dx / 800;
    });
  }

  Future<void> _onDragEnd(DragEndDetails details) async {
    if (_dx > _threshold) {
      await _flingOff(1);
      widget.onKeep();
      _reset();
      return;
    }
    if (_dx < -_threshold) {
      await _flingOff(-1);
      widget.onDelete();
      _reset();
      return;
    }
    await _animateTo(0, 0);
  }

  Future<void> _flingOff(int direction) async {
    final width = MediaQuery.sizeOf(context).width;
    await _animateTo(direction * (width + 80), direction * 0.25);
  }

  Future<void> _animateTo(double dx, double rotation) async {
    final beginDx = _dx;
    final beginRot = _rotation;
    _settle.reset();
    late void Function() listener;
    listener = () {
      final t = Curves.easeOut.transform(_settle.value);
      setState(() {
        _dx = beginDx + (dx - beginDx) * t;
        _rotation = beginRot + (rotation - beginRot) * t;
      });
      if (_settle.isCompleted) {
        _settle.removeListener(listener);
      }
    };
    _settle.addListener(listener);
    await _settle.forward();
  }

  void _reset() {
    setState(() {
      _dx = 0;
      _rotation = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final keepOpacity = (_dx / _threshold).clamp(0.0, 1.0);
    final deleteOpacity = (-_dx / _threshold).clamp(0.0, 1.0);
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: Transform.translate(
        offset: Offset(_dx, 0),
        child: Transform.rotate(
          angle: _rotation,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: widget.child,
              ),
              Positioned(
                top: AppSpacing.lg,
                left: AppSpacing.lg,
                child: Opacity(
                  opacity: deleteOpacity,
                  child: _SwipeBadge(
                    label: widget.deleteLabel,
                    color: scheme.error,
                  ),
                ),
              ),
              Positioned(
                top: AppSpacing.lg,
                right: AppSpacing.lg,
                child: Opacity(
                  opacity: keepOpacity,
                  child: _SwipeBadge(
                    label: widget.keepLabel,
                    color: scheme.primary,
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

class _SwipeBadge extends StatelessWidget {
  const _SwipeBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 3),
        borderRadius: BorderRadius.circular(8),
        color: color.withValues(alpha: 0.12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
