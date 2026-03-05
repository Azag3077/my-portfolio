import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/breakpoints.dart';
import '../constants/environment.dart';
import '../extensions/extensions.dart';
import '../theme/theme.dart';
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
  bool _valid = false;
  bool _sending = false;

  @override
  void initState() {
    super.initState();

    _nameCtrl.addListener(_validate);
    _emailCtrl.addListener(_validate);
    _msgCtrl.addListener(_validate);
  }

  @override
  void dispose() {
    _nameCtrl.removeListener(_validate);
    _emailCtrl.removeListener(_validate);
    _msgCtrl.removeListener(_validate);
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  void _validate() {
    final email = _emailCtrl.text.trim();
    final message = _msgCtrl.text.trim();
    final valid = email.isEmail && message.isNotEmpty;

    setState(() => _valid = valid);
  }

  Future<void> _submit() async {
    if (!_valid) return;

    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final message = _msgCtrl.text.trim();

    try {
      setState(() => _sending = true);
      final response = await sendRequest(
        name: name.isEmpty ? 'Anonymous' : name,
        email: email,
        message: message,
      );

      if (response.statusCode == 200) {
        _nameCtrl.clear();
        _emailCtrl.clear();
        _msgCtrl.clear();

        setState(() => _sent = true);
        await Future.delayed(const Duration(seconds: 4));

        if (mounted) {
          setState(() => _sent = false);
        }
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() => _sending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: BreakPoint.mobile),
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
            16.0.verticalSpace,

            AnimatedSection(
              delay: 0.05,
              child: Text(
                'Looking for a Flutter developer for your next project? '
                'I\'m open to remote roles, freelance contracts, '
                'and full-time positions.',
                textAlign: .center,
                style: GoogleFonts.dmSans(
                  fontSize: 16.0.sp,
                  color: AppColors.of(context).muted,
                  height: 1.7,
                ),
              ),
            ),
            48.0.verticalSpace,

            // Form card
            AnimatedSection(
              delay: 0.1,
              child: HoverCard(
                padding: .all(36.0.r),
                borderColor: AppColors.accent1,
                glowColor: AppColors.accent1,
                child: Column(
                  children: <Widget>[
                    Row(
                      spacing: 16.0.w,
                      children: <Widget>[
                        Expanded(
                          child: _Field(
                            ctrl: _nameCtrl,
                            label: 'Name',
                            hint: 'Your name',
                            keyboardType: .name,
                            isOptional: true,
                          ),
                        ),
                        Expanded(
                          child: _Field(
                            ctrl: _emailCtrl,
                            label: 'Email',
                            hint: 'your@email.com',
                            keyboardType: .emailAddress,
                          ),
                        ),
                      ],
                    ),
                    16.0.verticalSpace,
                    _Field(
                      ctrl: _msgCtrl,
                      label: 'Message',
                      hint: 'Tell me about your project...',
                      maxLines: 5,
                    ),
                    24.0.verticalSpace,
                    _SubmitButton(
                      sent: _sent,
                      valid: _valid,
                      sending: _sending,
                      onTap: _submit,
                    ),
                  ],
                ),
              ),
            ),
            40.0.verticalSpace,

            // Social links
            AnimatedSection(
              delay: 0.2,
              child: Wrap(
                spacing: 16.0.w,
                runSpacing: 12.0.h,
                alignment: .center,
                children: const <Widget>[
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
  const _Field({
    required this.ctrl,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.isOptional = false,
    this.keyboardType,
  });

  final TextEditingController ctrl;
  final String label;
  final String hint;
  final int maxLines;
  final bool isOptional;
  final TextInputType? keyboardType;

  @override
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: <Widget>[
        Row(
          spacing: 8.0.w,
          children: <Widget>[
            Text(
              widget.label,
              style: GoogleFonts.dmSans(
                fontSize: 13.0.sp,
                fontWeight: .w500,
                color: AppColors.of(context).muted,
              ),
            ),

            if (widget.isOptional)
              Text(
                '(Optional)',
                style: GoogleFonts.dmSans(
                  fontSize: 12.0.sp,
                  fontWeight: .w500,
                  color: AppColors.of(context).muted.withValues(alpha: .7),
                ),
              ),
          ],
        ),
        8.0.verticalSpace,
        Focus(
          onFocusChange: (v) => setState(() => _focused = v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: AppColors.of(context).card,
              borderRadius: BorderRadius.circular(12.0.r),
              border: Border.all(
                color: _focused
                    ? AppColors.accent1
                    : AppColors.of(context).border,
                width: 1.5.r,
              ),
            ),
            child: TextFormField(
              controller: widget.ctrl,
              maxLines: widget.maxLines,
              keyboardType: widget.keyboardType,
              style: GoogleFonts.dmSans(
                fontSize: 15.0.sp,
                color: AppColors.of(context).text,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: GoogleFonts.dmSans(
                  fontSize: 15.0.sp,
                  color: AppColors.of(context).muted,
                ),
                border: .none,
                contentPadding: .symmetric(
                  horizontal: 16.0.w,
                  vertical: 14.0.h,
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
  const _SubmitButton({
    required this.sent,
    required this.valid,
    required this.sending,
    required this.onTap,
  });

  final bool sent;
  final bool valid;
  final bool sending;
  final VoidCallback onTap;

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.sending || !widget.valid;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: disabled || widget.sent ? null : widget.onTap,
        child: AnimatedContainer(
          width: .infinity,
          padding: .symmetric(vertical: 16.0.w),
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: disabled
                ? Theme.of(context).disabledColor
                : widget.sent
                ? AppColors.accent2
                : AppColors.accent1,
            borderRadius: .circular(12.0.r),
            boxShadow: <BoxShadow>[
              if (_hovered && !disabled)
                BoxShadow(
                  color: AppColors.accent1.withValues(alpha: 0.4),
                  blurRadius: 30.0.r,
                  offset: Offset(0, 8.0.h),
                ),
            ],
          ),
          transform: _hovered
              ? Matrix4.translationValues(0, -2, 0)
              : Matrix4.identity(),
          child: Text(
            widget.sent
                ? '✓ Message Sent!'
                : widget.sending
                ? 'Sending Message...'
                : 'Send Message →',
            textAlign: .center,
            style: GoogleFonts.dmSans(
              fontSize: 16.0.sp,
              fontWeight: .w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialChip extends StatefulWidget {
  const _SocialChip({
    required this.label,
    required this.icon,
    required this.url,
    required this.color,
  });

  final String label;
  final String icon;
  final String url;
  final Color color;

  @override
  State<_SocialChip> createState() => _SocialChipState();
}

class _SocialChipState extends State<_SocialChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: .symmetric(horizontal: 20.0.w, vertical: 10.0.h),
          decoration: BoxDecoration(
            color: AppColors.of(context).card,
            borderRadius: BorderRadius.circular(50.0.r),
            border: Border.all(
              color: _hovered ? widget.color : AppColors.of(context).border,
              width: 1.5.r,
            ),
          ),
          child: Row(
            mainAxisSize: .min,
            children: <Widget>[
              Text(
                widget.icon,
                style: TextStyle(
                  color: _hovered ? widget.color : AppColors.of(context).muted,
                  fontSize: 15.0.sp,
                ),
              ),
              8.0.verticalSpace,
              Text(
                widget.label,
                style: GoogleFonts.dmSans(
                  fontSize: 14.0.sp,
                  fontWeight: .w600,
                  color: _hovered ? widget.color : AppColors.of(context).muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<http.Response> sendRequest({
  required String name,
  required String email,
  required String message,
}) async {
  const emailUrl = String.fromEnvironment(Environment.emailUrl);
  const serviceId = String.fromEnvironment(Environment.serviceId);
  const templateId = String.fromEnvironment(Environment.templateId);
  const publicKey = String.fromEnvironment(Environment.publicKey);

  return await http.post(
    Uri.parse('$emailUrl/api/v1.0/email/send'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': publicKey,
      'template_params': {
        'name': name,
        'email': email,
        'message': message,
        'time': DateFormat('MMM dd, yyyy – hh:mm a').format(DateTime.now()),
      },
    }),
  );
}
