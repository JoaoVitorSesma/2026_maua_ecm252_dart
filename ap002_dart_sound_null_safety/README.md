# Dart: laços, entrada de dados e sound null safety

Este diretório reúne exemplos executáveis dos assuntos apresentados na apostila
`02_apostila_dart_introducao.pdf` e uma implementação completa do jogo
pedra–papel–tesoura usado como estudo de caso.

## Conteúdo

| Arquivo | Assunto |
| --- | --- |
| `apostila/01_estruturas_repeticao.dart` | `for`, `for-in`, `while` e `do-while` |
| `apostila/02_enum.dart` | Declaração, valores e uso de `enum` |
| `apostila/03_entrada_saida.dart` | Entrada e saída com `dart:io` |
| `apostila/04_conversao_null_safety.dart` | Conversão segura de `String?` |
| `apostila/05_casas_decimais.dart` | Formatação com `toStringAsFixed` |
| `apostila/06_valores_aleatorios.dart` | Geração de valores com `Random` |
| `pedra_papel_tesoura/` | Projeto de console completo |

Os exemplos foram separados para que cada conceito possa ser executado e
alterado isoladamente. Para executar um deles a partir deste diretório:

```bash
dart run apostila/01_estruturas_repeticao.dart
dart run apostila/03_entrada_saida.dart
```

O exemplo de entrada e saída deve ser executado em um terminal, pois o Debug
Console do VS Code não aceita entrada por `stdin` na configuração padrão.

## Sound null safety na entrada de dados

`stdin.readLineSync()` devolve `String?`: o resultado pode ser um texto ou
`null`. Já `int.parse()` exige uma `String` não anulável. Por isso, passar o
resultado diretamente para `int.parse` não compila.

Este material mostra três formas de lidar com a situação:

- verificar se o valor é diferente de `null`, permitindo a promoção do tipo;
- usar `int.tryParse`, que também trata textos que não são números;
- usar `!` somente quando houver uma garantia real de que o valor não é nulo.

## Projeto pedra–papel–tesoura

```bash
cd pedra_papel_tesoura
dart run
```

Digite uma opção de `1` a `3` para jogar ou `4` para sair. Entradas vazias,
textos e números fora desse intervalo são recusados sem encerrar o programa.

Para validar o projeto:

```bash
dart analyze
dart run test/pedra_papel_tesoura_test.dart
```

