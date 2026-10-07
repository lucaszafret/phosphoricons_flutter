import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phosphor Icons Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9D79FF)),
        useMaterial3: true,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatelessWidget {
  const ExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(children: [
            PhosphorIcon(PhosphorIcons.shapes, size: 24),
            SizedBox(width: 8),
            Text('Phosphor Icons'),
          ]),
          bottom: const TabBar(
            tabs: [
              Tab(text: '6 Styles'),
              Tab(text: 'Duotone'),
              Tab(text: 'Shadows'),
              Tab(text: 'Shortcuts'),
            ],
          ),
        ),
        body: const TabBarView(
          // The styles table scrolls sideways on small screens, so disable
          // swiping between tabs to avoid fighting with it.
          physics: NeverScrollableScrollPhysics(),
          children: [
            _StylesTab(),
            _DuotoneTab(),
            _ShadowsTab(),
            _ShortcutsTab(),
          ],
        ),
      ),
    );
  }
}

// ── Tab: 6 estilos ─────────────────────────────────────────────────────────────

class _StylesTab extends StatelessWidget {
  const _StylesTab();

  static const _icons = <(
    String,
    IconData,
    IconData,
    IconData,
    IconData,
    IconData,
    PhosphorDuotoneIconData
  )>[
    (
      'storefront',
      PhosphorIconsThin.storefront,
      PhosphorIconsLight.storefront,
      PhosphorIconsRegular.storefront,
      PhosphorIconsBold.storefront,
      PhosphorIconsFill.storefront,
      PhosphorIconsDuotone.storefront
    ),
    (
      'heart',
      PhosphorIconsThin.heart,
      PhosphorIconsLight.heart,
      PhosphorIconsRegular.heart,
      PhosphorIconsBold.heart,
      PhosphorIconsFill.heart,
      PhosphorIconsDuotone.heart
    ),
    (
      'rocketLaunch',
      PhosphorIconsThin.rocketLaunch,
      PhosphorIconsLight.rocketLaunch,
      PhosphorIconsRegular.rocketLaunch,
      PhosphorIconsBold.rocketLaunch,
      PhosphorIconsFill.rocketLaunch,
      PhosphorIconsDuotone.rocketLaunch
    ),
    (
      'star',
      PhosphorIconsThin.star,
      PhosphorIconsLight.star,
      PhosphorIconsRegular.star,
      PhosphorIconsBold.star,
      PhosphorIconsFill.star,
      PhosphorIconsDuotone.star
    ),
    (
      'gear',
      PhosphorIconsThin.gear,
      PhosphorIconsLight.gear,
      PhosphorIconsRegular.gear,
      PhosphorIconsBold.gear,
      PhosphorIconsFill.gear,
      PhosphorIconsDuotone.gear
    ),
    (
      'bell',
      PhosphorIconsThin.bell,
      PhosphorIconsLight.bell,
      PhosphorIconsRegular.bell,
      PhosphorIconsBold.bell,
      PhosphorIconsFill.bell,
      PhosphorIconsDuotone.bell
    ),
    (
      'envelope',
      PhosphorIconsThin.envelope,
      PhosphorIconsLight.envelope,
      PhosphorIconsRegular.envelope,
      PhosphorIconsBold.envelope,
      PhosphorIconsFill.envelope,
      PhosphorIconsDuotone.envelope
    ),
    (
      'shoppingCart',
      PhosphorIconsThin.shoppingCart,
      PhosphorIconsLight.shoppingCart,
      PhosphorIconsRegular.shoppingCart,
      PhosphorIconsBold.shoppingCart,
      PhosphorIconsFill.shoppingCart,
      PhosphorIconsDuotone.shoppingCart
    ),
  ];

