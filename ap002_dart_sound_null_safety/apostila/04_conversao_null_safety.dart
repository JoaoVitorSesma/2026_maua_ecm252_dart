import 'dart:io';

void main() {
  stdout.write('Digite sua idade: ');

  // readLineSync devolve String?, pois a entrada pode ser encerrada sem texto.
  final entrada = stdin.readLineSync();

  if (entrada == null) {
    stdout.writeln('A entrada foi encerrada.');
    return;
  }

  // Depois do teste acima, Dart promove entrada de String? para String.
  final idade = int.tryParse(entrada);
  if (idade == null || idade < 0) {
    stdout.writeln('Digite uma idade válida.');
    return;
  }

  stdout.writeln('Você tem $idade anos.');
}

// Também seria possível escrever int.parse(stdin.readLineSync()!), mas o
// operador ! apenas promete que o valor não é null. Uma promessa incorreta
// provoca uma exceção em tempo de execução, por isso a validação é preferível.
