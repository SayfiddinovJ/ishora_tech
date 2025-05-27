import 'package:flutter/material.dart';
import 'package:ishora_tech/data/storage/storage_repo.dart';
import 'package:ishora_tech/ui/home/home_screen.dart';
import 'package:ishora_tech/ui/onboarding/onboarding_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    bool isUserEntered = StorageRepository.getBool('isUserEntered');
    return isUserEntered ? const HomeScreen() : const OnboardingScreen();
  }
}
