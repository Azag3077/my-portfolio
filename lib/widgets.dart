import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'theme/app_theme.dart';

// ─── ANIMATED SECTION (fade + slide in on scroll) ────────
class AnimatedSection extends StatefulWidget {
  final Widget child;
  final double delay;

  const AnimatedSection({super.key, required this.child, this.delay = 0});

  @override
  State<AnimatedSection> createState() => _AnimatedSectionState();
}

class _AnimatedSectionState extends State<AnimatedSection>
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
  final Widget child;
  final Color? borderColor;
  final Color? glowColor;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const HoverCard({
    super.key,
    required this.child,
    this.borderColor,
    this.glowColor,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(28),
    this.onTap,
  });

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkCard : AppColors.lightCard;
    final bgHover = isDark ? AppColors.darkCardHover : AppColors.lightCardHover;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

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
            offset: Offset(0, -6 * _elevation.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: widget.padding,
              decoration: BoxDecoration(
                color: _hovered ? bgHover : bg,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: _hovered
                      ? (widget.borderColor ?? AppColors.accent1).withValues(
                          alpha: 0.5,
                        )
                      : border,
                  width: 1.5,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: (widget.glowColor ?? AppColors.accent1)
                              .withValues(alpha: 0.15),
                          blurRadius: 40,
                          spreadRadius: 0,
                          offset: const Offset(0, 16),
                        ),
                      ]
                    : [],
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
  final String eyebrow;
  final String title;
  final Color eyebrowColor;
  final bool center;

  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.eyebrowColor,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: eyebrowColor,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: GoogleFonts.syne(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkText
                : AppColors.lightText,
            letterSpacing: -1.5,
          ),
        ),
      ],
    );
  }
}

// ─── PILL TAG ─────────────────────────────────────────────
class PillTag extends StatelessWidget {
  final String label;
  final Color color;
  final double fontSize;

  const PillTag({
    super.key,
    required this.label,
    required this.color,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.dmSans(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ─── GRADIENT TEXT ────────────────────────────────────────
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Gradient gradient;

  const GradientText(
    this.text, {
    super.key,
    required this.style,
    required this.gradient,
  });

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
  final String value;
  final String label;

  const StatItem({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.syne(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: textColor,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.dmSans(fontSize: 13, color: mutedColor)),
      ],
    );
  }
}

// ─── HOVER LINK BUTTON ───────────────────────────────────
class HoverLinkButton extends StatefulWidget {
  final String label;
  final String url;
  final Color color;

  const HoverLinkButton({
    super.key,
    required this.label,
    required this.url,
    required this.color,
  });

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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.color.withValues(alpha: 0.2)
                : Colors.transparent,
            border: Border.all(
              color: widget.color.withValues(alpha: 0.4),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '↗ ${widget.label}',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}
