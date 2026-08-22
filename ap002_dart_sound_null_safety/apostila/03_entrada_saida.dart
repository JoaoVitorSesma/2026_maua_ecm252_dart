import 'dart:io';

void main() {
  stdout.write('Digite o seu nome: ');
  final nome = stdin.readLineSync();

  if (nome == null || nome.trim().isEmpty) {
    stdout.writeln('Nenhum nome foi informado.');
    return;
  }

  stdout.writeln('Olá, ${nome.trim()}!');
}
