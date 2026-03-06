import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MouseRegionBuilder extends StatefulWidget {
  const MouseRegionBuilder({
    super.key,
    required this.builder,
    this.cursor = MouseCursor.defer,
    this.onEnter,
    this.onExit,
  });

  final Widget Function(BuildContext context, bool hovered) builder;
  final PointerEnterEventListener? onEnter;
  final MouseCursor? cursor;
  final PointerExitEventListener? onExit;

  @override
  State<MouseRegionBuilder> createState() => _MouseRegionBuilderState();
}

class _MouseRegionBuilderState extends State<MouseRegionBuilder> {
  final _hoveredVN = ValueNotifier(false);

  @override
  void dispose() {
    _hoveredVN.dispose();
    super.dispose();
  }

  void _onHovered(bool value) {
    if (!mounted) return;
    _hoveredVN.value = value;
  }

  void _onEnter(PointerEnterEvent value) {
    widget.onEnter?.call(value);
    _onHovered(true);
  }

  void _onExit(PointerExitEvent value) {
    widget.onExit?.call(value);
    _onHovered(false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.cursor ?? SystemMouseCursors.click,
      onEnter: _onEnter,
      onExit: _onExit,
      child: ValueListenableBuilder<bool>(
        valueListenable: _hoveredVN,
        builder: (context, hovered, _) {
          return widget.builder(context, hovered);
        },
      ),
    );
  }
}
