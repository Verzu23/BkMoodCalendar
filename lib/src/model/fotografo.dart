class Fotografo {
  String nome;
  String cognome;

  Fotografo(this.nome, this.cognome);

  Fotografo.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    cognome = json['cognome'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nome'] = nome;
    data['cognome'] = cognome;
    return data;
  }
}