  static const _styles = [
    'Thin',
    'Light',
    'Regular',
    'Bold',
    'Fill',
    'Duotone'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        // Header row
        Row(children: [
          const SizedBox(width: 110),
          for (final s in _styles)
            Expanded(
                child: Text(s,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600))),
        ]),
        const Divider(height: 16),
        for (final entry in _icons)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(children: [
              SizedBox(
                  width: 110,
                  child: Text(entry.$1, style: const TextStyle(fontSize: 12))),
              Expanded(child: Icon(entry.$2, size: 28)),
              Expanded(child: Icon(entry.$3, size: 28)),
              Expanded(child: Icon(entry.$4, size: 28)),
              Expanded(child: Icon(entry.$5, size: 28)),
              Expanded(child: Icon(entry.$6, size: 28)),
              Expanded(
                  child: PhosphorIcon(entry.$7,
                      size: 28,
                      duotoneSecondaryOpacity: 0.25,
                      color: const Color(0xFF9D79FF))),
            ]),
          ),
      ]),
    );
  }
}

// ── Tab: Duotone ──────────────────────────────────────────────────────────────

class _DuotoneTab extends StatefulWidget {
  const _DuotoneTab();

  @override
  State<_DuotoneTab> createState() => _DuotoneTabState();
}

class _DuotoneTabState extends State<_DuotoneTab> {
  double _opacity = 0.25;

  static const _duotones = <(PhosphorDuotoneIconData, Color, String)>[
    (PhosphorIconsDuotone.storefront, Color(0xFF9D79FF), 'storefront'),
    (PhosphorIconsDuotone.heart, Color(0xFFEF4444), 'heart'),
    (PhosphorIconsDuotone.rocketLaunch, Color(0xFF8B5CF6), 'rocketLaunch'),
    (PhosphorIconsDuotone.star, Color(0xFFF59E0B), 'star'),
    (PhosphorIconsDuotone.lightning, Color(0xFFFBBF24), 'lightning'),
    (PhosphorIconsDuotone.leaf, Color(0xFF10B981), 'leaf'),
    (PhosphorIconsDuotone.diamond, Color(0xFF3B82F6), 'diamond'),
    (PhosphorIconsDuotone.crown, Color(0xFFF97316), 'crown'),
    (PhosphorIconsDuotone.fire, Color(0xFFEF4444), 'fire'),
    (PhosphorIconsDuotone.globe, Color(0xFF06B6D4), 'globe'),
    (PhosphorIconsDuotone.moon, Color(0xFF818CF8), 'moon'),
    (PhosphorIconsDuotone.sparkle, Color(0xFFA78BFA), 'sparkle'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          const Text('Secondary opacity:'),
          Expanded(
              child: Slider(
                  value: _opacity,
                  min: 0.05,
                  max: 0.6,
                  onChanged: (v) => setState(() => _opacity = v))),
          Text(_opacity.toStringAsFixed(2)),
        ]),
      ),
      Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 120,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: _duotones.length,
          itemBuilder: (context, i) {
            final (icon, color, name) = _duotones[i];
            return Card(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PhosphorIcon(icon,
                        size: 48,
                        color: color,
                        duotoneSecondaryOpacity: _opacity),
                    const SizedBox(height: 6),
                    Text(name,
                        style: const TextStyle(fontSize: 10),
                        textAlign: TextAlign.center),
                  ]),
            );
          },
        ),
      ),
    ]);
  }
}

// ── Tab: Shadows ──────────────────────────────────────────────────────────────

class _ShadowsTab extends StatefulWidget {
  const _ShadowsTab();

  @override
  State<_ShadowsTab> createState() => _ShadowsTabState();
}

class _ShadowsTabState extends State<_ShadowsTab> {
  double _blur = 6;
  double _offsetY = 4;

