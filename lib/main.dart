import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'sections/apps_section.dart';
import 'sections/hero_section.dart';
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
      title: 'Azeez Agboola — Flutter Developer',
      debugShowCheckedModeBanner: false,
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
  bool _navScrolled = false;
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

  void _onScroll() {
    final offset = _scrollCtrl.offset;
    setState(() {
      _navScrolled = offset > 50;
    });
    _updateActiveSection();
  }

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
      Scrollable.ensureVisible(
        ctx,
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

    return Scaffold(
      backgroundColor: bg,
      body: SelectionArea(
        child: Stack(
          children: [
            // Main scroll
            SingleChildScrollView(
              controller: _scrollCtrl,
              child: Column(
                children: [
                  SizedBox(key: _heroKey, child: const HeroSection()),
                  SizedBox(key: _appsKey, child: const AppsSection()),
                  // SizedBox(key: _skillsKey, child: const SkillsSection()),
                  // SizedBox(key: _expKey, child: const ExperienceSection()),
                  // SizedBox(key: _contactKey, child: const ContactSection()),
                  _Footer(isDark: isDark),
                ],
              ),
            ),

            // Sticky navbar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: _navScrolled ? navBg : Colors.transparent,
                  border: _navScrolled
                      ? Border(bottom: BorderSide(color: borderColor, width: 1))
                      : const Border(),
                  boxShadow: _navScrolled
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                          ),
                        ]
                      : [],
                ),
                child: ClipRRect(
                  child: _navScrolled
                      ? _buildNavContent(isDark, borderColor)
                      : _buildNavContent(isDark, borderColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavContent(bool isDark, Color borderColor) {
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;
    final w = MediaQuery.of(context).size.width;

    final navItems = [
      ('About', _heroKey),
      ('Apps', _appsKey),
      ('Skills', _skillsKey),
      ('Experience', _expKey),
      ('Contact', _contactKey),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.07),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            // Logo
            _LogoText(textColor: textColor),
            const Spacer(),

            // Nav items (hide on very small screens)
            if (w > 600)
              ...navItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: _NavItem(
                    label: item.$1,
                    active: _activeSection == item.$1,
                    mutedColor: mutedColor,
                    onTap: () => _scrollTo(item.$2),
                  ),
                ),
              ),

            const SizedBox(width: 24),

            // Theme toggle
            _ThemeToggle(isDark: isDark, onToggle: widget.onToggleTheme),
          ],
        ),
      ),
    );
  }
}

// Logo uses RichText directly:
class _LogoText extends StatelessWidget {
  final Color textColor;

  const _LogoText({required this.textColor});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w800),
        children: [
          const TextSpan(
            text: 'A',
            style: TextStyle(color: AppColors.accent1),
          ),
          TextSpan(
            text: 'zeez.dev',
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
