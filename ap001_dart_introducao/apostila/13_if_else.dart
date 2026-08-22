void main() {
  const idade = 19;
  if (idade >= 18) {
    print('Pode dirigir');
  } else {
    print('Não pode dirigir');
  }

  const nome = 'Ana';
  if (nome.startsWith('A')) {
    print('O nome começa com A');
  } else {
    print('O nome não começa com A');
  }

  const nota = 8.5;
  if (nota >= 9) {
    print('Conceito A');
  } else if (nota >= 7) {
    print('Conceito B');
  } else if (nota >= 5) {
    print('Conceito C');
  } else {
    print('Conceito R');
  }

  const numero = 18;
  if (numero.isEven) {
    print(numero % 4 == 0 ? 'Par e divisível por 4' : 'Par');
  } else {
    print(numero % 3 == 0 ? 'Ímpar e divisível por 3' : 'Ímpar');
  }
}
