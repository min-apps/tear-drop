import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teardrop/src/data/services/analytics_service.dart';
import 'package:teardrop/src/theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  static const _tabs = [
    '/home/presets',
    '/home/library',
    '/home/profile',
  ];

  static const _tabNames = ['presets', 'library', 'profile'];

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    context.go(_tabs[index]);
    try {
      AnalyticsService().logTabChanged(_tabNames[index]);
    } catch (_) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i])) {
        if (_currentIndex != i) {
          setState(() => _currentIndex = i);
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: TearDropTheme.border, width: 0.5),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabTapped,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.water_drop_outlined),
              selectedIcon: Icon(Icons.water_drop),
              label: '처방전',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_border_rounded),
              selectedIcon: Icon(Icons.bookmark_rounded),
              label: '보관함',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: '프로필',
            ),
          ],
        ),
      ),
    );
  }
}
