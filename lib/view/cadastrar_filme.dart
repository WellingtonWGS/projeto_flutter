import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../controller/filme_controller.dart';
import '../model/filme.dart';

class CadastrarFilme extends StatefulWidget {
  final Filme? filme;

  const CadastrarFilme({super.key, this.filme});

  @override
  State<CadastrarFilme> createState() => _CadastrarFilmeState();
}

class _CadastrarFilmeState extends State<CadastrarFilme> {
  final _key = GlobalKey<FormState>();
  final _edtTitulo = TextEditingController();
  final _edtGenero = TextEditingController();
  final _edtFaixaEtaria = TextEditingController();
  final _edtDuracaoHoras = TextEditingController();
  final _edtDuracaoMinutos = TextEditingController();
  final _edtDescricao = TextEditingController();
  final _edtAno = TextEditingController();
  final _filmeController = FilmeController();
  final _edtUrlImagem = TextEditingController();
  final List<String> _faixasEtarias = ['Livre', '10', '12', '14', '16', '18'];
  String _faixaEtariaSelecionada = 'Livre';

  double _nota = 0; // Variável para armazenar a nota selecionada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Filme"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(
            children: [
              TextFormField(
                controller: _edtTitulo,
                decoration: const InputDecoration(labelText: "Título"),
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _edtUrlImagem,
                decoration: const InputDecoration(labelText: "URL da Imagem"),
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
              ),
              TextFormField(
                controller: _edtGenero,
                decoration: const InputDecoration(labelText: "Gênero"),
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Faixa Etária",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButton<String>(
                      value: _faixaEtariaSelecionada,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: _faixasEtarias.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text("Classificação: $value"),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _faixaEtariaSelecionada = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _edtDuracaoHoras,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Horas"),
                      validator: (value) => value!.isEmpty ? "Obrigatório" : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _edtDuracaoMinutos,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Minutos"),
                      validator: (value) => value!.isEmpty ? "Obrigatório" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Widget de avaliação por estrelas
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Avaliação",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft, // Força o alinhamento à esquerda
                    child: RatingBar.builder(
                      initialRating: _nota,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _nota = rating;
                        });
                      },
                    ),
                  ),
                  Text(
                    _nota == 0 ? "Sem avaliação" : "Nota: $_nota",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _edtDescricao,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Descrição"),
                validator: (value) => value!.isEmpty ? "Campo obrigatório" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _edtAno,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Ano"),
                validator: (value) {
                  if (value!.isEmpty) return "Campo obrigatório";
                  if (int.tryParse(value) == null) return "Ano inválido";
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_key.currentState!.validate()) {
            try {
              _filmeController.adicionar(
                DateTime.now().millisecondsSinceEpoch, // id
                _edtTitulo.text,                      // titulo
                _edtUrlImagem.text,                   // url_imagem
                _edtGenero.text,                     // genero
                _edtFaixaEtaria.text,                 // faixa_etaria
                Duration(                             // duracao
                  hours: int.parse(_edtDuracaoHoras.text),
                  minutes: int.parse(_edtDuracaoMinutos.text),
                ),
                _nota,                              // nota (agora vem do RatingBar)
                _edtDescricao.text,                  // descricao
                int.parse(_edtAno.text),             // ano
              );

              Navigator.pop(context);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Erro: ${e.toString()}"))
              );
            }
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  @override
  void dispose() {
    _edtTitulo.dispose();
    _edtUrlImagem.dispose();
    _edtGenero.dispose();
    _edtFaixaEtaria.dispose();
    _edtDuracaoHoras.dispose();
    _edtDuracaoMinutos.dispose();
    _edtDescricao.dispose();
    _edtAno.dispose();
    super.dispose();
  }
}