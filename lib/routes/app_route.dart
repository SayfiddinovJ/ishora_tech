import 'package:flutter/material.dart';
import 'package:ishora_tech/app/app.dart';
import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/ui/category/category_screen.dart';
import 'package:ishora_tech/ui/details/details_screen.dart';
import 'package:ishora_tech/ui/dictionary/dictionary_screen.dart';
import 'package:ishora_tech/ui/home/home_screen.dart';
import 'package:ishora_tech/ui/splash/splash_screen.dart';
import 'package:ishora_tech/ui/widgets/search_delegate.dart';
import 'package:ishora_tech/ui/words/words_screen.dart';

class RouteNames {
  static const String splashScreen = "/";
  static const String app = "/app";
  static const String home = "/home";
  static const String dictionary = "/dictionary";
  static const String category = "/category";
  static const String words = "/words";
  static const String details = "/details";
  static const String search = "/search";
}

class AppRoutes {
  static Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case RouteNames.app:
        return MaterialPageRoute(builder: (context) => const App());
      case RouteNames.home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case RouteNames.dictionary:
        return MaterialPageRoute(
          builder: (context) => const DictionaryScreen(),
        );
      case RouteNames.category:
        return MaterialPageRoute(builder: (context) => const CategoryScreen());
      case RouteNames.words:
        return MaterialPageRoute(builder: (context) => const WordsScreen());
      case RouteNames.search:
        return MaterialPageRoute(
          builder: (context) => const RealTimeSearchPage(),
        );
      case RouteNames.details:
        return MaterialPageRoute(
          builder:
              (context) => DetailsScreen(word: settings.arguments as WordModel),
        );
      default:
        return MaterialPageRoute(
          builder:
              (context) =>
                  const Scaffold(body: Center(child: Text("Route not found!"))),
        );
    }
  }
}
