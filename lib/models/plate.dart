class Plate {
  final double weight; // Peso em kg
  final String color; // Cor da anilha
  final int quantity; // Quantidade de anilhas

  Plate({
    required this.weight,
    required this.color,
    required this.quantity,
  });

  @override
  String toString() => '${weight}kg (x$quantity)';
}
