import 'package:docuflex/features/convert/convert_from_pdf_section.dart';
import 'package:docuflex/features/convert/convert_to_pdf_section.dart';
import 'package:docuflex/features/organize/widgets/organize_section.dart';
import 'package:docuflex/features/scanner/widgets/scanner_section.dart';
import 'package:docuflex/features/secure/widgets/secure_docs_section.dart';
import 'package:docuflex/utils/global_variables.dart';
import 'package:docuflex/utils/utils.dart';
import 'package:docuflex/widgets/custom_drawer.dart';
import 'package:docuflex/widgets/recent_docs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:gap/gap.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:remixicon/remixicon.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = "/main-screen";
  const  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _advancedDrawerController = AdvancedDrawerController();

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

  Future<void> _askPermissions() async {
    var externalStoragePermission =
        await Permission.manageExternalStorage.status;
    if (!externalStoragePermission.isGranted) {
      await Permission.manageExternalStorage.request();
    }

    var imagePermission = await Permission.photos.status;
    if (!imagePermission.isGranted) {
      await Permission.photos.request();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkForAppUpdate();
    _askPermissions();
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.sizeOf(context);
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
      drawer: const CustomDrawer(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Hide keyboard and cursor
        },
        child: Scaffold(
            extendBody: true,
            appBar: AppBar(
                title: const Text('DocuFlex'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      // Add search functionality
                    },
                  ),
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
            body: const SingleChildScrollView(
                primary: true,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RecentDocs(),
                      Gap(10),
                      ScannerSection(),
                      ConvertToPdfSection(),
                      ConvertFromPdfSection(),
                      OrganizeSection(),
                      SecureDocsSection(),
                      Text("zip/unizp section"),
                    ],
                  ),
                ))),
      ),
    );
  }
}
