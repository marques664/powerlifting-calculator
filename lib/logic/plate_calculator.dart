import 'package:pwl_calc/models/plate.dart';

class PlateCalculator {
  // Anilhas de powerlifting padrão (em kg) - Conforme regulamento oficial
  static const List<double> standardPlates = [
    25.0,  // Vermelha
    20.0,  // Azul
    15.0,  // Amarela
    10.0,  // Verde
    5.0,   // Branca
    2.5,   // Preta
    1.25,  // Amarelo claro
    1.0,   // Roxo
    0.5,   // Cinza escuro
    0.25,  // Branca pequena
  ];

  // Anilhas apenas de 20kg (academia comercial comum)
  // Inclui anilhas pequenas para ajuste fino
  // TODO: Implementar esta funcionalidade em outro momento
  // static const List<double> onlyTwentyPlates = [
  //   20.0, // Azul
  //   10.0, // Verde
  //   5.0,  // Branca
  //   2.5,  // Preta
  //   1.0,  // Verde escuro
  //   0.5,  // Roxa
  // ];

  static const double barWeight = 20.0; // Barra padrão pesa 20kg
  static const double collarWeight = 2.5; // Presilha de competição pesa 2,5kg

  /// Calcula as anilhas necessárias para atingir o peso total desejado
  /// [totalWeight] - Peso total desejado em kg
  /// [useCollars] - Se true, considera presilhas de competição (2,5kg cada lado)
  /// Retorna lista de anilhas para UM lado da barra, ou vazio se não conseguir fazer EXATAMENTE o peso
  static List<Plate> calculatePlates(
    double totalWeight, {
    bool useCollars = false,
  }) {
    // Peso da barra (20kg base + 2,5kg de presilha em CADA lado se usado)
    // Exemplo: barra (20kg) + 2 presilhas (2.5kg cada) = 25kg no total
    double barTotalWeight = useCollars ? barWeight + (collarWeight * 2) : barWeight;

    // Peso que falta distribuir (subtraímos a barra e dividimos por 2 para um lado)
    double targetPerSide = (totalWeight - barTotalWeight) / 2;

    if (targetPerSide < 0) {
      return []; // Não é possível fazer esse peso
    }

    List<Plate> result = [];
    double remaining = targetPerSide;
    const double epsilon = 0.01; // Margem de erro para comparações de ponto flutuante

    // Usa sempre as anilhas padrão de powerlifting
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

    // Valida se conseguiu fazer EXATAMENTE o peso desejado
    // Se houver resto significativo, não conseguimos montar exatamente - retorna vazio
    if (remaining > epsilon) {
      return [];
    }

    return result;
  }

  /// Retorna a cor da anilha conforme o padrão de powerlifting oficial
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
      case 1.25:
        return 'Amarelo claro';
      case 1.0:
        return 'Roxo';
      case 0.5:
        return 'Cinza escuro';
      case 0.25:
        return 'Branca pequena';
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
      case 1.25:
        return 0xFFFFD700; // Amarelo claro (ouro)
      case 1.0:
        return 0xFF6A0572; // Roxo
      case 0.5:
        return 0xFF444444; // Cinza escuro
      case 0.25:
        return 0xFFF5F5F5; // Branco pequena (tons mais claros)
      default:
        return 0xFFBDBDBD; // Cinza
    }
  }

  /// Calcula o peso total de um lado
  static double calculateTotalWeight(List<Plate> plates) {
    return plates.fold(0, (sum, plate) => sum + (plate.weight * plate.quantity));
  }

  /// Verifica se é possível montar o peso exatamente
  static bool canMakeWeight(
    double totalWeight, {
    bool useCollars = false,
  }) {
    double minWeight = useCollars ? barWeight + (collarWeight * 2) : barWeight;
    if (totalWeight < minWeight) return false;
    List<Plate> plates = calculatePlates(totalWeight, useCollars: useCollars);
    if (plates.isEmpty) return false;
    double barTotalWeight = useCollars ? barWeight + (collarWeight * 2) : barWeight;
    double madeWeight = barTotalWeight + (calculateTotalWeight(plates) * 2);
    return (madeWeight - totalWeight).abs() < 0.01;
  }
}
