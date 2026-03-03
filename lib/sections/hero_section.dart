import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data.dart';
import '../theme/app_theme.dart';
import '../widgets.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.onViewAppsTap,
    required this.onGetInTouchTap,
  });

  final VoidCallback onViewAppsTap;
  final VoidCallback onGetInTouchTap;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  final _words = [
    'Flutter Developer',
    'Mobile Engineer',
    'App Creator',
    'Problem Solver',
  ];
  int _wordIndex = 0;
  late AnimationController _wordCtrl;
  late Animation<double> _wordOpacity;
  late Animation<Offset> _wordSlide;
  late Timer _timer;

  // Floating blobs animation
  late AnimationController _blobCtrl;
  late Animation<double> _blobAnim;

  @override
  void initState() {
    super.initState();

    _wordCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _wordOpacity = Tween<double>(begin: 0, end: 1).animate(_wordCtrl);
    _wordSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _wordCtrl, curve: Curves.easeOut));
    _wordCtrl.forward();

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _wordCtrl.reverse().then((_) {
        if (mounted) {
          setState(() => _wordIndex = (_wordIndex + 1) % _words.length);
          _wordCtrl.forward();
        }
      });
    });

    _blobCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _blobAnim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _blobCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _timer.cancel();
    _wordCtrl.dispose();
    _blobCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 900;

    return AnimatedBuilder(
      animation: _blobAnim,
      builder: (context, child) {
        return Stack(
          children: <Widget>[
            Positioned(
              bottom: 50 - 45 * _blobAnim.value,
              left: -40,
              child: _blob(320, AppColors.accent2, 0.15),
            ),
            Positioned(
              top: 300 + 40 * _blobAnim.value,
              left: w * 0.3,
              child: _blob(180, AppColors.accent3, 0.14),
            ),
            Positioned(
              top: 80 + 80 * _blobAnim.value,
              right: w * 0.05,
              child: _blob(380, AppColors.accent1, 0.15),
            ),

            /// Content
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Available badge
                  AnimatedSection(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 40,
                          height: 2,
                          color: AppColors.accent1,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Available for hire',
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accent1,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name
                  AnimatedSection(
                    delay: 0.1,
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.syne(
                          fontSize: isWide ? 88 : 52,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -3,
                          height: 1.0,
                        ),
                        children: [
                          TextSpan(
                            text: 'Odunayo\n',
                            style: TextStyle(color: textColor),
                          ),
                          const TextSpan(
                            text: 'Agboola',
                            style: TextStyle(color: AppColors.accent1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Animated word
                  AnimatedSection(
                    delay: 0.15,
                    child: SizedBox(
                      height: isWide ? 60 : 40,
                      child: FadeTransition(
                        opacity: _wordOpacity,
                        child: SlideTransition(
                          position: _wordSlide,
                          child: GradientText(
                            _words[_wordIndex],
                            style: GoogleFonts.syne(
                              fontSize: isWide ? 42 : 26,
                              fontWeight: FontWeight.w700,
                            ),
                            gradient: const LinearGradient(
                              colors: [AppColors.accent2, AppColors.accent3],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tagline
                  AnimatedSection(
                    delay: 0.2,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Text(
                        '4+ years crafting cross-platform mobile experiences. '
                        'I build apps that live in the real world — on the '
                        'Play Store, on the App Store, in users\' hands.',
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          color: mutedColor,
                          height: 1.75,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // CTA buttons
                  AnimatedSection(
                    delay: 0.25,
                    child: Wrap(
                      spacing: 16,
                      runSpacing: 12,
                      children: <Widget>[
                        _CtaButton(
                          label: 'View My Apps ↓',
                          filled: true,
                          color: AppColors.accent1,
                          onTap: widget.onViewAppsTap,
                        ),
                        _CtaButton(
                          label: 'Get in Touch',
                          filled: false,
                          color: AppColors.accent2,
                          onTap: widget.onGetInTouchTap,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Stats
                  AnimatedSection(
                    delay: 0.3,
                    child: Wrap(
                      spacing: 40,
                      runSpacing: 24,
                      children: heroStats
                          .map(
                            (s) => StatItem(
                              value: s['value']!,
                              label: s['label']!,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _blob(double size, Color color, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            color.withValues(alpha: opacity),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _CtaButton extends StatefulWidget {
  final String label;
  final bool filled;
  final Color color;
  final VoidCallback onTap;

  const _CtaButton({
    required this.label,
    required this.filled,
    required this.color,
    required this.onTap,
  });

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  final _hoveredValueNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hoveredValueNotifier.dispose();
    super.dispose();
  }

  void _updateHovered(bool value) => _hoveredValueNotifier.value = value;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _updateHovered(true),
      onExit: (_) => _updateHovered(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: ValueListenableBuilder<bool>(
          valueListenable: _hoveredValueNotifier,
          builder: (context, hovered, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                color: widget.filled ? widget.color : Colors.transparent,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: widget.filled
                      ? Colors.transparent
                      : widget.color.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: <BoxShadow>[
                  if (widget.filled && hovered)
                    BoxShadow(
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                      color: widget.color.withValues(alpha: 0.4),
                    ),
                ],
              ),
              transform: hovered
                  ? Matrix4.translationValues(0, -2, 0)
                  : Matrix4.identity(),
              child: Text(
                widget.label,
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: widget.filled ? Colors.white : widget.color,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
