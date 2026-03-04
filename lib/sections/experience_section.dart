import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/breakpoints.dart';
import '../data.dart';
import '../extensions/extensions.dart';
import '../theme/theme.dart';
import '../widgets.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20.0.h,
      crossAxisAlignment: .start,
      children: <Widget>[
        const AnimatedSection(
          child: SectionHeader(
            eyebrow: 'Where I\'ve worked',
            title: 'Experience',
            eyebrowColor: AppColors.accent2,
          ),
        ),
        56.0.verticalSpace,
        ...experiences.asMap().entries.map(
          (e) => AnimatedSection(
            delay: e.key * 0.1,
            child: _ExperienceCard(
              item: e.value,
              color: AppColors.accents(e.key),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.item, required this.color});

  final ExperienceItem item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final border = Border.all(
      color: AppColors.of(context).border,
      width: 1.5.r,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.of(context).card,
        borderRadius: .circular(20.0.r),
        border: border.copyWith(
          left: BorderSide(color: border.top.color, width: 4.0.r),
        ),
      ),
      padding: .all(32.0.r),
      child: Column(
        crossAxisAlignment: .start,
        children: <Widget>[
          // Header row
          LayoutBuilder(
            builder: (_, constraints) {
              final header = Row(
                crossAxisAlignment: .start,
                mainAxisAlignment: .spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: <Widget>[
                        Text(
                          item.role,
                          style: GoogleFonts.syne(
                            fontSize: 22.0.sp,
                            fontWeight: .w800,
                            color: AppColors.of(context).text,
                          ),
                        ),
                        4.0.verticalSpace,
                        Text(
                          item.company,
                          style: GoogleFonts.dmSans(
                            fontSize: 15.0.sp,
                            fontWeight: .w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: .symmetric(horizontal: 16.0.w, vertical: 6.0.h),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).bg,
                      borderRadius: .circular(20.0.r),
                      border: .all(
                        color: AppColors.of(context).border,
                        width: 1.0.r,
                      ),
                    ),
                    child: Text(
                      item.period,
                      style: GoogleFonts.dmSans(
                        fontSize: 13.0.sp,
                        color: AppColors.of(context).muted,
                        fontWeight: .w500,
                      ),
                    ),
                  ),
                ],
              );

              if (constraints.maxWidth > BreakPoint.mobile) {
                return header;
              }

              return Column(children: [header]);
            },
          ),
          20.0.verticalSpace,

          // Bullet points
          ...item.points.map(
            (p) => Padding(
              padding: .only(bottom: 10.0.h),
              child: Row(
                crossAxisAlignment: .start,
                children: <Widget>[
                  Padding(
                    padding: .only(top: 2.0.h, right: 12.0.w),
                    child: Text(
                      '▸',
                      style: TextStyle(color: color, fontSize: 14.0.sp),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      p,
                      style: GoogleFonts.dmSans(
                        fontSize: 14.0.sp,
                        color: AppColors.of(context).muted,
                        height: 1.65,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
