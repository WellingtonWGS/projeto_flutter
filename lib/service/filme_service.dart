
import '../model/filme.dart';

class FilmeService{
  static final _filmes = [
    Filme(id: 0, titulo: "Velozes e Furiosos", url_imagem: "https://m.media-amazon.com/images/S/pv-target-images/848a155842f8331062bd190b1584e3b152af0271468312ce6b0def838721592b.jpg",
        genero: "Acao", faixa_etaria: "18 anos", duracao: Duration(hours: 2, minutes: 30),
        nota: 10, descricao: "Aqui é o Brasil!!!!", ano: 2000)
  ];

  List<Filme> get filmes{
    return List.unmodifiable(_filmes);
  }

  void adicionar(Filme filme){
    _filmes.add(filme);
  }

  void deletarFilme(Filme filme) {
    _filmes.removeWhere((f) => f.id == filme.id);
  }
}