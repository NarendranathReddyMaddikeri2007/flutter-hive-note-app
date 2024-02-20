


import 'package:flutter/material.dart';
import 'package:hive_bloc_app1/ui/home.dart';
import 'package:hive_flutter/adapters.dart';


void main() async{


  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('note_app');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home:  HomePage(),
        debugShowCheckedModeBanner: false,
    );
  }
}