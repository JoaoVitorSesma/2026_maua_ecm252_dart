import 'package:mysql_dart/mysql_dart.dart';

import '../models/terrario.dart';
import 'terrario_repository.dart';

class MySqlTerrarioRepository implements TerrarioRepository {
  MySqlTerrarioRepository(this._pool);

  final MySQLConnectionPool _pool;

  /// Colunas listadas explicitamente em vez de SELECT *: assim a ordem e o
  /// conjunto de campos não mudam quando alguém alterar a tabela.
  static const String _colunas =
      'id, apelido, bioma, umidade_alvo, volume_litros, '
      'data_montagem, criado_em, atualizado_em';

  /// Converte uma linha do resultado em uma entidade.
  ///
  /// O driver devolve colunas DECIMAL como texto justamente para preservar
  /// a precisão, então a conversão para double é feita aqui, no único ponto
  /// do sistema que conhece o formato do banco.
  Terrario _mapear(ResultSetRow linha) {
    // assoc() devolve Map<String, dynamic>. Como o analysis_options.yaml
    // ativa strict-casts, o Dart recusa converter dynamic em String sem
    // que a intenção esteja escrita: o cast declara que toda coluna deste
    // SELECT chega como texto.
    final dados = linha.assoc().cast<String, String?>();
    return Terrario(
      id: int.parse(dados['id']!),
      apelido: dados['apelido']!,
      bioma: Bioma.porNome(dados['bioma'])!,
      umidadeAlvo: int.parse(dados['umidade_alvo']!),
      volumeLitros: double.parse(dados['volume_litros']!),
      dataMontagem: DateTime.parse(dados['data_montagem']!),
      criadoEm: DateTime.tryParse(dados['criado_em'] ?? ''),
      atualizadoEm: DateTime.tryParse(dados['atualizado_em'] ?? ''),
    );
  }

  @override
  Future<Terrario?> buscarPorId(int id) async {
    // O parâmetro nomeado :id nunca é concatenado no texto do comando:
    // o driver envia valor e comando separadamente, o que elimina a
    // possibilidade de injeção de SQL.
    final resultado = await _pool.execute(
      'SELECT $_colunas FROM terrarios WHERE id = :id',
      {'id': id},
    );
    if (resultado.rows.isEmpty) return null;
    return _mapear(resultado.rows.first);
  }

  @override
  Future<Terrario?> buscarPorApelido(String apelido) async {
    final resultado = await _pool.execute(
      'SELECT $_colunas FROM terrarios WHERE apelido = :apelido',
      {'apelido': apelido},
    );
    if (resultado.rows.isEmpty) return null;
    return _mapear(resultado.rows.first);
  }

  @override
  Future<Pagina<Terrario>> listar(FiltroTerrario filtro) async {
    // Condições e parâmetros crescem juntos, mantendo a correspondência.
    final condicoes = <String>[];
    final parametros = <String, dynamic>{};

    if (filtro.bioma != null) {
      condicoes.add('bioma = :bioma');
      parametros['bioma'] = filtro.bioma!.name;
    }
    if (filtro.umidadeMinima != null) {
      condicoes.add('umidade_alvo >= :umidade');
      parametros['umidade'] = filtro.umidadeMinima;
    }

    final where = condicoes.isEmpty ? '' : 'WHERE ${condicoes.join(' AND ')}';

    // Primeiro o total, usado para calcular o número de páginas.
    final contagem = await _pool.execute(
      'SELECT COUNT(*) AS total FROM terrarios $where',
      parametros,
    );
    final total = int.parse(
      contagem.rows.first.assoc().cast<String, String?>()['total']!,
    );

    // Depois a página propriamente dita. LIMIT e OFFSET também são
    // parâmetros, nunca concatenação de texto.
    final resultado = await _pool.execute(
      'SELECT $_colunas FROM terrarios $where '
      'ORDER BY apelido ASC LIMIT :limite OFFSET :deslocamento',
      {
        ...parametros,
        'limite': filtro.tamanhoPagina,
        'deslocamento': filtro.deslocamento,
      },
    );

    return Pagina<Terrario>(
      itens: resultado.rows.map(_mapear).toList(growable: false),
      total: total,
      pagina: filtro.pagina,
      tamanhoPagina: filtro.tamanhoPagina,
    );
  }

  @override
  Future<Terrario> inserir(Terrario terrario) async {
    final resultado = await _pool.execute(
      'INSERT INTO terrarios '
      '(apelido, bioma, umidade_alvo, volume_litros, data_montagem) '
      'VALUES (:apelido, :bioma, :umidade, :volume, :data)',
      {
        'apelido': terrario.apelido,
        'bioma': terrario.bioma.name,
        'umidade': terrario.umidadeAlvo,
        'volume': terrario.volumeLitros,
        'data': _formatarData(terrario.dataMontagem),
      },
    );

    final novoId = resultado.lastInsertID.toInt();
    // Recarrega para trazer criado_em e atualizado_em gerados pelo banco.
    return (await buscarPorId(novoId))!;
  }

  @override
  Future<Terrario?> atualizar(int id, Terrario terrario) async {
    final resultado = await _pool.execute(
      'UPDATE terrarios SET '
      'apelido = :apelido, bioma = :bioma, umidade_alvo = :umidade, '
      'volume_litros = :volume, data_montagem = :data '
      'WHERE id = :id',
      {
        'id': id,
        'apelido': terrario.apelido,
        'bioma': terrario.bioma.name,
        'umidade': terrario.umidadeAlvo,
        'volume': terrario.volumeLitros,
        'data': _formatarData(terrario.dataMontagem),
      },
    );

    // affectedRows igual a zero pode significar duas coisas: o id não existe
    // ou os valores enviados eram idênticos aos atuais. Como as duas situações
    // são indistinguíveis aqui, a decisão fica com a releitura: se o registro
    // existir, ele é devolvido; se não, o retorno é nulo e a camada de serviço
    // transforma isso em 404.
    return buscarPorId(id);
  }

  @override
  Future<bool> remover(int id) async {
    final resultado = await _pool.execute(
      'DELETE FROM terrarios WHERE id = :id',
      {'id': id},
    );
    return resultado.affectedRows.toInt() > 0;
  }

  /// O MySQL espera datas no formato AAAA-MM-DD.
  static String _formatarData(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
