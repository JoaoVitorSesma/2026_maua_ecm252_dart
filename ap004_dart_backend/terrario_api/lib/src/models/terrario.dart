/// Biomas aceitos pelo catálogo. O enum garante, em tempo de compilação,
/// que nenhum ponto do código invente um valor fora da lista.
enum Bioma {
  tropical,
  desertico,
  temperado,
  musgo;

  /// Converte o texto vindo do JSON ou do banco em um valor do enum.
  /// Devolve null quando o texto não corresponde a nenhum bioma conhecido,
  /// deixando a decisão sobre o erro para a camada de validação.
  static Bioma? porNome(String? nome) {
    if (nome == null) return null;
    final alvo = nome.trim().toLowerCase();
    for (final bioma in Bioma.values) {
      if (bioma.name == alvo) return bioma;
    }
    return null;
  }
}

/// Um terrário do catálogo.
class Terrario {
  const Terrario({
    this.id,
    required this.apelido,
    required this.bioma,
    required this.umidadeAlvo,
    required this.volumeLitros,
    required this.dataMontagem,
    this.criadoEm,
    this.atualizadoEm,
  });

  /// Nulo enquanto o terrário ainda não foi persistido.
  final int? id;
  final String apelido;
  final Bioma bioma;
  final int umidadeAlvo;
  final double volumeLitros;
  final DateTime dataMontagem;
  final DateTime? criadoEm;
  final DateTime? atualizadoEm;

  Terrario copyWith({
    int? id,
    String? apelido,
    Bioma? bioma,
    int? umidadeAlvo,
    double? volumeLitros,
    DateTime? dataMontagem,
  }) {
    return Terrario(
      id: id ?? this.id,
      apelido: apelido ?? this.apelido,
      bioma: bioma ?? this.bioma,
      umidadeAlvo: umidadeAlvo ?? this.umidadeAlvo,
      volumeLitros: volumeLitros ?? this.volumeLitros,
      dataMontagem: dataMontagem ?? this.dataMontagem,
      criadoEm: criadoEm,
      atualizadoEm: atualizadoEm,
    );
  }

  /// Representação enviada ao cliente. Datas viram texto ISO-8601 e o enum
  /// vira o seu nome, que é o formato documentado no contrato da API.
  Map<String, dynamic> toJson() => {
    'id': id,
    'apelido': apelido,
    'bioma': bioma.name,
    'umidadeAlvo': umidadeAlvo,
    'volumeLitros': volumeLitros,
    'dataMontagem': _somenteData(dataMontagem),
    'criadoEm': criadoEm?.toIso8601String(),
    'atualizadoEm': atualizadoEm?.toIso8601String(),
  };

  static String _somenteData(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
