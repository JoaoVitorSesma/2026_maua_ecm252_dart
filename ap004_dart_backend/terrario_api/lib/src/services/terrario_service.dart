import '../core/erros.dart';
import '../models/terrario.dart';
import '../repositories/terrario_repository.dart';

class TerrarioService {
  TerrarioService(this._repository);

  final TerrarioRepository _repository;

  static const int _tamanhoPaginaMaximo = 100;

  Future<Pagina<Terrario>> listar(FiltroTerrario filtro) {
    // Um cliente que peça dez mil itens de uma vez derruba o servidor.
    // O teto é aplicado aqui, e não no controlador, porque é uma decisão
    // de negócio e não de protocolo.
    final seguro = FiltroTerrario(
      bioma: filtro.bioma,
      umidadeMinima: filtro.umidadeMinima,
      pagina: filtro.pagina < 1 ? 1 : filtro.pagina,
      // clamp é declarado em num e devolve num, por isso o toInt().
      tamanhoPagina: filtro.tamanhoPagina
          .clamp(1, _tamanhoPaginaMaximo)
          .toInt(),
    );
    return _repository.listar(seguro);
  }

  Future<Terrario> buscarPorId(int id) async {
    final terrario = await _repository.buscarPorId(id);
    if (terrario == null) {
      throw NaoEncontrado('Nao existe terrario com id $id.');
    }
    return terrario;
  }

  /// Valida todos os campos de uma vez e devolve o conjunto completo de
  /// problemas. Reportar um erro por vez obrigaria o usuário a corrigir
  /// o formulário em várias rodadas.
  void _validar(Terrario t) {
    final erros = <String, String>{};

    final apelido = t.apelido.trim();
    if (apelido.length < 3 || apelido.length > 80) {
      erros['apelido'] = 'Deve ter entre 3 e 80 caracteres.';
    }
    if (t.umidadeAlvo < 0 || t.umidadeAlvo > 100) {
      erros['umidadeAlvo'] = 'Deve estar entre 0 e 100.';
    }
    if (t.volumeLitros <= 0) {
      erros['volumeLitros'] = 'Deve ser maior que zero.';
    }
    final hoje = DateTime.now().toUtc();
    if (t.dataMontagem.isAfter(hoje)) {
      erros['dataMontagem'] = 'Nao pode estar no futuro.';
    }

    if (erros.isNotEmpty) {
      throw ErroValidacao('Os dados enviados sao invalidos.', erros);
    }
  }

  Future<Terrario> criar(Terrario novo) async {
    _validar(novo);

    final existente = await _repository.buscarPorApelido(novo.apelido);
    if (existente != null) {
      throw Conflito('Ja existe um terrario com o apelido "${novo.apelido}".');
    }

    return _repository.inserir(novo);
  }

  Future<Terrario> atualizar(int id, Terrario dados) async {
    _validar(dados);

    // Garante que o recurso existe antes de tentar alterá-lo, para poder
    // responder 404 em vez de um silencioso "nada foi alterado".
    await buscarPorId(id);

    final homonimo = await _repository.buscarPorApelido(dados.apelido);
    if (homonimo != null && homonimo.id != id) {
      throw Conflito('Ja existe um terrario com o apelido "${dados.apelido}".');
    }

    final atualizado = await _repository.atualizar(id, dados);
    if (atualizado == null) {
      throw NaoEncontrado('Nao existe terrario com id $id.');
    }
    return atualizado;
  }

  Future<void> remover(int id) async {
    final removido = await _repository.remover(id);
    if (!removido) {
      throw NaoEncontrado('Nao existe terrario com id $id.');
    }
  }
}
