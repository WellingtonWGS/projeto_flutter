class Filme{
  int id;
  String titulo;
  String url_imagem;
  String genero;
  String faixa_etaria;
  Duration duracao;
  double nota;
  String descricao;
  int ano;

  Filme({required this.id, required this.titulo, required this.url_imagem,
    required this.genero, required this.faixa_etaria, required this.duracao,
    required this.nota, required this.descricao, required this.ano});

  @override
  String toString(){
    return "[Titulo: $titulo,]";
  }
}