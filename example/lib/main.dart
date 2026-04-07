import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:internationalization/internationalization.dart';

// ---------------------------------------------------------------------------
// Supported locales
// ---------------------------------------------------------------------------
const _supportedLocales = [
  Locale('en'),
  Locale('pt'),
  Locale('es'),
];

// ---------------------------------------------------------------------------
// Locale notifier – drives runtime language switching
// ---------------------------------------------------------------------------
final _localeNotifier = ValueNotifier<Locale>(const Locale('en'));

void main() {
  runApp(const ShowcaseApp());
}

class ShowcaseApp extends StatelessWidget {
  const ShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: _localeNotifier,
      builder: (_, locale, __) {
        return MaterialApp(
          title: 'i18n Showcase',
          debugShowCheckedModeBanner: false,
          locale: locale,
          supportedLocales: _supportedLocales,
          localizationsDelegates: [
            InternationalizationDelegate(
              translationsPath: 'assets/translations/',
              suportedLocales: _supportedLocales,
              // Example: inject extra keys at runtime from any external source
              addTranslations: (locale) async {
                return {
                  'runtime_injected': '🚀 Injected at runtime for ${locale.languageCode}',
                };
              },
            ),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: _buildTheme(),
          home: const HomePage(),
        );
      },
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6C63FF),
        brightness: Brightness.dark,
      ),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      tabBarTheme: const TabBarThemeData(
        indicatorColor: Color(0xFF6C63FF),
        labelColor: Color(0xFF6C63FF),
        unselectedLabelColor: Colors.white54,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2A2A3D),
        selectedColor: const Color(0xFF6C63FF),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Home Page – tabbed showcase
