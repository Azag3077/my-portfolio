import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data.dart';
import '../theme/app_theme.dart';
import '../widgets.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;

    return Column(
      spacing: 20.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const AnimatedSection(
          child: SectionHeader(
            eyebrow: 'Where I\'ve worked',
            title: 'Experience',
            eyebrowColor: AppColors.accent2,
          ),
        ),
        const SizedBox(height: 56),
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
  final ExperienceItem item;
  final Color color;

  const _ExperienceCard({required this.item, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final bgColor = isDark ? AppColors.darkBg : AppColors.lightBg;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border(
          // left: BorderSide(color: color, width: 4),
          left: BorderSide(color: borderColor, width: 4),
          top: BorderSide(color: borderColor, width: 1.5),
          right: BorderSide(color: borderColor, width: 1.5),
          bottom: BorderSide(color: borderColor, width: 1.5),
        ),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Header row
          LayoutBuilder(
            builder: (_, constraints) {
              final isWide = constraints.maxWidth > 500;
              final header = Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.role,
                          style: GoogleFonts.syne(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.company,
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: borderColor, width: 1),
                    ),
                    child: Text(
                      item.period,
                      style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: mutedColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
              return isWide ? header : Column(children: [header]);
            },
          ),
          const SizedBox(height: 20),

          // Bullet points
          ...item.points.map(
            (p) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 2, right: 12),
                    child: Text(
                      '▸',
                      style: TextStyle(color: color, fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      p,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: mutedColor,
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
