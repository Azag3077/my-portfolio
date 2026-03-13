import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants/assets.dart';
import 'extensions/extensions.dart';
import 'sections/apps_section.dart';
import 'sections/contact_section.dart';
import 'sections/experience_section.dart';
import 'sections/hero_section.dart';
import 'sections/skills_section.dart';
import 'theme/theme.dart';
import 'widgets/widgets.dart';

void main() => runApp(const PortfolioApp());

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  final _isDarkVN = ValueNotifier(true);

  @override
  void dispose() {
    _isDarkVN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isDarkVN,
      builder: (context, isDark, child) {
        return MaterialApp(
          title: 'Odunayo Agboola — Flutter Developer',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: PortfolioHome(
            isDark: isDark,
            onToggleTheme: () => _isDarkVN.value = !isDark,
          ),
        );
      },
    );
  }
}

class PortfolioHome extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;

  const PortfolioHome({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final _scrollCtrl = ScrollController();
  final _activeSectionVN = ValueNotifier('About');

  // Section keys for scroll-to
  final _heroKey = GlobalKey();
  final _appsKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _expKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.removeListener(_onScroll);
    _scrollCtrl.dispose();
    _activeSectionVN.dispose();
    super.dispose();
  }

  void _onScroll() => _updateActiveSection();

  void _updateActiveSection() {
    if (!mounted) return;

    final sections = [
      (_heroKey, 'About'),
      (_appsKey, 'Apps'),
      (_skillsKey, 'Skills'),
      (_expKey, 'Experience'),
      (_contactKey, 'Contact'),
    ];
    for (final s in sections.reversed) {
      final ctx = s.$1.currentContext;
      if (ctx != null) {
        final box = ctx.findRenderObject() as RenderBox?;
        if (box != null) {
          final pos = box.localToGlobal(Offset.zero);
          if (pos.dy <= 100) {
            final activeSection = _activeSectionVN.value;
            if (activeSection != s.$2) {
              _activeSectionVN.value = s.$2;
            }
            break;
          }
        }
      }
    }
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      final box = ctx.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      final offset = _scrollCtrl.offset + position.dy - kToolbarHeight - 20;

      _scrollCtrl.animateTo(
        offset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onResumeTap() => launchUrl(Uri.parse(DocAssets.cv));

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.of(context).bg;
    final navBg = bg.withValues(alpha: 0.92);

    final navItems = [
      ('About', _heroKey),
      ('Apps', _appsKey),
      ('Skills', _skillsKey),
      ('Experience', _expKey),
      ('Contact', _contactKey),
    ];

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: navBg,
        surfaceTintColor: navBg,
        shadowColor: AppColors.of(context).border,
        actions: <Widget>[
          24.0.horizontalSpace,
          const _LogoText(),
          24.0.horizontalSpace,
          if (!context.isMobile)
            Flexible(
              child: ValueListenableBuilder<String>(
                valueListenable: _activeSectionVN,
                builder: (context, activeSection, child) {
                  return SingleChildScrollView(
                    scrollDirection: .horizontal,
                    child: Row(
                      spacing: 28.0.w,
                      children: <Widget>[
                        ...navItems.map(
                          (item) => _NavItem(
                            label: item.$1,
                            active: activeSection == item.$1,
                            onTap: () => _scrollTo(item.$2),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: _onResumeTap,
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: .circular(6.0.r),
                            ),
                            side: BorderSide(
                              color: AppColors.of(context).border,
                              width: 2.0.r,
                            ),
                          ),
                          child: const Text('↓ Resumé'),
                        ),
                        .0.horizontalSpace,
                      ],
                    ),
                  );
                },
              ),
            ),

          // Theme toggle
          _ThemeToggle(onToggle: widget.onToggleTheme),
          24.0.horizontalSpace,
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SelectionArea(
        child: Stack(
          children: <Widget>[
            // Main scroll
            SingleChildScrollView(
              controller: _scrollCtrl,
              padding: .symmetric(
                vertical: 120.0.h,
                horizontal: .07.sw(context),
              ),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
                spacing: 120.0.h,
                children: <Widget>[
                  HeroSection(
                    key: _heroKey,
                    onViewAppsTap: () => _scrollTo(_appsKey),
                    onGetInTouchTap: () => _scrollTo(_contactKey),
                    onResumeTap: _onResumeTap,
                  ),
                  AppsSection(key: _appsKey),
                  SkillsSection(key: _skillsKey),
                  ExperienceSection(key: _expKey),
                  ContactSection(key: _contactKey),
                  const _Footer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Logo uses RichText directly:
class _LogoText extends StatelessWidget {
  const _LogoText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.syne(fontSize: 20.0.sp, fontWeight: .w800),
        children: <InlineSpan>[
          const TextSpan(
            text: 'O',
            style: TextStyle(color: AppColors.accent1),
          ),
          TextSpan(
            text: r'dunayo.dev',
            style: TextStyle(color: AppColors.of(context).text),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegionBuilder(
        builder: (context, hovered) {
          return AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: GoogleFonts.dmSans(
              fontSize: 14.0.sp,
              fontWeight: .w500,
              color: active
                  ? AppColors.accent1
                  : hovered
                  ? AppColors.of(context).text
                  : AppColors.of(context).muted,
            ),
            child: Text(label),
          );
        },
      ),
    );
  }
}

class _ThemeToggle extends StatefulWidget {
  const _ThemeToggle({required this.onToggle});

  final VoidCallback onToggle;

  @override
  State<_ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<_ThemeToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _rotation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _onToggle() {
    widget.onToggle();
    if (context.isDark) {
      _ctrl.forward();
    } else {
      _ctrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(8.0.r),
          decoration: BoxDecoration(
            color: AppColors.of(context).card,
            borderRadius: BorderRadius.circular(10.0.r),
            border: Border.all(
              color: AppColors.of(context).border,
              width: 1.5.w,
            ),
          ),
          child: RotationTransition(
            turns: _rotation,
            child: Text(
              context.isDark ? '☀️' : '🌙',
              style: TextStyle(fontSize: 18.sp),
            ),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.0.r),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.of(context).border, width: 1.0.w),
        ),
      ),
      child: Center(
        child: Text(
          '© 2026 Azeez Agboola Odunayo · '
          'Built with Flutter-level precision 🚀',
          style: GoogleFonts.dmSans(
            fontSize: 13.0.sp,
            color: AppColors.of(context).muted,
          ),
        ),
      ),
    );
  }
}