// ---------------------------------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFF12121F),
        body: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              pinned: true,
              expandedHeight: 200,
              backgroundColor: const Color(0xFF12121F),
              flexibleSpace: FlexibleSpaceBar(
                background: _AppHeader(),
              ),
              bottom: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  Tab(text: context.translate('nav.basics')),
                  Tab(text: context.translate('nav.interpolation')),
                  Tab(text: context.translate('nav.plurals')),
                  Tab(text: context.translate('nav.formats')),
                ],
              ),
            ),
          ],
          body: const TabBarView(
            children: [
              BasicsTab(),
              InterpolationTab(),
              PluralsTab(),
              FormatsTab(),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// App header – language switcher + title
// ---------------------------------------------------------------------------
class _AppHeader extends StatelessWidget {
  final _langs = const [
    ('🇺🇸', 'en', 'English'),
    ('🇧🇷', 'pt', 'Português'),
    ('🇪🇸', 'es', 'Español'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1B4B), Color(0xFF12121F)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          TextIntl(
            'app.title',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          TextIntl(
            'app.subtitle',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 16),
          // Language switcher
          ValueListenableBuilder<Locale>(
            valueListenable: _localeNotifier,
            builder: (_, current, __) {
              return Row(
                children: _langs.map((lang) {
                  final isSelected = current.languageCode == lang.$2;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _LangChip(
                      flag: lang.$1,
                      label: lang.$3,
                      selected: isSelected,
                      onTap: () => _localeNotifier.value = Locale(lang.$2),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String flag;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LangChip({
    required this.flag,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xFF6C63FF)
            : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected
              ? const Color(0xFF6C63FF)
              : Colors.white.withValues(alpha: 0.15),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(flag, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 1: Basics
// ---------------------------------------------------------------------------
class BasicsTab extends StatelessWidget {
  const BasicsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // --- Simple string via context extension ---
        _SectionCard(
          icon: Icons.text_fields_rounded,
          title: context.translate('section.context_ext'),
          color: const Color(0xFF6C63FF),
          child: _ResultRow(
            label: 'context.translate("greeting")',
            value: context.translate('greeting'),
          ),
        ),
        const SizedBox(height: 12),

        // --- String extension ---
        _SectionCard(
          icon: Icons.extension_rounded,
          title: context.translate('section.string_ext'),
          color: const Color(0xFF43C6AC),
          child: _ResultRow(
            label: '"welcome".translate(context)',
            value: 'welcome'.translate(context),
          ),
        ),
        const SizedBox(height: 12),

        // --- TextIntl widget ---
        _SectionCard(
          icon: Icons.widgets_rounded,
          title: context.translate('section.text_intl'),
          color: const Color(0xFFF7971E),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CodeSnippet("TextIntl('description')"),
              const SizedBox(height: 8),
              TextIntl(
                'description',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // --- Nested keys via dot notation ---
        _SectionCard(
          icon: Icons.account_tree_rounded,
          title: context.translate('section.nested'),
          color: const Color(0xFFEC407A),
          child: Column(
            children: [
              _ResultRow(
                label: 'context.translate("basics.simple")',
                value: context.translate('basics.simple'),
              ),
              const SizedBox(height: 8),
              _ResultRow(
                label: 'context.translate("basics.nested_key")',
                value: context.translate('basics.nested_key'),
              ),
              const SizedBox(height: 8),
              _ResultRow(
                label: 'parent: ["basics"], key: "simple"',
                value: context.translate('simple', parent: ['basics']),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // --- Runtime injected ---
        _SectionCard(
          icon: Icons.cloud_download_rounded,
          title: 'Runtime Injected (addTranslations)',
          color: const Color(0xFF00B4D8),
          child: _ResultRow(
            label: 'context.translate("runtime_injected")',
            value: context.translate('runtime_injected'),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 2: Interpolation
// ---------------------------------------------------------------------------
class InterpolationTab extends StatelessWidget {
  const InterpolationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Positional args
        _SectionCard(
          icon: Icons.format_list_numbered_rounded,
          title: context.translate('section.args'),
          color: const Color(0xFF6C63FF),
          child: Column(
            children: [
              const _CodeSnippet(
                'context.translate("interpolation.positional",\n  args: ["Alice", "5"])',
              ),
              const SizedBox(height: 10),
              _ResultRow(
                label: 'Result',
                value: context.translate(
                  'interpolation.positional',
                  args: ['Alice', '5'],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Named args
        _SectionCard(
          icon: Icons.label_rounded,
          title: context.translate('section.named_args'),
          color: const Color(0xFF43C6AC),
          child: Column(
            children: [
              const _CodeSnippet(
                'context.translate("interpolation.named",\n  namedArgs: {"firstName": "John", "lastName": "Doe"})',
              ),
              const SizedBox(height: 10),
              _ResultRow(
                label: 'Result',
                value: context.translate(
                  'interpolation.named',
                  namedArgs: {'firstName': 'John', 'lastName': 'Doe'},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Combined
        _SectionCard(
          icon: Icons.merge_type_rounded,
          title: 'Combined (args + namedArgs)',
          color: const Color(0xFFF7971E),
          child: Column(
            children: [
              const _CodeSnippet(
                'context.translate("interpolation.combined",\n  args: ["42"],\n  namedArgs: {"name": "Maria"})',
              ),
              const SizedBox(height: 10),
              _ResultRow(
                label: 'Result',
                value: context.translate(
                  'interpolation.combined',
                  args: ['42'],
                  namedArgs: {'name': 'Maria'},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // TextIntl with named args
        _SectionCard(
          icon: Icons.widgets_rounded,
          title: 'TextIntl + namedArgs',
          color: const Color(0xFFEC407A),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CodeSnippet(
                "TextIntl('interpolation.named',\n  namedArgs: {'firstName': 'Ana', 'lastName': 'Silva'})",
              ),
              const SizedBox(height: 10),
              TextIntl(
                'interpolation.named',
                namedArgs: const {'firstName': 'Ana', 'lastName': 'Silva'},
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 3: Plurals
// ---------------------------------------------------------------------------
class PluralsTab extends StatefulWidget {
  const PluralsTab({super.key});

  @override
  State<PluralsTab> createState() => _PluralsTabState();
}

class _PluralsTabState extends State<PluralsTab> {
  int _itemCount = 0;
  int _downloadCount = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Item count plural
        _SectionCard(
          icon: Icons.shopping_cart_rounded,
          title: context.translate('section.count'),
          color: const Color(0xFF6C63FF),
          child: Column(
            children: [
              _ResultRow(
                label: 'pluralValue: $_itemCount',
                value: context.translate(
                  'plurals.items',
                  pluralValue: _itemCount,
                  args: ['$_itemCount'],
                ),
              ),
              const SizedBox(height: 16),
              _CounterRow(
                value: _itemCount,
                onDecrement: () {
                  if (_itemCount > 0) setState(() => _itemCount--);
                },
                onIncrement: () => setState(() => _itemCount++),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Downloads plural with named args
        _SectionCard(
          icon: Icons.download_rounded,
          title: context.translate('section.download'),
          color: const Color(0xFF43C6AC),
          child: Column(
            children: [
              _ResultRow(
                label: 'pluralValue: $_downloadCount',
                value: context.translate(
                  'plurals.downloads',
                  pluralValue: _downloadCount,
                  args: ['$_downloadCount'],
                  namedArgs: {'file': 'report.pdf'},
                ),
              ),
              const SizedBox(height: 16),
              _CounterRow(
                value: _downloadCount,
                onDecrement: () {
                  if (_downloadCount > 0) setState(() => _downloadCount--);
                },
                onIncrement: () => setState(() => _downloadCount++),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Plural reference table
        _SectionCard(
          icon: Icons.table_chart_rounded,
          title: 'Plural Rules Reference',
          color: const Color(0xFFF7971E),
          child: Column(
            children: [
              for (final val in [0, 1, 3])
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: _ResultRow(
                    label: 'items (pluralValue: $val)',
                    value: context.translate(
                      'plurals.items',
                      pluralValue: val,
                      args: ['$val'],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CounterRow extends StatelessWidget {
  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _CounterRow({
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _IconBtn(icon: Icons.remove, onTap: onDecrement),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: Text(
            '$value',
            key: ValueKey(value),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        _IconBtn(icon: Icons.add, onTap: onIncrement),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: const Color(0xFF6C63FF), size: 20),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 4: Formats (NumberFormat + DateFormat from intl)
// ---------------------------------------------------------------------------
class FormatsTab extends StatelessWidget {
  const FormatsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final amount = 1234567.89;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Currency
        _SectionCard(
          icon: Icons.attach_money_rounded,
          title: context.translate('formats.currency_label'),
          color: const Color(0xFF6C63FF),
          child: Column(
            children: [
              _ResultRow(
                label: "NumberFormat.currency(locale: 'en_US')",
                value: NumberFormat.currency(locale: 'en_US', symbol: '\$')
                    .format(amount),
              ),
              const SizedBox(height: 8),
              _ResultRow(
                label: "NumberFormat.currency(locale: 'pt_BR')",
                value: NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                    .format(amount),
              ),
              const SizedBox(height: 8),
              _ResultRow(
                label: "NumberFormat.currency(locale: 'es_ES')",
                value: NumberFormat.currency(locale: 'es_ES', symbol: '€')
                    .format(amount),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Date
        _SectionCard(
          icon: Icons.calendar_today_rounded,
          title: context.translate('formats.date_label'),
          color: const Color(0xFF43C6AC),
          child: Column(
            children: [
              _ResultRow(
                label: "DateFormat.yMMMMd('en')",
                value: DateFormat.yMMMMd('en').format(now),
              ),
              const SizedBox(height: 8),
              _ResultRow(
                label: "DateFormat.yMMMMd('pt')",
                value: DateFormat.yMMMMd('pt').format(now),
              ),
              const SizedBox(height: 8),
              _ResultRow(
                label: "DateFormat('EEEE, MMM d yyyy', 'es')",
                value: DateFormat('EEEE, MMM d yyyy', 'es').format(now),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Large numbers
        _SectionCard(
          icon: Icons.bar_chart_rounded,
          title: context.translate('formats.number_label'),
          color: const Color(0xFFF7971E),
          child: Column(
            children: [
              _ResultRow(
                label: 'NumberFormat.compact()',
                value: NumberFormat.compact().format(1234567890),
              ),
              const SizedBox(height: 8),
              _ResultRow(
                label: 'NumberFormat.decimalPattern()',
                value: NumberFormat.decimalPattern().format(9876543.21),
              ),
              const SizedBox(height: 8),
              _ResultRow(
                label: 'NumberFormat.percentPattern()',
                value: NumberFormat.percentPattern().format(0.7654),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable UI components
// ---------------------------------------------------------------------------
class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget child;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;

  const _ResultRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 11,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _CodeSnippet extends StatelessWidget {
  final String code;

  const _CodeSnippet(this.code);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        code,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 11.5,
          color: Color(0xFF89DDFF),
          height: 1.6,
        ),
      ),
    );
  }
}
