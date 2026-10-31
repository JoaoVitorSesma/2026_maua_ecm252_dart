import '../models/terrario.dart';
import '../repositories/terrario_repository.dart';

/// Prefixo comum de todos os recursos desta versão da API.
const String baseApi = '/api/v1';

/// Um controle de hipermídia: para onde ir e com qual verbo.
Map<String, String> _link(String href, String metodo) => {
  'href': href,
  'method': metodo,
};

/// Links de um terrário individual.
///
/// A relação `edit` só aparece quando o recurso pode de fato ser alterado.
/// É essa condicionalidade que dá valor real ao HATEOAS: o cliente não
/// reimplementa a regra, apenas verifica se o link existe.
Map<String, Map<String, String>> linksDoTerrario(Terrario t) {
  final self = '$baseApi/terrarios/${t.id}';

  final links = <String, Map<String, String>>{
    'self': _link(self, 'GET'),
    'collection': _link('$baseApi/terrarios', 'GET'),
  };

  final editavel = t.dataMontagem.isAfter(
    DateTime.now().toUtc().subtract(const Duration(days: 365)),
  );
  if (editavel) {
    links['edit'] = _link(self, 'PUT');
    links['delete'] = _link(self, 'DELETE');
  }

  return links;
}

/// Links de navegação de uma coleção paginada.
Map<String, Map<String, String>> linksDaColecao(
  Pagina<Terrario> pagina,
  Map<String, String> filtrosAtuais,
) {
  String url(int numero) {
    final parametros = <String, String>{
      ...filtrosAtuais,
      'pagina': '$numero',
      'tamanhoPagina': '${pagina.tamanhoPagina}',
    };
    final query = parametros.entries
        .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
        .join('&');
    return '$baseApi/terrarios?$query';
  }

  final links = <String, Map<String, String>>{
    'self': _link(url(pagina.pagina), 'GET'),
    'first': _link(url(1), 'GET'),
    'last': _link(url(pagina.totalPaginas), 'GET'),
    'create': _link('$baseApi/terrarios', 'POST'),
  };

  if (pagina.temAnterior) links['prev'] = _link(url(pagina.pagina - 1), 'GET');
  if (pagina.temProxima) links['next'] = _link(url(pagina.pagina + 1), 'GET');

  return links;
}
