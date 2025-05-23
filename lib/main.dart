import 'package:flutter/material.dart';
import 'view/listar_filmes.dart';
import 'view/detalhes_filme.dart';
import 'model/filme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Filmes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ListarFilmes(),
      routes: {
        '/detalhes': (context) {
          final filme = ModalRoute.of(context)!.settings.arguments as Filme;
          return DetalhesFilme(filme: filme);
        },
      },
    );
  }
}
