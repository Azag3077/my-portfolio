import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data.dart';
import '../extensions/extensions.dart';
import '../theme/theme.dart';
import '../widgets.dart';

class AppsSection extends StatelessWidget {
  const AppsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            AppColors.of(context).bg,
            Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF0D0D16)
                : const Color(0xFFEEECFF),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: <Widget>[
          const AnimatedSection(
            child: SectionHeader(
              eyebrow: 'Live on the stores',
              title: 'Featured Apps',
              eyebrowColor: AppColors.accent1,
            ),
          ),
          56.0.horizontalSpace,
          context.isMobile
              ? Column(
                  spacing: 20.0.h,
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
                )
              : Row(
                  spacing: 20.0.w,
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
    return HoverCard(
      borderColor: color,
      glowColor: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Top row
          Row(
            spacing: 8.0.w,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(project.emoji, style: TextStyle(fontSize: 40.0.sp)),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.0.w,
                    vertical: 4.0.h,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.0.r),
                  ),
                  child: Text(
                    project.tagline,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      color: color,
                      fontSize: 11.0.sp,
                      letterSpacing: 0.5,
                      fontWeight: .w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          16.0.verticalSpace,

          // Name
          Text(
            project.name,
            style: GoogleFonts.syne(
              fontSize: 24.0.sp,
              fontWeight: .w800,
              color: AppColors.of(context).text,
            ),
          ),
          8.0.verticalSpace,

          // Description
          Text(
            project.description,
            style: GoogleFonts.dmSans(
              fontSize: 14.0.sp,
              color: AppColors.of(context).muted,
              height: 1.7,
            ),
          ),
          16.0.verticalSpace,

          // Tags
          Wrap(
            spacing: 8.0.w,
            runSpacing: 8.0.h,
            children: project.tags
                .map((t) => PillTag(label: t, color: color))
                .toList(),
          ),
          20.0.verticalSpace,

          // Stats
          Wrap(
            spacing: 24.0.w,
            runSpacing: 8.0.h,
            children: project.stats.map((s) {
              return Column(
                crossAxisAlignment: .start,
                children: <Widget>[
                  Text(
                    s.value,
                    style: GoogleFonts.syne(
                      fontSize: 20,
                      fontWeight: .w800,
                      color: AppColors.of(context).text,
                    ),
                  ),
                  Text(
                    s.label,
                    style: GoogleFonts.dmSans(
                      fontSize: 11.0.sp,
                      color: AppColors.of(context).muted,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          20.0.verticalSpace,

          // Links
          Wrap(
            spacing: 10.0.w,
            runSpacing: 8.0.h,
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: PopupMenuButton<int>(
        onSelected: (index) =>
            _openUrl(widget.link.variants.elementAt(index).url),
        position: PopupMenuPosition.under,
        offset: Offset(0, 8.0.h),
        tooltip: '',
        color: AppColors.of(context).cardHover,
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
            padding: EdgeInsets.symmetric(horizontal: 14.0.w, vertical: 7.0.h),
            decoration: BoxDecoration(
              color: _hovered
                  ? widget.color.withValues(alpha: 0.2)
                  : Colors.transparent,
              border: Border.all(
                color: widget.color.withValues(alpha: 0.4),
                width: 1.5.w,
              ),
              borderRadius: BorderRadius.circular(8.0.r),
            ),
            child: Row(
              spacing: 6.0.w,
              mainAxisSize: .min,
              children: <Widget>[
                if (widget.link.variants.isEmpty)
                  Icon(Icons.arrow_outward, size: 16.0.sp, color: widget.color),

                Text(
                  widget.link.store.label,
                  style: GoogleFonts.dmSans(
                    fontSize: 12.0.sp,
                    fontWeight: .w700,
                    color: widget.color,
                  ),
                ),

                if (widget.link.variants.isNotEmpty)
                  Icon(
                    Icons.arrow_drop_down,
                    color: widget.color,
                    size: 18.0.sp,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
