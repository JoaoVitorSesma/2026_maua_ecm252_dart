# Resolução do capítulo 17

O `capitulo17.patch` implementa os dez exercícios da página numerada 83.
Ele é separado para manter os exemplos dos capítulos 10 a 16 como aparecem
na apostila. Não foi aplicado ao projeto principal.

## Correspondência com os exercícios

| Exercício | Implementação no patch |
| --- | --- |
| 1 | `observacoes` opcional no modelo, JSON, SQL, consultas, validação de 500 caracteres e OpenAPI. `copyWith` diferencia valor omitido de `null`. |
| 2 | GET `/api/v1` devolve somente `_links`, com `terrarios`, `docs` e `health`. |
| 3 | `ordenarPor` aceita `apelido`, `umidadeAlvo` e `dataMontagem`, com `:asc` ou `:desc` opcionais. Valores inválidos retornam 422. |
| 4 | PATCH `/api/v1/terrarios/<id>` combina os campos enviados com os dados atuais; comentário explica a diferença para PUT e a idempotência. |
| 5 | Testes HTTP com servidor real, porta efêmera e repositório em memória verificam status, Location, links e outras operações. |
| 6 | Modelo `Especie`, tabelas `especies` e `terrario_especies`, consulta por JOIN, rota de espécies e relação nos links do terrário. |
| 7 | Uma linha JSON por requisição, com método, rota, status, duração e identificador; propagação ou geração de `X-Request-Id`. |
| 8 | Limite de 60 requisições por minuto por endereço da conexão; excedentes recebem 429 e Retry-After. |
| 9 | Serviço Adminer no Compose, na mesma rede do banco, publicado em `127.0.0.1:8081` e sem montar o volume de dados. |
| 10 | Erro 1062 nas escritas MySQL vira `Conflito` e resposta 409, mesmo depois da verificação prévia do apelido. |

O patch também completa o contrato OpenAPI para as operações adicionadas e
para as demais rotas existentes.

## Aplicação

Execute os comandos abaixo a partir da raiz do repositório independente
`2026_maua_ecm252_dart`. O patch dos exercícios depende das correções mínimas
e da formatação que acompanham `CORRECOES_APOSTILA.patch`.

```powershell
git apply --check ap004_dart_backend/CORRECOES_APOSTILA.patch
git apply ap004_dart_backend/CORRECOES_APOSTILA.patch
git apply --check ap004_dart_backend/exercicios/capitulo17.patch
git apply ap004_dart_backend/exercicios/capitulo17.patch
cd ap004_dart_backend/terrario_api
dart pub get
dart analyze
dart test
```

Se o patch de correções já tiver sido aplicado, comece pela conferência do
patch dos exercícios. Os dois patches foram verificados em sequência numa
cópia limpa, sem modificar o projeto principal.

## Banco de dados

O patch acrescenta `docker/mysql/init/02-exercicios.sql`. Num volume novo,
o MySQL executa esse arquivo depois do schema original. Num banco existente,
ele deve ser aplicado uma única vez; os scripts de inicialização não são
reexecutados automaticamente. Não é necessário apagar o volume existente.

O script adiciona `observacoes`, cria as duas tabelas de espécies e insere
duas espécies com associações aos terrários iniciais. As chaves estrangeiras
usam o mesmo tipo das chaves referenciadas.

## Decisões usadas na resolução

Na ordenação, os nomes públicos são traduzidos por uma lista de colunas
permitidas. Não se interpola texto livre do parâmetro em `ORDER BY`:
parâmetros de valores não substituem identificadores SQL, e aceitar texto
arbitrário nesse ponto permitiria injeção. O identificador é usado como
critério de desempate para estabilizar a paginação.

O PATCH desta resolução sobrescreve campos e, por isso, repetir o mesmo
pedido produz o mesmo estado. PATCH em geral também pode representar ações
como incrementar ou acrescentar itens; essas ações não são necessariamente
idempotentes. PUT continua exigindo todos os campos obrigatórios.

A consulta prévia do apelido melhora a resposta usual, mas duas requisições
simultâneas podem consultar antes de qualquer uma inserir. A restrição UNIQUE
do MySQL resolve a disputa; capturar o erro 1062 evita transformar esse caso
em um erro interno 500.

O limitador usa o endereço real da conexão HTTP, sem confiar livremente em
`X-Forwarded-For`. Seu contador fica em memória por processo; uma instalação
com várias réplicas precisaria de armazenamento compartilhado para um limite
global. O exercício foi resolvido para a instância única da apostila.

## Validação

A cópia isolada passou em `dart analyze`, nos 13 testes e na compilação do
executável Windows. O Compose com Adminer e as referências OpenAPI também
foram conferidos. O erro 1062 foi simulado no driver; os demais testes HTTP
usaram armazenamento em memória. A migração e a concorrência no MySQL real
ainda precisam ser verificadas com o Docker Engine disponível.

As limitações de datas e links condicionais da apostila continuam descritas
no [relatório](../RELATORIO_IMPLEMENTACAO.md); os testes passarem não significa
que esses comportamentos tenham sido corrigidos.
