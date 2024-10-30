import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:docuflex/utils/global_variables.dart';
import 'package:docuflex/utils/utils.dart';
import 'package:docuflex/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:remixicon/remixicon.dart';

import '../features/home/home_screen.dart';
import '../utils/enums.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = "/main-screen";
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _selectedTab = SelectedTab.scanner;
  final _advancedDrawerController = AdvancedDrawerController();

  List<Widget> screens = [
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
  ];

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = SelectedTab.values[i];
    });
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  Future<void> _checkForAppUpdate() async {
    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          // Perform immediate update
          InAppUpdate.performImmediateUpdate().then((appUpdateResult) {
            if (appUpdateResult == AppUpdateResult.success) {
              showSnackbar(context, "App updated successfully!",
                  GlobalVariables.successColor);
            }
          });
        }
      }
    }).catchError((e) {
      showSnackbar(context, "App update failed!", GlobalVariables.failureColor);
    });
  }

  @override
  void initState() {
    super.initState();
    _checkForAppUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple, Colors.deepPurple.withOpacity(0.2)],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 500),
      animateChildDecoration: true,
      rtlOpening: false,
      openRatio: 0.6,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      drawer:const CustomDrawer(),
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
            title: const Text('DocuFlex'),
            actions: [
              IconButton(
                icon: const Icon(
                  Remix.more_2_fill,
                ),
                onPressed: () {},
              )
            ],
            leading: IconButton(
              onPressed: _handleMenuButtonPressed,
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Icons.clear : Icons.menu,
                      key: ValueKey<bool>(value.visible),
                    ),
                  );
                },
              ),
            )),
        body: screens[_selectedTab.index],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: CrystalNavigationBar(
            currentIndex: SelectedTab.values.indexOf(_selectedTab),
            height: 10,
            indicatorColor: Colors.purple,
            unselectedItemColor: Colors.white70,
            backgroundColor: Colors.deepPurple.withOpacity(0.1),
            splashColor: Colors.transparent,
            onTap: _handleIndexChanged,
            items: [
              /// Home
              CrystalNavigationBarItem(
                icon: Remix.home_4_fill,
                unselectedIcon: Remix.home_4_line,
                selectedColor: Colors.purple,
                unselectedColor: Colors.grey,
              ),

              /// learn
              CrystalNavigationBarItem(
                icon: Remix.graduation_cap_fill,
                unselectedIcon: Remix.graduation_cap_line,
                selectedColor: Colors.purple,
                unselectedColor: Colors.grey,
              ),

              /// scanner
              CrystalNavigationBarItem(
                icon: Remix.qr_code_fill,
                unselectedIcon: Remix.qr_code_line,
                selectedColor: Colors.purple,
                unselectedColor: Colors.grey,
              ),

              /// quiz
              CrystalNavigationBarItem(
                icon: Remix.award_fill,
                unselectedIcon: Remix.award_line,
                selectedColor: Colors.purple,
                unselectedColor: Colors.grey,
              ),

              /// revison
              CrystalNavigationBarItem(
                icon: Remix.brain_fill,
                unselectedIcon: Remix.brain_line,
                selectedColor: Colors.purple,
                unselectedColor: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
