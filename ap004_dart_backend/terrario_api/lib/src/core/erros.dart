/// Classe base de todas as falhas previsíveis da aplicação.
sealed class ErroApp implements Exception {
  const ErroApp(this.mensagem);
  final String mensagem;

  @override
  String toString() => '$runtimeType: $mensagem';
}

/// O recurso pedido não existe. Vira 404.
class NaoEncontrado extends ErroApp {
  const NaoEncontrado(super.mensagem);
}

/// A requisição foi entendida, mas viola uma regra de negócio. Vira 422.
/// O mapa [campos] associa o nome de cada campo inválido à sua explicação,
/// permitindo que o formulário do cliente destaque exatamente o que corrigir.
class ErroValidacao extends ErroApp {
  const ErroValidacao(super.mensagem, [this.campos = const {}]);
  final Map<String, String> campos;
}

/// A operação conflita com o estado atual dos dados. Vira 409.
class Conflito extends ErroApp {
  const Conflito(super.mensagem);
}

/// O corpo enviado não pôde ser interpretado. Vira 400.
class RequisicaoInvalida extends ErroApp {
  const RequisicaoInvalida(super.mensagem);
}
