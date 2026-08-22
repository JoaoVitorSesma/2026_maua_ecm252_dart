void main() {
  const pesoKg = 72.0;
  const alturaMetros = 1.75;
  const idade = 25;

  const imc = pesoKg / (alturaMetros * alturaMetros);
  const alturaCentimetros = alturaMetros * 100;
  const indiceEnergetico = 10 * pesoKg + 6.25 * alturaCentimetros - 5 * idade;

  print('Peso: ${pesoKg.toStringAsFixed(1)} kg');
  print('Altura: ${alturaMetros.toStringAsFixed(2)} m');
  print('Altura em centímetros: ${alturaCentimetros.toStringAsFixed(1)} cm');
  print('Idade: $idade anos');
  print('IMC: ${imc.toStringAsFixed(2)}');
  print('Índice energético: ${indiceEnergetico.toStringAsFixed(2)}');
}
