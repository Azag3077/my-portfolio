import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/constants.dart';
import '../data.dart';
import '../extensions/extensions.dart';
import '../theme/theme.dart';
import '../widgets.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 56.0,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const AnimatedSection(
          child: SectionHeader(
            eyebrow: 'What I work with',
            title: 'Technical Skills',
            eyebrowColor: AppColors.accent3,
            center: true,
          ),
        ),
        LayoutBuilder(
          builder: (_, constraints) {
            final cols = constraints.maxWidth > BreakPoint.mobile ? 3 : 2;
            return _SkillGrid(cols: cols);
          },
        ),
      ],
    );
  }
}

class _SkillGrid extends StatelessWidget {
  const _SkillGrid({required this.cols});

  final int cols;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (int i = 0; i < skills.length; i += cols) {
      final rowItems = skills.sublist(
        i,
        i + cols > skills.length ? skills.length : i + cols,
      );
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            spacing: 16.0.w,
            crossAxisAlignment: .start,
            children: rowItems.asMap().entries.map((e) {
              final skill = e.value;
              final color = AppColors.accents(e.key);

              // return Expanded(
              //   child: AnimatedSection(
              //     delay: (i + e.key) * 0.06,
              //     child: CustomPaint(
              //       painter: AsymmetricBorderPainter(
              //         mainColor: borderColor,
              //         accentColor: color,       // the special color
              //         mainWidth: 1.5,
              //         accentWidth: 3.0,
              //         accentSide: BorderSide1.top, // accent goes on top
              //         borderRadius: 16,
              //       ),
              //       child: Container(
              //         decoration: BoxDecoration(
              //           color: cardColor,
              //           borderRadius: BorderRadius.circular(16),
              //           // border: Border.all(color: borderColor, width: 1.5),
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.all(22),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: <Widget>[
              //               Text(
              //                 skill.category,
              //                 style: GoogleFonts.syne(
              //                   fontSize: 15,
              //                   fontWeight: .w700,
              //                   color: color,
              //                 ),
              //               ),
              //               const SizedBox(height: 14),
              //               Wrap(
              //                 spacing: 8,
              //                 runSpacing: 8,
              //                 children: skill.items
              //                     .map(
              //                       (item) => Container(
              //                     padding: const EdgeInsets.symmetric(
              //                       horizontal: 12,
              //                       vertical: 5,
              //                     ),
              //                     decoration: BoxDecoration(
              //                       color:
              //                       Theme.of(context).brightness ==
              //                           Brightness.dark
              //                           ? AppColors.darkBg
              //                           : AppColors.of(context).bg,
              //                       borderRadius: BorderRadius.circular(
              //                         6,
              //                       ),
              //                       border: Border.all(
              //                         color: borderColor,
              //                         width: 1,
              //                       ),
              //                     ),
              //                     child: Text(
              //                       item,
              //                       style: GoogleFonts.dmSans(
              //                         fontSize: 12,
              //                         fontWeight: .w500,
              //                         color: mutedColor,
              //                       ),
              //                     ),
              //                   ),
              //                 )
              //                     .toList(),
              //               ),
              //             ],
              //           ),
              //         ),
              //         // child: ClipRRect(
              //         //   borderRadius: BorderRadius.circular(16),
              //         //   child: Column(
              //         //     children: <Widget>[
              //         //       // Colored top bar
              //         //       Container(
              //         //         decoration: BoxDecoration(
              //         //           color: cardColor,
              //         //           border: Border(
              //         //             top: BorderSide(color: color, width: 6.0),
              //         //           ),
              //         //         ),
              //         //       ),
              //         //
              //         //       Padding(
              //         //         padding: const EdgeInsets.all(22),
              //         //         child: Column(
              //         //           crossAxisAlignment: CrossAxisAlignment.start,
              //         //           children: <Widget>[
              //         //             Text(
              //         //               skill.category,
              //         //               style: GoogleFonts.syne(
              //         //                 fontSize: 15,
              //         //                 fontWeight: .w700,
              //         //                 color: color,
              //         //               ),
              //         //             ),
              //         //             const SizedBox(height: 14),
              //         //             Wrap(
              //         //               spacing: 8,
              //         //               runSpacing: 8,
              //         //               children: skill.items
              //         //                   .map(
              //         //                     (item) => Container(
              //         //                   padding: const EdgeInsets.symmetric(
              //         //                     horizontal: 12,
              //         //                     vertical: 5,
              //         //                   ),
              //         //                   decoration: BoxDecoration(
              //         //                     color:
              //         //                     Theme.of(context).brightness ==
              //         //                         Brightness.dark
              //         //                         ? AppColors.darkBg
              //         //                         : AppColors.of(context).bg,
              //         //                     borderRadius: BorderRadius.circular(
              //         //                       6,
              //         //                     ),
              //         //                     border: Border.all(
              //         //                       color: borderColor,
              //         //                       width: 1,
              //         //                     ),
              //         //                   ),
              //         //                   child: Text(
              //         //                     item,
              //         //                     style: GoogleFonts.dmSans(
              //         //                       fontSize: 12,
              //         //                       fontWeight: .w500,
              //         //                       color: mutedColor,
              //         //                     ),
              //         //                   ),
              //         //                 ),
              //         //               )
              //         //                   .toList(),
              //         //             ),
              //         //           ],
              //         //         ),
              //         //       ),
              //         //     ],
              //         //   ),
              //         // ),
              //       ),
              //     ),
              //   ),
              // );
              return Expanded(
                child: AnimatedSection(
                  delay: (i + e.key) * 0.06,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.of(context).card,
                      borderRadius: BorderRadius.circular(16.0.r),
                      border: Border.all(
                        color: AppColors.of(context).border,
                        width: 1.5.w,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0.r),
                      child: Column(
                        children: <Widget>[
                          // Colored top bar
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.of(context).card,
                              border: Border(
                                top: BorderSide(color: color, width: 6.0.w),
                              ),
                            ),
                          ),

                          Padding(
                            padding: .all(22.0.r),
                            child: Column(
                              crossAxisAlignment: .start,
                              children: <Widget>[
                                Text(
                                  skill.category,
                                  style: GoogleFonts.syne(
                                    fontSize: 15.0.sp,
                                    fontWeight: .w700,
                                    color: color,
                                  ),
                                ),
                                14.0.verticalSpace,
                                Wrap(
                                  spacing: 8.0.w,
                                  runSpacing: 8.0.h,
                                  children: skill.items
                                      .map(
                                        (item) => Container(
                                          padding: .symmetric(
                                            horizontal: 12.0.w,
                                            vertical: 5.0.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.of(context).bg,
                                            borderRadius: .circular(6.0.r),
                                            border: .all(
                                              color: AppColors.of(
                                                context,
                                              ).border,
                                              width: 1.0.w,
                                            ),
                                          ),
                                          child: Text(
                                            item,
                                            style: GoogleFonts.dmSans(
                                              fontSize: 12.0.sp,
                                              fontWeight: .w500,
                                              color: AppColors.of(
                                                context,
                                              ).muted,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }

    return Column(children: rows);
  }
}

class AsymmetricBorderPainter extends CustomPainter {
  const AsymmetricBorderPainter({
    required this.mainColor,
    required this.accentColor,
    this.mainWidth = 1.5,
    this.accentWidth = 3.0,
    this.accentSide = BorderSide1.none, // use Top, Left, Right, Bottom
    this.borderRadius = 16,
  });

  final Color mainColor;
  final Color accentColor;
  final double mainWidth;
  final double accentWidth;
  final BorderSide1 accentSide; // which side gets the accent
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(borderRadius);
    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      radius,
    );

    // Draw main border (all sides, same color)
    final mainPaint = Paint()
      ..color = mainColor
      ..strokeWidth = mainWidth
      ..style = PaintingStyle.stroke;

    canvas.drawRRect(rRect, mainPaint);

    // Draw accent side on top
    final accentPaint = Paint()
      ..color = accentColor
      ..strokeWidth = accentWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;

    switch (accentSide) {
      case BorderSide1.top:
        canvas.drawLine(
          Offset(borderRadius, 0),
          Offset(size.width - borderRadius, 0),
          accentPaint,
        );
        break;
      case BorderSide1.bottom:
        canvas.drawLine(
          Offset(borderRadius, size.height),
          Offset(size.width - borderRadius, size.height),
          accentPaint,
        );
        break;
      case BorderSide1.left:
        canvas.drawLine(
          Offset(0, borderRadius),
          Offset(0, size.height - borderRadius),
          accentPaint,
        );
        break;
      case BorderSide1.right:
        canvas.drawLine(
          Offset(size.width, borderRadius),
          Offset(size.width, size.height - borderRadius),
          accentPaint,
        );
        break;
      default:
        break;
    }
  }

  @override
  bool shouldRepaint(AsymmetricBorderPainter old) =>
      old.mainColor != mainColor ||
      old.accentColor != accentColor ||
      old.accentSide != accentSide;
}

enum BorderSide1 { top, bottom, left, right, none }
