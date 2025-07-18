import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ishora_tech/bloc/word_bloc.dart';
import 'package:ishora_tech/data/storage/storage_repo.dart';
import 'package:ishora_tech/repository/word_repository.dart';
import 'package:ishora_tech/routes/app_route.dart';
import 'package:ishora_tech/service/word_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  StorageRepository.getInstance();
  runApp(Main(service: WordService()));
}

class Main extends StatelessWidget {
  const Main({super.key, required this.service});

  final WordService service;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WordRepository(service: service),
      child: BlocProvider(
        create: (context) => WordBloc(context.read<WordRepository>()),
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'IshoraTech',
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          initialRoute: Routes.splash,
          onGenerateRoute: Pages.onGeneratingRoute,
        );
      },
    );
  }
}
