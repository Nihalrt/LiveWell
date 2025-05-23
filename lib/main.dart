import 'package:flutter/material.dart';
import 'salary_input_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async{
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'liveWell',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true
      ),
      home: const SalaryInputPage(),

    );
  }
}