  @override
  Widget build(BuildContext context) {
    final shadows = [
      Shadow(
          color: Colors.black38,
          blurRadius: _blur,
          offset: Offset(0, _offsetY)),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('PhosphorIcon(..., shadows: [...])',
            style: TextStyle(fontFamily: 'monospace', fontSize: 13)),
        const SizedBox(height: 4),
        const Text(
          'Works with every style. In Duotone the shadows are applied to both layers.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        _slider('Blur', _blur, 0, 16, (v) => setState(() => _blur = v)),
        _slider(
            'Offset Y', _offsetY, -8, 12, (v) => setState(() => _offsetY = v)),
        const SizedBox(height: 16),
        Wrap(spacing: 24, runSpacing: 24, children: [
          _ShadowItem(
              label: 'Regular',
              child: PhosphorIcon(PhosphorIconsRegular.heart,
                  size: 56, color: Colors.red, shadows: shadows)),
          _ShadowItem(
              label: 'Bold',
              child: PhosphorIcon(PhosphorIconsBold.heart,
                  size: 56, color: Colors.red, shadows: shadows)),
          _ShadowItem(
              label: 'Fill',
              child: PhosphorIcon(PhosphorIconsFill.heart,
                  size: 56, color: Colors.red, shadows: shadows)),
          _ShadowItem(
              label: 'Duotone',
              child: PhosphorIcon(PhosphorIconsDuotone.heart,
                  size: 56, color: Colors.red, shadows: shadows)),
          _ShadowItem(
              label: 'Fill (star)',
              child: PhosphorIcon(PhosphorIconsFill.star,
                  size: 56, color: Colors.amber, shadows: shadows)),
          _ShadowItem(
              label: 'Duotone (rocket)',
              child: PhosphorIcon(PhosphorIconsDuotone.rocketLaunch,
                  size: 56, color: const Color(0xFF8B5CF6), shadows: shadows)),
        ]),
      ]),
    );
  }

  Widget _slider(String label, double value, double min, double max,
      ValueChanged<double> onChanged) {
    return Row(children: [
      SizedBox(width: 70, child: Text(label)),
      Expanded(
          child:
              Slider(value: value, min: min, max: max, onChanged: onChanged)),
      SizedBox(width: 40, child: Text(value.toStringAsFixed(1))),
    ]);
  }
}

class _ShadowItem extends StatelessWidget {
  final String label;
  final Widget child;
  const _ShadowItem({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      child,
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(fontSize: 11)),
    ]);
  }
}

// ── Tab: Shortcuts ─────────────────────────────────────────────────────────────

class _ShortcutsTab extends StatelessWidget {
  const _ShortcutsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('PhosphorIcons — shortcut class',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 4),
        const Text('Access all styles via a single class with name suffixes.',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 16),
        _code('Icon(PhosphorIcons.storefront)       // Regular'),
        _code('Icon(PhosphorIcons.storefrontBold)   // Bold'),
        _code('Icon(PhosphorIcons.storefrontFill)   // Fill'),
        _code('Icon(PhosphorIcons.storefrontThin)   // Thin'),
        _code('Icon(PhosphorIcons.storefrontLight)  // Light'),
        _code('PhosphorIcon(PhosphorIcons.storefrontDuotone)  // Duotone'),
        const SizedBox(height: 20),
        Wrap(spacing: 16, runSpacing: 16, children: const [
          _IconItem(icon: PhosphorIcons.storefront, label: '.storefront'),
          _IconItem(
              icon: PhosphorIcons.storefrontBold, label: '.storefrontBold'),
          _IconItem(
              icon: PhosphorIcons.storefrontFill, label: '.storefrontFill'),
          _IconItem(
              icon: PhosphorIcons.storefrontThin, label: '.storefrontThin'),
          _IconItem(icon: PhosphorIcons.house, label: '.house'),
          _IconItem(icon: PhosphorIcons.houseBold, label: '.houseBold'),
          _IconItem(icon: PhosphorIcons.houseFill, label: '.houseFill'),
          _IconItem(icon: PhosphorIcons.alarm, label: '.alarm'),
          _IconItem(icon: PhosphorIcons.alarmBold, label: '.alarmBold'),
          _IconItem(icon: PhosphorIcons.alarmFill, label: '.alarmFill'),
          _IconItem(
              icon: PhosphorIcons.star, label: '.star', color: Colors.amber),
          _IconItem(
              icon: PhosphorIcons.starFill,
              label: '.starFill',
              color: Colors.amber),
          _IconItem(
              icon: PhosphorIcons.heart, label: '.heart', color: Colors.red),
          _IconItem(
              icon: PhosphorIcons.heartFill,
              label: '.heartFill',
              color: Colors.red),
        ]),
      ]),
    );
  }

  Widget _code(String text) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.black12, borderRadius: BorderRadius.circular(6)),
      child: Text(text,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
    );
  }
}

class _IconItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _IconItem({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 32, color: color),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 10)),
    ]);
  }
}
