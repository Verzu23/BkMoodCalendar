class Luogo {
  String nome;
  String latitudine;
  String longitudine;

  Luogo(this.nome, this.latitudine, this.longitudine);

  Luogo.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    latitudine = json['latitudine'];
    longitudine = json['longitudine'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['nome'] = nome;
    data['latitudine'] = latitudine;
    data['longitudine'] = longitudine;
    return data;
  }
}
