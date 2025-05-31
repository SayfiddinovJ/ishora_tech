import 'package:flutter/material.dart';
import 'package:ishora_tech/app/app.dart';
import 'package:ishora_tech/ui/category/category_screen.dart';
import 'package:ishora_tech/ui/dictionary/dictionary_screen.dart';
import 'package:ishora_tech/ui/home/home_screen.dart';
import 'package:ishora_tech/ui/splash/splash_screen.dart';
import 'package:ishora_tech/ui/search/search_screen.dart';
import 'package:ishora_tech/ui/words/words_screen.dart';

class RouteNames {
  static const String splashScreen = "/";
  static const String app = "/app";
  static const String home = "/home";
  static const String dictionary = "/dictionary";
  static const String category = "/category";
  static const String words = "/words";
  static const String search = "/search";
}

class AppRoutes {
  static Route generateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case RouteNames.splashScreen:
        page = const SplashScreen();
        break;
      case RouteNames.app:
        page = const App();
        break;
      case RouteNames.home:
        page = const HomeScreen();
        break;
      case RouteNames.dictionary:
        page = const DictionaryScreen();
        break;
      case RouteNames.category:
        page = const CategoryScreen();
        break;
      case RouteNames.words:
        page = const WordsScreen();
        break;
      case RouteNames.search:
        page = const SearchScreen();
        break;
      default:
        page = const Scaffold(
          body: Center(child: Text("Route not found!")),
        );
    }

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // O'ngdan chapga slaydlash
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
