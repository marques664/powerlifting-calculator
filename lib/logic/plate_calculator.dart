import 'package:pwl_calc/models/plate.dart';

class PlateCalculator {
  // Anilhas de powerlifting padrão (em kg)
  static const List<double> standardPlates = [
    25.0, // Vermelha
    20.0, // Azul
    15.0, // Amarela
    10.0, // Verde
    5.0,  // Branca
    2.5,  // Preta
    2.0,  // Ciano
    1.5,  // Cinza
    1.0,  // Roxo
    0.5,  // Cinza escuro
  ];

  static const double barWeight = 20.0; // Barra padrão pesa 20kg
  static const double collarWeight = 2.5; // Presilha de competição pesa 2,5kg

  /// Calcula as anilhas necessárias para atingir o peso total desejado
  /// [totalWeight] - Peso total desejado em kg
  /// [useCollars] - Se true, considera presilhas de competição (2,5kg cada lado)
  /// Retorna lista de anilhas para UM lado da barra
  static List<Plate> calculatePlates(double totalWeight, {bool useCollars = false}) {
    // Peso da barra (20kg base + 2,5kg de presilha se usado)
    double barTotalWeight = useCollars ? barWeight + collarWeight : barWeight;

    // Peso que falta distribuir (subtraímos a barra e dividimos por 2 para um lado)
    double targetPerSide = (totalWeight - barTotalWeight) / 2;

    if (targetPerSide < 0) {
      return []; // Não é possível fazer esse peso
    }

    List<Plate> result = [];
    double remaining = targetPerSide;
    const double epsilon = 0.01; // Margem de erro para comparações de ponto flutuante

    for (double plateWeight in standardPlates) {
      if (remaining >= plateWeight - epsilon) {
        int quantity = (remaining / plateWeight).floor();
        if (quantity > 0) {
          result.add(
            Plate(
              weight: plateWeight,
              color: _getPlateColor(plateWeight),
              quantity: quantity,
            ),
          );
          remaining -= quantity * plateWeight;
        }
      }
    }

    // Se houver resto significativo, não conseguimos montar exatamente
    if (remaining > epsilon) {
      // Tenta ajustar removendo a última anilha e usando combinações menores
      if (result.isNotEmpty) {
        final lastPlate = result.removeLast();
        remaining += lastPlate.weight * lastPlate.quantity;
      }
    }

    return result;
  }

  /// Retorna a cor da anilha conforme o padrão de powerlifting
  static String _getPlateColor(double weight) {
    switch (weight) {
      case 25.0:
        return 'Vermelha';
      case 20.0:
        return 'Azul';
      case 15.0:
        return 'Amarela';
      case 10.0:
        return 'Verde';
      case 5.0:
        return 'Branca';
      case 2.5:
        return 'Preta';
      case 2.0:
        return 'Amarela';
      case 1.5:
        return 'Amarelo escuro';
      case 1.0:
        return 'Verde escuro';
      case 0.5:
        return 'Roxa';
      default:
        return 'Cinza';
    }
  }

  /// Retorna a cor hexadecimal para visualização
  static int getPlateHexColor(double weight) {
    switch (weight) {
      case 25.0:
        return 0xFFE63946; // Vermelho (IWF padrão)
      case 20.0:
        return 0xFF1D3557; // Azul (IWF padrão)
      case 15.0:
        return 0xFFFFC300; // Amarelo (IWF padrão)
      case 10.0:
        return 0xFF06A77D; // Verde (IWF padrão)
      case 5.0:
        return 0xFFFAFAFA; // Branco
      case 2.5:
        return 0xFF1A1A1A; // Preto
      case 2.0:
        return 0xFFFFC300; // Amarelo (pode ser variado)
      case 1.5:
        return 0xFFA67C00; // Amarelo escuro
      case 1.0:
        return 0xFF1B5E3F; // Verde escuro
      case 0.5:
        return 0xFF6A0572; // Roxo
      default:
        return 0xFFBDBDBD; // Cinza
    }
  }

  /// Calcula o peso total de um lado
  static double calculateTotalWeight(List<Plate> plates) {
    return plates.fold(0, (sum, plate) => sum + (plate.weight * plate.quantity));
  }

  /// Verifica se é possível montar o peso exatamente
  static bool canMakeWeight(double totalWeight, {bool useCollars = false}) {
    double minWeight = useCollars ? barWeight + collarWeight : barWeight;
    if (totalWeight < minWeight) return false;
    List<Plate> plates = calculatePlates(totalWeight, useCollars: useCollars);
    if (plates.isEmpty) return false;
    double barTotalWeight = useCollars ? barWeight + collarWeight : barWeight;
    double madeWeight = barTotalWeight + (calculateTotalWeight(plates) * 2);
    return (madeWeight - totalWeight).abs() < 0.01;
  }
}
