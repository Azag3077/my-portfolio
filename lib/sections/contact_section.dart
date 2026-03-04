import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';
import '../widgets.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  bool _sent = false;

  void _submit() {
    if (_nameCtrl.text.isEmpty ||
        _emailCtrl.text.isEmpty ||
        _msgCtrl.text.isEmpty) {
      return;
    }
    final subject = Uri.encodeComponent(
      'Portfolio Contact from ${_nameCtrl.text}',
    );
    final body = Uri.encodeComponent(
      'Name: ${_nameCtrl.text}\nEmail: ${_emailCtrl.text}\n\n${_msgCtrl.text}',
    );
    launchUrl(
      Uri.parse(
        'mailto:agboolaodunayo2016@gmail.com?subject=$subject&body=$body',
      ),
    );
    setState(() => _sent = true);
    Future.delayed(
      const Duration(seconds: 4),
      () => mounted ? setState(() => _sent = false) : null,
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Column(
          children: <Widget>[
            const AnimatedSection(
              child: SectionHeader(
                eyebrow: 'Let\'s work together',
                title: 'Get in Touch',
                eyebrowColor: AppColors.accent1,
                center: true,
              ),
            ),
            const SizedBox(height: 16),
            AnimatedSection(
              delay: 0.05,
              child: Text(
                'Looking for a Flutter developer for your next project? I\'m open to remote roles, freelance contracts, and full-time positions.',
                textAlign: TextAlign.center,
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  color: isDark ? AppColors.darkMuted : AppColors.lightMuted,
                  height: 1.7,
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Form card
            AnimatedSection(
              delay: 0.1,
              child: HoverCard(
                padding: const EdgeInsets.all(36),
                borderColor: AppColors.accent1,
                glowColor: AppColors.accent1,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _Field(
                            ctrl: _nameCtrl,
                            label: 'Name',
                            hint: 'Your name',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _Field(
                            ctrl: _emailCtrl,
                            label: 'Email',
                            hint: 'your@email.com',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _Field(
                      ctrl: _msgCtrl,
                      label: 'Message',
                      hint: 'Tell me about your project...',
                      maxLines: 5,
                    ),
                    const SizedBox(height: 24),
                    _SubmitButton(sent: _sent, onTap: _submit),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Social links
            const AnimatedSection(
              delay: 0.2,
              child: Wrap(
                spacing: 16,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _SocialChip(
                    label: 'Email',
                    icon: '✉',
                    url: 'mailto:agboolaodunayo2016@gmail.com',
                    color: AppColors.accent1,
                  ),
                  _SocialChip(
                    label: 'LinkedIn',
                    icon: 'in',
                    url:
                        'https://www.linkedin.com/in/agboola-odunayo-1074a5257',
                    color: AppColors.accent2,
                  ),
                  _SocialChip(
                    label: 'GitHub',
                    icon: '</>',
                    url: 'https://github.com/Azag3077',
                    color: AppColors.accent3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatefulWidget {
  final TextEditingController ctrl;
  final String label;
  final String hint;
  final int maxLines;

  const _Field({
    required this.ctrl,
    required this.label,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: mutedColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (v) => setState(() => _focused = v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _focused ? AppColors.accent1 : borderColor,
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: widget.ctrl,
              maxLines: widget.maxLines,
              style: GoogleFonts.dmSans(fontSize: 15, color: textColor),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: GoogleFonts.dmSans(fontSize: 15, color: mutedColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatefulWidget {
  final bool sent;
  final VoidCallback onTap;

  const _SubmitButton({required this.sent, required this.onTap});

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: widget.sent ? AppColors.accent2 : AppColors.accent1,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent1.withValues(alpha: 0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          transform: _hovered
              ? Matrix4.translationValues(0, -2, 0)
              : Matrix4.identity(),
          child: Text(
            widget.sent ? '✓ Message Sent!' : 'Send Message →',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialChip extends StatefulWidget {
  final String label;
  final String icon;
  final String url;
  final Color color;

  const _SocialChip({
    required this.label,
    required this.icon,
    required this.url,
    required this.color,
  });

  @override
  State<_SocialChip> createState() => _SocialChipState();
}

class _SocialChipState extends State<_SocialChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final mutedColor = isDark ? AppColors.darkMuted : AppColors.lightMuted;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: _hovered ? widget.color : borderColor,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.icon,
                style: TextStyle(
                  color: _hovered ? widget.color : mutedColor,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _hovered ? widget.color : mutedColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
