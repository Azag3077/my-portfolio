import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data.dart';
import '../extensions/extensions.dart';
import '../theme/theme.dart';
import '../widgets.dart';
import '../widgets/widgets.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({
    super.key,
    required this.onViewAppsTap,
    required this.onGetInTouchTap,
    required this.onResumeTap,
  });

  final VoidCallback onViewAppsTap;
  final VoidCallback onResumeTap;
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
  final _wordIndexVN = ValueNotifier(0);
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
          final wordIndex = _wordIndexVN.value;
          _wordIndexVN.value = (wordIndex + 1) % _words.length;
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
    _wordIndexVN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _blobAnim,
      builder: (context, child) {
        return Stack(
          children: <Widget>[
            Positioned(
              bottom: 50.0.h - 45.0.h * _blobAnim.value,
              left: -40.0.w,
              child: _Blob(
                dimension: 320.0.r,
                color: AppColors.accent2.withValues(alpha: 0.15),
              ),
            ),
            Positioned(
              top: 300 + 40 * _blobAnim.value,
              left: 0.3.sw(context),
              child: _Blob(
                dimension: 180.0.r,
                color: AppColors.accent3.withValues(alpha: 0.14),
              ),
            ),
            Positioned(
              top: 80 + 80 * _blobAnim.value,
              right: 0.05.sw(context),
              child: _Blob(
                dimension: 380.0.r,
                color: AppColors.accent1.withValues(alpha: 0.15),
              ),
            ),

            /// Content
            Align(
              alignment: .centerLeft,
              child: Column(
                crossAxisAlignment: .start,
                children: <Widget>[
                  // Available badge
                  AnimatedSection(
                    child: Row(
                      mainAxisSize: .min,
                      children: <Widget>[
                        Container(
                          width: 40.0.w,
                          height: 2.0.h,
                          color: AppColors.accent1,
                        ),
                        12.0.horizontalSpace,
                        Text(
                          'Available for hire',
                          style: GoogleFonts.dmSans(
                            fontSize: 14.0.sp,
                            fontWeight: .w700,
                            color: AppColors.accent1,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  24.0.verticalSpace,

                  // Name
                  AnimatedSection(
                    delay: 0.1,
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.syne(
                          fontSize: (context.isDesktop ? 88 : 52).sp,
                          fontWeight: .w800,
                          letterSpacing: -3,
                          height: 1.0,
                        ),
                        children: <InlineSpan>[
                          TextSpan(
                            text: 'Odunayo\n',
                            style: TextStyle(color: AppColors.of(context).text),
                          ),
                          const TextSpan(
                            text: 'Agboola',
                            style: TextStyle(color: AppColors.accent1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  8.0.verticalSpace,

                  // Animated word
                  AnimatedSection(
                    delay: 0.15,
                    child: SizedBox(
                      height: (context.isDesktop ? 60 : 40).h,
                      child: FadeTransition(
                        opacity: _wordOpacity,
                        child: SlideTransition(
                          position: _wordSlide,
                          child: ValueListenableBuilder<int>(
                            valueListenable: _wordIndexVN,
                            builder: (context, index, child) {
                              return GradientText(
                                _words.elementAt(index),
                                style: GoogleFonts.syne(
                                  fontSize: (context.isDesktop ? 42 : 26).sp,
                                  fontWeight: .w700,
                                ),
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.accent2,
                                    AppColors.accent3,
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  24.0.verticalSpace,

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
                          fontSize: 18.0.sp,
                          color: AppColors.of(context).muted,
                          height: 1.75,
                        ),
                      ),
                    ),
                  ),
                  40.0.verticalSpace,

                  // CTA buttons
                  Wrap(
                    spacing: 16.0.w,
                    runSpacing: 12.0.h,
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
                      _CtaButton(
                        label: '↓ Resumé',
                        filled: false,
                        color: AppColors.accent3,
                        onTap: widget.onResumeTap,
                      ),
                    ],
                  ),
                  60.0.verticalSpace,

                  // Stats
                  AnimatedSection(
                    delay: 0.3,
                    child: Wrap(
                      spacing: 40.0.w,
                      runSpacing: 24.0.h,
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
}

class _Blob extends StatelessWidget {
  const _Blob({required this.dimension, required this.color});

  final double dimension;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: dimension,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: <Color>[color, Colors.transparent]),
        ),
      ),
    );
  }
}

class _CtaButton extends StatelessWidget {
  const _CtaButton({
    required this.label,
    required this.filled,
    required this.color,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegionBuilder(
        builder: (context, hovered) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 32.0.w, vertical: 14.0.h),
            decoration: BoxDecoration(
              color: filled ? color : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: filled
                    ? Colors.transparent
                    : color.withValues(alpha: 0.4),
                width: 1.5,
              ),
              boxShadow: <BoxShadow>[
                if (filled && hovered)
                  BoxShadow(
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                    color: color.withValues(alpha: 0.4),
                  ),
              ],
            ),
            transform: hovered
                ? Matrix4.translationValues(0, -2, 0)
                : Matrix4.identity(),
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 15.0.sp,
                fontWeight: .w700,
                color: filled ? Colors.white : color,
              ),
            ),
          );
        },
      ),
    );
  }
}
