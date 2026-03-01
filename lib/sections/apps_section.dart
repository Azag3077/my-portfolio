import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data.dart';
import '../theme/app_theme.dart';
import '../widgets.dart';

class AppsSection extends StatelessWidget {
  const AppsSection({super.key});

  Color _projectColor(int index) {
    switch (index) {
      case 0:
        return AppColors.accent1;
      case 1:
        return AppColors.accent2;
      default:
        return const Color(0xFF22C55E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 900;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 100, horizontal: w * 0.07),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [AppColors.darkBg, const Color(0xFF0D0D16)]
              : [AppColors.lightBg, const Color(0xFFEEECFF)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AnimatedSection(
            child: SectionHeader(
              eyebrow: 'Live on the stores',
              title: 'Featured Apps',
              eyebrowColor: AppColors.accent1,
            ),
          ),
          const SizedBox(height: 56),
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: projects
                      .asMap()
                      .entries
                      .map(
                        (e) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: e.key < projects.length - 1 ? 20 : 0,
                            ),
                            child: AnimatedSection(
                              delay: e.key * 0.12,
                              child: _AppCard(
                                project: e.value,
                                color: _projectColor(e.value.colorIndex),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                )
              : Column(
                  children: projects
                      .asMap()
                      .entries
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: AnimatedSection(
                            delay: e.key * 0.12,
                            child: _AppCard(
                              project: e.value,
                              color: _projectColor(e.value.colorIndex),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
        ],
      ),
    );
  }
}

class _AppCard extends StatelessWidget {
  final AppProject project;
  final Color color;

  const _AppCard({required this.project, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return HoverCard(
      borderColor: color,
      glowColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(project.emoji, style: const TextStyle(fontSize: 40)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  project.tagline,
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            project.name,
            style: GoogleFonts.syne(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),

          // Description
          Text(
            project.description,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: mutedColor,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 16),

          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: project.tags
                .map((t) => PillTag(label: t, color: color))
                .toList(),
          ),
          const SizedBox(height: 20),

          // Stats
          Row(
            children: project.stats
                .map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.value,
                          style: GoogleFonts.syne(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: textColor,
                          ),
                        ),
                        Text(
                          s.label,
                          style: GoogleFonts.dmSans(
                            fontSize: 11,
                            color: mutedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),

          // Links
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: project.links
                .map((l) => _LinkChip(link: l, color: color))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _LinkChip extends StatefulWidget {
  final AppLink link;
  final Color color;

  const _LinkChip({required this.link, required this.color});

  @override
  State<_LinkChip> createState() => _LinkChipState();
}

class _LinkChipState extends State<_LinkChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.link.url)),
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
            '↗ ${widget.link.label}',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: widget.color,
            ),
          ),
        ),
      ),
    );
  }
}
