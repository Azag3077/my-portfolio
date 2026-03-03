import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data.dart';
import '../theme/app_theme.dart';
import '../widgets.dart';

class AppsSection extends StatelessWidget {
  const AppsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w > 900;

    return DecoratedBox(
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
        children: <Widget>[
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
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: projects
                      .asMap()
                      .entries
                      .map(
                        (e) => Expanded(
                          child: AnimatedSection(
                            delay: e.key * 0.12,
                            child: _AppCard(
                              project: e.value,
                              color: AppColors.accents(e.key),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                )
              : Column(
                  spacing: 20,
                  children: projects
                      .asMap()
                      .entries
                      .map(
                        (e) => AnimatedSection(
                          delay: e.key * 0.12,
                          child: _AppCard(
                            project: e.value,
                            color: AppColors.accents(e.key),
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
        children: <Widget>[
          // Top row
          Row(
            spacing: 8.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(project.emoji, style: const TextStyle(fontSize: 40)),
              Flexible(
                child: Container(
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
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                      letterSpacing: 0.5,
                    ),
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
          Wrap(
            spacing: 24,
            runSpacing: 8,
            children: project.stats.map((s) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                    style: GoogleFonts.dmSans(fontSize: 11, color: mutedColor),
                  ),
                ],
              );
            }).toList(),
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
  final StoreLink link;
  final Color color;

  const _LinkChip({required this.link, required this.color});

  @override
  State<_LinkChip> createState() => _LinkChipState();
}

class _LinkChipState extends State<_LinkChip> {
  bool _hovered = false;

  void _openUrl(String url) => launchUrl(Uri.parse(url)).ignore();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: PopupMenuButton<int>(
        onSelected: (index) =>
            _openUrl(widget.link.variants.elementAt(index).url),
        position: PopupMenuPosition.under,
        offset: const Offset(0, 8),
        tooltip: '',
        color: isDark ? const Color(0xFF1A1A28) : AppColors.lightCardHover,
        itemBuilder: (context) {
          return widget.link.variants.asMap().entries.map((entry) {
            return PopupMenuItem<int>(
              value: entry.key,
              child: Text(entry.value.label),
            );
          }).toList();
        },
        child: GestureDetector(
          onTap: widget.link.url == null
              ? null
              : () => _openUrl(widget.link.url!),
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
            child: Row(
              spacing: 6.0,
              mainAxisSize: .min,
              children: <Widget>[
                if (widget.link.variants.isEmpty)
                  Icon(Icons.arrow_outward, size: 16, color: widget.color),

                Text(
                  widget.link.store.label,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: widget.color,
                  ),
                ),

                if (widget.link.variants.isNotEmpty)
                  Icon(Icons.arrow_drop_down, size: 18, color: widget.color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
