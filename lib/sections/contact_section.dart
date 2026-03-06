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
import '../widgets/widgets.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class ContactSectionViewModel {
  const ContactSectionViewModel({
    this.sent = false,
    this.valid = false,
    this.sending = false,
  });

  final bool sent;
  final bool valid;
  final bool sending;

  ContactSectionViewModel copyWith({bool? sent, bool? valid, bool? sending}) {
    return ContactSectionViewModel(
      sent: sent ?? this.sent,
      valid: valid ?? this.valid,
      sending: sending ?? this.sending,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactSectionViewModel &&
        other.sent == sent &&
        other.valid == valid &&
        other.sending == sending;
  }

  @override
  int get hashCode => sent.hashCode ^ valid.hashCode ^ sending.hashCode;
}

class _ContactSectionState extends State<ContactSection> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  final _vmVN = ValueNotifier(const ContactSectionViewModel());

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
    _vmVN.dispose();
    super.dispose();
  }

  void _validate() {
    final email = _emailCtrl.text.trim();
    final message = _msgCtrl.text.trim();
    final valid = email.isEmail && message.isNotEmpty;

    _vmVN.value = _vmVN.value.copyWith(valid: valid);
  }

  Future<void> _submit() async {
    if (!_vmVN.value.valid) return;

    final name = _nameCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final message = _msgCtrl.text.trim();

    try {
      _vmVN.value = _vmVN.value.copyWith(sending: true);
      final response = await sendRequest(
        name: name.isEmpty ? 'Anonymous' : name,
        email: email,
        message: message,
      );

      if (response.statusCode == 200) {
        _nameCtrl.clear();
        _emailCtrl.clear();
        _msgCtrl.clear();

        if (!mounted) return;
        _vmVN.value = _vmVN.value.copyWith(sent: true);
        showSnackBar(context, message: 'Message sent successfully!');

        await Future.delayed(const Duration(seconds: 4));
        if (!mounted) return;
        _vmVN.value = _vmVN.value.copyWith(sent: false);
      } else {
        if (!mounted) return;
        showSnackBar(
          context,
          message: 'Failed to send message. Please try again.',
          isError: true,
        );
      }
    } catch (_) {
      if (!mounted) return;
      showSnackBar(
        context,
        message: 'Failed to send message. Please try again.',
        isError: true,
      );
    } finally {
      if (mounted) {
        _vmVN.value = _vmVN.value.copyWith(sending: false);
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
                            textInputAction: .next,
                            textCapitalization: .words,
                            autofillHints: const [AutofillHints.name],
                            isOptional: true,
                          ),
                        ),
                        Expanded(
                          child: _Field(
                            ctrl: _emailCtrl,
                            label: 'Email',
                            hint: 'your@email.com',
                            textInputAction: .next,
                            keyboardType: .emailAddress,
                            autofillHints: const [AutofillHints.email],
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
                      textCapitalization: .sentences,
                    ),
                    24.0.verticalSpace,
                    ValueListenableBuilder<ContactSectionViewModel>(
                      valueListenable: _vmVN,
                      builder: (context, value, _) {
                        return _SubmitButton(
                          sent: value.sent,
                          valid: value.valid,
                          sending: value.sending,
                          onTap: _submit,
                        );
                      },
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
    this.autofillHints,
    this.textInputAction,
    this.textCapitalization = .none,
  });

  final TextEditingController ctrl;
  final String label;
  final String hint;
  final int maxLines;
  final bool isOptional;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;

  @override
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
  final _focusedVN = ValueNotifier(false);

  @override
  void dispose() {
    _focusedVN.dispose();
    super.dispose();
  }

  void _onFocusChange(bool value) => _focusedVN.value = value;

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
          onFocusChange: _onFocusChange,
          child: ValueListenableBuilder<bool>(
            valueListenable: _focusedVN,
            builder: (context, focused, _) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: AppColors.of(context).card,
                  borderRadius: .circular(12.0.r),
                  border: .all(
                    width: 1.5.r,
                    color: focused
                        ? AppColors.accent1
                        : AppColors.of(context).border,
                  ),
                ),
                child: TextFormField(
                  controller: widget.ctrl,
                  maxLines: widget.maxLines,
                  keyboardType: widget.keyboardType,
                  autofillHints: widget.autofillHints,
                  textCapitalization: widget.textCapitalization,
                  textInputAction: widget.textInputAction,
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
                    contentPadding: .symmetric(
                      horizontal: 16.0.w,
                      vertical: 14.0.h,
                    ),
                    border: .none,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final disabled = sending || !valid;

    return GestureDetector(
      onTap: disabled || sent ? null : onTap,
      child: MouseRegionBuilder(
        builder: (context, hovered) {
          return AnimatedContainer(
            width: .infinity,
            padding: .symmetric(vertical: 16.0.w),
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: disabled
                  ? Theme.of(context).disabledColor
                  : sent
                  ? AppColors.accent2
                  : AppColors.accent1,
              borderRadius: .circular(12.0.r),
              boxShadow: <BoxShadow>[
                if (hovered && !disabled)
                  BoxShadow(
                    color: AppColors.accent1.withValues(alpha: 0.4),
                    blurRadius: 30.0.r,
                    offset: Offset(0, 8.0.h),
                  ),
              ],
            ),
            transform: hovered
                ? Matrix4.translationValues(0, -2, 0)
                : Matrix4.identity(),
            child: Text(
              sent
                  ? '✓ Message Sent!'
                  : sending
                  ? 'Sending Message...'
                  : 'Send Message →',
              textAlign: .center,
              style: GoogleFonts.dmSans(
                fontSize: 16.0.sp,
                fontWeight: .w700,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SocialChip extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: MouseRegionBuilder(
        builder: (context, hovered) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: .symmetric(horizontal: 20.0.w, vertical: 10.0.h),
            decoration: BoxDecoration(
              color: AppColors.of(context).card,
              borderRadius: .circular(50.0.r),
              border: Border.all(
                color: hovered ? color : AppColors.of(context).border,
                width: 1.5.r,
              ),
            ),
            child: Row(
              mainAxisSize: .min,
              children: <Widget>[
                Text(
                  icon,
                  style: TextStyle(
                    color: hovered ? color : AppColors.of(context).muted,
                    fontSize: 15.0.sp,
                  ),
                ),
                8.0.verticalSpace,
                Text(
                  label,
                  style: GoogleFonts.dmSans(
                    fontSize: 14.0.sp,
                    fontWeight: .w600,
                    color: hovered ? color : AppColors.of(context).muted,
                  ),
                ),
              ],
            ),
          );
        },
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
  const userId = String.fromEnvironment(Environment.userId);

  return await http.post(
    Uri.parse('$emailUrl/api/v1.0/email/send'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'name': name,
        'email': email,
        'message': message,
        'time': DateFormat('MMM dd, yyyy – hh:mm a').format(DateTime.now()),
      },
    }),
  );
}

void showSnackBar(
  BuildContext context, {
  required String message,
  bool isError = false,
}) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: .symmetric(horizontal: 20..w, vertical: 14.0.r),
            constraints: BoxConstraints(maxWidth: 420.0.w),
            decoration: BoxDecoration(
              color: isError
                  ? const Color(0xffef4444)
                  : const Color(0xff22c55e),
              borderRadius: .circular(14.0.r),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 20.0.r,
                  color: Colors.black.withValues(alpha: .15),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: .min,
              children: <Widget>[
                Icon(
                  isError ? Icons.error_outline : Icons.check_circle_outline,
                  color: Colors.white,
                ),
                SizedBox(width: 12.0.w),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: .w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);

  Future.delayed(const Duration(seconds: 3), () {
    entry.remove();
  });
}
