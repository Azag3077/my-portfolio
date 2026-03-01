class AppProject {
  final String name;
  final String tagline;
  final String description;
  final List<String> tags;
  final String emoji;
  final List<AppLink> links;
  final List<AppStat> stats;
  final int colorIndex; // 0=accent1, 1=accent2, 2=green

  const AppProject({
    required this.name,
    required this.tagline,
    required this.description,
    required this.tags,
    required this.emoji,
    required this.links,
    required this.stats,
    required this.colorIndex,
  });
}

class AppLink {
  final String label;
  final String url;

  const AppLink(this.label, this.url);
}

class AppStat {
  final String label;
  final String value;

  const AppStat(this.label, this.value);
}

class SkillCategory {
  final String category;
  final List<String> items;
  final int colorIndex;

  const SkillCategory(this.category, this.items, this.colorIndex);
}

class ExperienceItem {
  final String role;
  final String company;
  final String period;
  final List<String> points;
  final int colorIndex;

  const ExperienceItem({
    required this.role,
    required this.company,
    required this.period,
    required this.points,
    required this.colorIndex,
  });
}

// ─── DATA ────────────────────────────────────────────────

const List<AppProject> projects = [
  AppProject(
    name: 'Fastchop',
    tagline: 'Food Delivery Ecosystem',
    description:
        'A full-scale food delivery platform with three cross-platform apps — Customer, Vendor, and Rider. Features live order tracking, restaurant discovery, loyalty points, and real-time delivery coordination.',
    tags: ['Flutter', 'Firebase', 'Maps', 'iOS & Android'],
    emoji: '🍔',
    colorIndex: 0,
    links: [
      AppLink(
        'Play Store (User)',
        'https://play.google.com/store/apps/details?id=com.fastchop.user',
      ),
      AppLink('App Store (User)', 'https://apps.apple.com/app/id6755609661'),
      AppLink(
        'Play Store (Vendor)',
        'https://play.google.com/store/apps/details?id=com.fastchop.vendor',
      ),
      AppLink(
        'Play Store (Rider)',
        'https://play.google.com/store/apps/details?id=com.fastchop.delivery',
      ),
    ],
    stats: [AppStat('Apps Built', '3'), AppStat('Platforms', 'iOS + Android')],
  ),
  AppProject(
    name: 'NaborGo',
    tagline: 'Community Services Marketplace',
    description:
        'A community-powered app connecting users with verified vendors, artisans, and helpful neighbours. Features real-time geolocation matching, in-app chat, biometric auth, and identity-verified providers.',
    tags: ['Flutter', 'Geolocation', 'Firebase Auth', 'Chat'],
    emoji: '🤝',
    colorIndex: 1,
    links: [
      AppLink(
        'Play Store',
        'https://play.google.com/store/apps/details?id=com.inchperfy.naborgo',
      ),
    ],
    stats: [AppStat('Rating', '4.6★'), AppStat('Category', 'Community')],
  ),
  AppProject(
    name: 'GreenMarket NG',
    tagline: 'Agricultural Marketplace',
    description:
        'A buy & sell platform for agro-products in Nigeria, connecting farmers directly with buyers. Users praise it for ease of use and reliability as a one-stop shop for farm shopping.',
    tags: ['Flutter', 'E-commerce', 'Firebase', 'Shopping'],
    emoji: '🌿',
    colorIndex: 2,
    links: [
      AppLink(
        'Play Store',
        'https://play.google.com/store/apps/details?id=com.zagytech.greenmarket.green_market',
      ),
    ],
    stats: [AppStat('Downloads', '500+'), AppStat('Rating', '4.8★')],
  ),
];

const List<SkillCategory> skills = [
  SkillCategory('Mobile', [
    'Flutter',
    'Dart',
    'iOS',
    'Android',
    'Kivy/KivyMD',
  ], 0),
  SkillCategory('State Management', ['Riverpod', 'Provider', 'BLoC'], 1),
  SkillCategory('Backend / BaaS', [
    'Firebase',
    'Firestore',
    'Flask',
    'REST APIs',
  ], 2),
  SkillCategory('Integrations', [
    'Google Maps',
    'Push Notifications',
    'Biometric Auth',
    'Payments',
  ], 0),
  SkillCategory('Python', ['BeautifulSoup', 'PyTesseract', 'Flask'], 1),
  SkillCategory('Tools', [
    'Git',
    'GitHub',
    'Postman',
    'VS Code',
    'Android Studio',
  ], 2),
];

const List<ExperienceItem> experiences = [
  ExperienceItem(
    role: 'Senior Flutter Developer',
    company: 'Freelance',
    period: '2020 – Present',
    colorIndex: 0,
    points: [
      'Delivered 3 production apps live on Play Store & App Store',
      'Built full food-delivery ecosystem (Fastchop) with 3 cross-platform apps',
      'Developed NaborGo community marketplace with real-time geolocation matching',
      'Converted React Native projects to Flutter, improving performance & UI',
    ],
  ),
  ExperienceItem(
    role: 'Flutter Developer',
    company: 'Zoliks Cleaning Service',
    period: 'Mar 2023 – Present',
    colorIndex: 1,
    points: [
      'Built desktop/tablet order management app used daily by 10–20 staff',
      'Implemented dynamic pricing engine for instant cost estimation',
      'Automated invoice generation, replacing manual paperwork',
      'Client confirmed measurable improvement in field operation speed',
    ],
  ),
  ExperienceItem(
    role: 'Python Developer',
    company: 'Freelance',
    period: '2021 – Present',
    colorIndex: 2,
    points: [
      'Built web scraping pipelines with BeautifulSoup for business intelligence',
      'Developed OCR tools with PyTesseract for ID & document verification',
      'Created Flask microservices to automate client workflows',
    ],
  ),
];

const List<Map<String, String>> heroStats = [
  {'value': '4+', 'label': 'Years Experience'},
  {'value': '3', 'label': 'Live Apps on Stores'},
  {'value': '500+', 'label': 'GreenMarket Downloads'},
  {'value': '4.8★', 'label': 'Top App Rating'},
];
