import 'package:flutter/material.dart';
import 'package:jaap_latest/controller/language_manager.dart';
import 'package:provider/provider.dart';
import 'mandir.dart';
import 'mandir_home_page.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LanguageProvider(),)
  ],
  child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    home: Mandir(),
    );
  }
}
