import 'package:flutter/material.dart';
import 'package:projeto_teste/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App de Peças de Carro',
      home: MyHomePage(title: 'Minhas Peças', subtitle: 'Lista atual'),
    );
  }
}