import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:ishora_tech/data/storage/storage_repo.dart';
import 'package:ishora_tech/ui/home/home_screen.dart';
import 'package:ishora_tech/ui/onboarding/onboarding_screen.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AppUpdateInfo? _updateInfo;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate()
        .then((info) {
          setState(() {
            _updateInfo = info;
          });
        })
        .catchError((e) {
          showSnack(e.toString());
        });
  }

  init() async {
    bool flexibleUpdateAvailable = false;

    await checkForUpdate();
    if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
      InAppUpdate.startFlexibleUpdate()
          .then((_) {
            setState(() {
              flexibleUpdateAvailable = true;
            });
          })
          .catchError((e) {
            showSnack(e.toString());
          });
    }
    if (flexibleUpdateAvailable) {
      InAppUpdate.completeFlexibleUpdate();
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(
        _scaffoldKey.currentContext!,
      ).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isUserEntered = StorageRepository.getBool('isUserEntered');
    return isUserEntered ? const HomeScreen() : const OnboardingScreen();
  }
}
