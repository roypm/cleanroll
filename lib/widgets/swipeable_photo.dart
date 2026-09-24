import 'package:flutter/material.dart';

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
  static const _stampAngle = 0.26;
  static const _stampTop = 40.0;
  static const _stampSide = 28.0;

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
    final keepProgress = (_dx / _threshold).clamp(0.0, 1.0);
    final deleteProgress = (-_dx / _threshold).clamp(0.0, 1.0);
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
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: widget.child,
              ),
              Positioned(
                top: _stampTop,
                left: _stampSide,
                right: _stampSide,
                child: _SwipeStamp(
                  label: widget.keepLabel,
                  color: scheme.primary,
                  progress: keepProgress,
                  angle: -_stampAngle,
                  alignment: Alignment.topLeft,
                ),
              ),
              Positioned(
                top: _stampTop,
                left: _stampSide,
                right: _stampSide,
                child: _SwipeStamp(
                  label: widget.deleteLabel,
                  color: scheme.error,
                  progress: deleteProgress,
                  angle: _stampAngle,
                  alignment: Alignment.topRight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwipeStamp extends StatelessWidget {
  const _SwipeStamp({
    required this.label,
    required this.color,
    required this.progress,
    required this.angle,
    required this.alignment,
  });

  final String label;
  final Color color;
  final double progress;
  final double angle;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: alignment,
        child: Opacity(
          opacity: progress,
          child: Transform.rotate(
            angle: angle,
            child: Transform.scale(
              scale: 0.85 + 0.15 * progress,
              child: _SwipeBadge(label: label, color: color),
            ),
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
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 4),
          borderRadius: BorderRadius.circular(8),
          color: color.withValues(alpha: 0.12),
        ),
        child: Text(
          label,
          maxLines: 1,
          style: TextStyle(
            color: color,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            height: 1,
          ),
        ),
      ),
    );
  }
}
