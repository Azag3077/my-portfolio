import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'sections/apps_section.dart';
import 'sections/contact_section.dart';
import 'sections/experience_section.dart';
import 'sections/hero_section.dart';
import 'sections/skills_section.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  bool _isDark = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odunayo Agboola — Flutter Developer',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: PortfolioHome(
        isDark: _isDark,
        onToggleTheme: () => setState(() => _isDark = !_isDark),
      ),
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
  String _activeSection = 'About';

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
    super.dispose();
  }

  void _onScroll() => _updateActiveSection();

  void _updateActiveSection() {
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
            if (_activeSection != s.$2) {
              setState(() => _activeSection = s.$2);
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

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final navBg = isDark
        ? AppColors.darkBg.withValues(alpha: 0.92)
        : AppColors.lightBg.withValues(alpha: 0.92);
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final w = MediaQuery.of(context).size.width;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

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
        title: const _LogoText(),
        backgroundColor: navBg,
        surfaceTintColor: navBg,
        shadowColor: borderColor,
        actions: <Widget>[
          Row(
            spacing: 28.0,
            children: [
              if (w > 600)
                ...navItems.map(
                  (item) => _NavItem(
                    label: item.$1,
                    active: _activeSection == item.$1,
                    mutedColor: mutedColor,
                    onTap: () => _scrollTo(item.$2),
                  ),
                ),

              // Theme toggle
              _ThemeToggle(isDark: isDark, onToggle: widget.onToggleTheme),
              const SizedBox(width: 24),
            ],
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SelectionArea(
        child: Stack(
          children: <Widget>[
            // Main scroll
            SingleChildScrollView(
              controller: _scrollCtrl,
              padding: EdgeInsets.symmetric(
                vertical: 120,
                horizontal: w * 0.07,
              ),
              child: Column(
                spacing: 120,
                children: <Widget>[
                  HeroSection(
                    key: _heroKey,
                    onViewAppsTap: () => _scrollTo(_appsKey),
                    onGetInTouchTap: () => _scrollTo(_contactKey),
                  ),
                  AppsSection(key: _appsKey),
                  SkillsSection(key: _skillsKey),
                  ExperienceSection(key: _expKey),
                  ContactSection(key: _contactKey),
                  _Footer(isDark: isDark),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return RichText(
      text: TextSpan(
        style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800),
        children: <InlineSpan>[
          const TextSpan(
            text: 'O',
            style: TextStyle(color: AppColors.accent1),
          ),
          TextSpan(
            text: r'dunayo.dev',
            style: TextStyle(color: textColor),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final bool active;
  final Color mutedColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.active,
    required this.mutedColor,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: widget.active
                ? AppColors.accent1
                : _hovered
                ? textColor
                : widget.mutedColor,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _ThemeToggle extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const _ThemeToggle({required this.isDark, required this.onToggle});

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          widget.onToggle();
          if (widget.isDark) {
            _ctrl.forward();
          } else {
            _ctrl.reverse();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: RotationTransition(
            turns: _rotation,
            child: Text(
              widget.isDark ? '☀️' : '🌙',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final bool isDark;

  const _Footer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor, width: 1)),
      ),
      child: Center(
        child: Text(
          '© 2026 Azeez Agboola Odunayo · Built with Flutter-level precision 🚀',
          style: GoogleFonts.dmSans(fontSize: 13, color: mutedColor),
        ),
      ),
    );
  }
}
