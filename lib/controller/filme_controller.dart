import '../model/filme.dart';
import '../service/filme_service.dart';

class FilmeController{

  final _service = FilmeService();
  //instancia de filme_service onde tem a lista de todos os filmes

  List<Filme> getFilmes(){
    return _service.filmes; //manda a lista pelo controller
  }

  void adicionar(int id, String titulo, String url_imagem, String genero, String faixa_etaria,
      Duration duracao, double nota, String descricao, int ano){
    _service.adicionar(Filme(id: id, titulo: titulo, url_imagem: url_imagem, genero: genero,
      faixa_etaria: faixa_etaria, duracao: duracao, nota: nota, descricao: descricao, ano: ano));
  }

  void deletarFilme(Filme filme) => _service.deletarFilme(filme);
}