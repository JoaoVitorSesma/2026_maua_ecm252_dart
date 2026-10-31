import 'package:terrario_api/src/core/erros.dart';
import 'package:terrario_api/src/models/terrario.dart';
import 'package:terrario_api/src/repositories/terrario_repository.dart';
import 'package:terrario_api/src/services/terrario_service.dart';
import 'package:test/test.dart';

/// Implementação em memória usada apenas nos testes.
///
/// Como o serviço depende da interface e não da classe concreta, ele não
/// percebe a diferença. Um Map faz o papel da tabela e um contador faz o
/// papel do AUTO_INCREMENT.
class RepositorioFake implements TerrarioRepository {
  final Map<int, Terrario> _dados = {};
  int _proximoId = 1;

  @override
  Future<Terrario> inserir(Terrario t) async {
    final salvo = t.copyWith(id: _proximoId++);
    _dados[salvo.id!] = salvo;
    return salvo;
  }

  @override
  Future<Terrario?> buscarPorId(int id) async => _dados[id];

  @override
  Future<Terrario?> buscarPorApelido(String apelido) async {
    for (final t in _dados.values) {
      if (t.apelido == apelido) return t;
    }
    return null;
  }

  @override
  Future<Pagina<Terrario>> listar(FiltroTerrario f) async => Pagina(
    itens: _dados.values.toList(),
    total: _dados.length,
    pagina: f.pagina,
    tamanhoPagina: f.tamanhoPagina,
  );

  @override
  Future<Terrario?> atualizar(int id, Terrario t) async =>
      _dados.containsKey(id) ? (_dados[id] = t.copyWith(id: id)) : null;

  @override
  Future<bool> remover(int id) async => _dados.remove(id) != null;
}

void main() {
  late TerrarioService service;

  // setUp roda antes de cada teste, então cada caso começa com um
  // repositório vazio e não enxerga o que os outros fizeram.
  setUp(() => service = TerrarioService(RepositorioFake()));

  // Fábrica de dados válidos: cada teste altera só o campo que lhe
  // interessa, o que deixa evidente qual é a condição sob avaliação.
  Terrario valido({String apelido = 'Vale das Samambaias'}) => Terrario(
    apelido: apelido,
    bioma: Bioma.tropical,
    umidadeAlvo: 85,
    volumeLitros: 12.5,
    dataMontagem: DateTime.utc(2026, 3, 14),
  );

  test('cria um terrario valido e recebe identificador', () async {
    final criado = await service.criar(valido());
    expect(criado.id, isNotNull);
  });

  test('recusa umidade fora da faixa', () {
    final invalido = valido().copyWith(umidadeAlvo: 130);
    expect(() => service.criar(invalido), throwsA(isA<ErroValidacao>()));
  });

  test('recusa apelido duplicado', () async {
    // O primeiro criar passa; o segundo esbarra na verificação de
    // unicidade, que só tem efeito porque o repositório já tem estado.
    await service.criar(valido());
    expect(() => service.criar(valido()), throwsA(isA<Conflito>()));
  });

  test('buscar identificador inexistente lanca NaoEncontrado', () {
    expect(() => service.buscarPorId(999), throwsA(isA<NaoEncontrado>()));
  });
}
