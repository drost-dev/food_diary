import 'dart:async';
import 'package:flutter/material.dart';
import 'package:food_diary_app/repos/database_repo.dart';
import 'package:food_diary_app/router/router.dart';
import 'package:food_diary_app/themes/default.dart';
import 'package:get_it/get_it.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DatabaseRepository dbRepo = await DatabaseRepository.init();

  GetIt.instance.registerSingleton<DatabaseRepository>(dbRepo);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = $AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Food Diary',
      theme: defaultTheme,
      routerConfig: _appRouter.config(),
    );
  }
}
