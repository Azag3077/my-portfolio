import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data.dart';
import '../theme/app_theme.dart';
import '../widgets.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  Color _color(int index) {
    switch (index) {
      case 0:
        return AppColors.accent1;
      case 1:
        return AppColors.accent2;
      default:
        return AppColors.accent3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: w * 0.07),
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AnimatedSection(
            child: SectionHeader(
              eyebrow: 'What I work with',
              title: 'Technical Skills',
              eyebrowColor: AppColors.accent3,
              center: true,
            ),
          ),
          const SizedBox(height: 56),
          LayoutBuilder(
            builder: (_, constraints) {
              final cols = constraints.maxWidth > 700 ? 3 : 2;
              return _SkillGrid(
                cols: cols,
                borderColor: borderColor,
                cardColor: cardColor,
                textColor: textColor,
                mutedColor: mutedColor,
                colorFn: _color,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SkillGrid extends StatelessWidget {
  final int cols;
  final Color borderColor;
  final Color cardColor;
  final Color textColor;
  final Color mutedColor;
  final Color Function(int) colorFn;

  const _SkillGrid({
    required this.cols,
    required this.borderColor,
    required this.cardColor,
    required this.textColor,
    required this.mutedColor,
    required this.colorFn,
  });

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowItems.asMap().entries.map((e) {
              final skill = e.value;
              final color = colorFn(skill.colorIndex);
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: e.key < rowItems.length - 1 ? 16 : 0,
                  ),
                  child: AnimatedSection(
                    delay: (i + e.key) * 0.06,
                    child: Container(
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border(
                          top: BorderSide(color: color, width: 3),
                          left: BorderSide(color: borderColor, width: 1.5),
                          right: BorderSide(color: borderColor, width: 1.5),
                          bottom: BorderSide(color: borderColor, width: 1.5),
                        ),
                      ),
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            skill.category,
                            style: GoogleFonts.syne(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: skill.items
                                .map(
                                  (item) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? AppColors.darkBg
                                          : AppColors.lightBg,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: borderColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      item,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: mutedColor,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
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
