import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:self_discipline_app/core/router/app_router.dart';
import 'package:self_discipline_app/presentation/widgets/base_background.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBackground(
      child: AutoTabsScaffold(
        backgroundColor: Colors.transparent,
        routes: const [
          HomeRoute(),
          HabitListRoute(),
          HabitCreationRoute(),
          SettingsRoute(),
        ],
        bottomNavigationBuilder: (_, tabsRouter) {
          return BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Habits',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Create',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          );
        },
      ),
    );
  }
}
