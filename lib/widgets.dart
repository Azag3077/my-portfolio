import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'extensions/extensions.dart';
import 'theme/theme.dart';

class AnimatedSection extends StatelessWidget {
  const AnimatedSection({super.key, required this.child, this.delay = 0});

  final Widget child;
  final double delay;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) return child;

    return _AnimatedSection(delay: delay, child: child);
  }
}

// ─── ANIMATED SECTION (fade + slide in on scroll) ────────
class _AnimatedSection extends StatefulWidget {
  const _AnimatedSection({required this.child, this.delay = 0});

  final Widget child;
  final double delay;

  @override
  State<_AnimatedSection> createState() => __AnimatedSectionState();
}

class __AnimatedSectionState extends State<_AnimatedSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _trigger() {
    if (_triggered) return;
    _triggered = true;
    Future.delayed(
      Duration(milliseconds: (widget.delay * 700).toInt()),
      () => mounted ? _ctrl.forward() : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key(widget.hashCode.toString()),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1) _trigger();
      },
      child: FadeTransition(
        opacity: _opacity,
        child: SlideTransition(position: _slide, child: widget.child),
      ),
    );
  }
}

// ─── HOVER CARD ──────────────────────────────────────────
class HoverCard extends StatefulWidget {
  const HoverCard({
    super.key,
    required this.child,
    this.borderColor,
    this.glowColor,
    this.borderRadius,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final Color? borderColor;
  final Color? glowColor;

  final double? borderRadius;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _ctrl;
  late Animation<double> _elevation;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _elevation = Tween<double>(begin: 0, end: 1).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? 20.0.r;
    final padding = widget.padding ?? EdgeInsets.all(28.0.r);

    return MouseRegion(
      onEnter: (_) {
        setState(() => _hovered = true);
        _ctrl.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _ctrl.reverse();
      },
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _elevation,
          builder: (_, child) => Transform.translate(
            offset: Offset(0, -6.0.h * _elevation.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: padding,
              decoration: BoxDecoration(
                color: _hovered
                    ? AppColors.of(context).cardHover
                    : AppColors.of(context).bg,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: _hovered
                      ? (widget.borderColor ?? AppColors.accent1).withValues(
                          alpha: 0.5,
                        )
                      : AppColors.of(context).border,
                  width: 1.5.r,
                ),
                boxShadow: [
                  if (_hovered)
                    BoxShadow(
                      color: (widget.glowColor ?? AppColors.accent1).withValues(
                        alpha: 0.15,
                      ),
                      blurRadius: 40.0.r,
                      offset: Offset(0, 16.r),
                    ),
                ],
              ),
              child: child,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ─── SECTION HEADER ──────────────────────────────────────
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.eyebrowColor,
    this.center = false,
  });

  final String eyebrow;
  final String title;
  final Color eyebrowColor;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10.0.h,
      crossAxisAlignment: center ? .center : .start,
      children: <Widget>[
        Text(
          eyebrow.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 13.0.sp,
            fontWeight: .w700,
            color: eyebrowColor,
            letterSpacing: 3,
          ),
        ),
        Text(
          title,
          style: GoogleFonts.syne(
            fontSize: 48.0.sp,
            fontWeight: .w800,
            color: AppColors.of(context).text,
            letterSpacing: -1.5,
          ),
        ),
      ],
    );
  }
}

// ─── PILL TAG ─────────────────────────────────────────────
class PillTag extends StatelessWidget {
  const PillTag({
    super.key,
    required this.label,
    required this.color,
    this.fontSize,
  });

  final String label;
  final Color color;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 10.0.w, vertical: 4.0.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6.0.r),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: fontSize ?? 12.0.sp,
          fontWeight: .w600,
          color: color,
        ),
      ),
    );
  }
}

// ─── GRADIENT TEXT ────────────────────────────────────────
class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.style,
    required this.gradient,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

// ─── ANIMATED COUNTER / STAT ─────────────────────────────
class StatItem extends StatelessWidget {
  const StatItem({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4.0.h,
      crossAxisAlignment: .start,
      children: <Widget>[
        Text(
          value,
          style: GoogleFonts.syne(
            fontSize: 32.0.sp,
            fontWeight: .w800,
            color: AppColors.of(context).text,
            height: 1,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 13.0.sp,
            color: AppColors.of(context).muted,
          ),
        ),
      ],
    );
  }
}

// ─── HOVER LINK BUTTON ───────────────────────────────────
class HoverLinkButton extends StatefulWidget {
  const HoverLinkButton({
    super.key,
    required this.label,
    required this.url,
    required this.color,
  });

  final String label;
  final String url;
  final Color color;

  @override
  State<HoverLinkButton> createState() => _HoverLinkButtonState();
}

class _HoverLinkButtonState extends State<HoverLinkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () async {
          // url_launcher handled in parent
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: .symmetric(horizontal: 14.0.w, vertical: 7.0.h),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.color.withValues(alpha: 0.2)
                : Colors.transparent,
            border: Border.all(
              color: widget.color.withValues(alpha: 0.4),
              width: 1.5.r,
            ),
            borderRadius: BorderRadius.circular(8.0.r),
          ),
          child: Text(
            '↗ ${widget.label}',
            style: GoogleFonts.dmSans(
              fontSize: 13.0.sp,
              fontWeight: .w700,
              color: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}
