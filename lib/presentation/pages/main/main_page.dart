import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:self_discipline_app/core/router/app_router.dart';
import 'package:self_discipline_app/core/utils/logger.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    Logger.pageBuild('MainPage');
    return AutoTabsScaffold(
      backgroundColor: Colors.transparent,
      routes: const [
        HomeRoute(),
        HabitRecommendationRoute(),
        StatsRoute(),
        SettingsRoute(),
      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        return Container(
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Left side items
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _NavBarItem(
                          icon: Icons.list_outlined,
                          activeIcon: Icons.list,
                          label: 'Habits',
                          isSelected: tabsRouter.activeIndex == 1,
                          onTap: () => tabsRouter.setActiveIndex(1),
                        ),
                        _NavBarItem(
                          icon: Icons.home_outlined,
                          activeIcon: Icons.home,
                          label: 'Home',
                          isSelected: tabsRouter.activeIndex == 0,
                          onTap: () => tabsRouter.setActiveIndex(0),
                        ),
                      ],
                    ),
                  ),
                  // Space for center button
                  const SizedBox(width: 80),
                  // Right side items
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _NavBarItem(
                          icon: Icons.analytics_outlined,
                          activeIcon: Icons.analytics,
                          label: 'Stats',
                          isSelected: tabsRouter.activeIndex == 2,
                          onTap: () => tabsRouter.setActiveIndex(2),
                        ),
                        _NavBarItem(
                          icon: Icons.settings_outlined,
                          activeIcon: Icons.settings,
                          label: 'Settings',
                          isSelected: tabsRouter.activeIndex == 3,
                          onTap: () => tabsRouter.setActiveIndex(3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Center FAB
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    context.pushRoute(const HabitCreationRoute());
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withOpacity(0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
