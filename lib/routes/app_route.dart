import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ishora_tech/ui/app/app.dart';
import 'package:ishora_tech/ui/category/category_screen.dart';
import 'package:ishora_tech/ui/home/home_screen.dart';
import 'package:ishora_tech/ui/onboarding/onboarding_screen.dart';
import 'package:ishora_tech/ui/search/search_screen.dart';
import 'package:ishora_tech/ui/splash/splash_screen.dart';
import 'package:ishora_tech/ui/words/words_screen.dart';

class Routes {
  static const splash = '/';
  static const app = '/app';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const category = '/category';
  static const dictionary = '/dictionary';
  static const words = '/words';
  static const search = '/search';
}

class Pages {
  static Route<dynamic> onGeneratingRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return CupertinoPageRoute(builder: (context) => const SplashScreen());
      case Routes.app:
        return CupertinoPageRoute(builder: (context) => const App());
      case Routes.home:
        return CupertinoPageRoute(builder: (context) => const HomeScreen());
      case Routes.onboarding:
        return CupertinoPageRoute(
          builder: (context) => const OnboardingScreen(),
        );
      case Routes.category:
        return CupertinoPageRoute(builder: (context) => const CategoryScreen());
      case Routes.words:
        return CupertinoPageRoute(builder: (context) => const WordsScreen());
      case Routes.search:
        return CupertinoPageRoute(builder: (context) => const SearchScreen());
      default:
        return _errorRoute();
    }
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(
    builder: (context) => Scaffold(body: Center(child: Text('Error route'))),
  );
}
