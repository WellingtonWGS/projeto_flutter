import 'package:flutter/material.dart';
import '../controller/filme_controller.dart';
import '../model/filme.dart';
import 'cadastrar_filme.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ListarFilmes extends StatefulWidget {
  const ListarFilmes({super.key});

  @override
  State<ListarFilmes> createState() => _ListarFilmesState();
}
class _ListarFilmesState extends State<ListarFilmes> {
  final _filmesController = FilmeController();
  List<Filme> _filmes = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _filmes = _filmesController.getFilmes();
    });
  }

  void _showTeamMembersModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Integrantes da Equipe",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Daniel Warella Pitsch"),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Elder Oliveira"),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Wellingtom Gadelha"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _mostrarOpcoes(BuildContext context, Filme filme) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text("Ver Detalhes"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/detalhes', arguments: filme);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Editar Filme"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CadastrarFilme(filme: filme),
                    ),
                  ).then((value) {
                    setState(() {
                      _filmes = _filmesController.getFilmes();
                    });
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    return "$hours h $minutes m";
  }

  Widget buildItemList(int index) {
    final filme = _filmes[index];

    return Dismissible(
      key: Key(filme.titulo + index.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        setState(() {
          _filmesController.deletarFilme(filme);
          _filmes = _filmesController.getFilmes();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${filme.titulo} foi removido.')),
        );
      },
      child: InkWell(
        onTap: () => _mostrarOpcoes(context, filme),
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(filme.url_imagem),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              filme.titulo,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${filme.genero} • ${filme.ano}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatDuration(filme.duracao),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RatingBar.builder(
                        initialRating: filme.nota,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20,
                        ignoreGestures: true,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filmes"),
        backgroundColor: Colors.blue,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.info_outline,
                color: Colors.blue,
                size: 20,
              ),
            ),
            onPressed: () {
              _showTeamMembersModal(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filmes.length,
        itemBuilder: (context, index) {
          return buildItemList(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const CadastrarFilme();
          })).then((value) {
            setState(() {
              _filmes = _filmesController.getFilmes();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
