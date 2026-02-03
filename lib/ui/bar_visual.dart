import 'package:flutter/material.dart';
import 'package:pwl_calc/logic/plate_calculator.dart';
import 'package:pwl_calc/models/plate.dart';

class BarVisual extends StatelessWidget {
  final List<Plate> plates;
  final double totalWeight;
  final bool useCollars;

  const BarVisual({
    super.key,
    required this.plates,
    required this.totalWeight,
    required this.useCollars,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            'Peso Total: ${totalWeight.toStringAsFixed(1)} kg',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 30),
          // Visualização da barra
          _buildBarVisualization(),
          const SizedBox(height: 30),
          // Lista de anilhas
          _buildPlatesList(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBarVisualization() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Presilha de competição (se ativada)
            if (useCollars)
              Container(
                width: 15,
                height: 32,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A), // Preto mais escuro
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.white10, width: 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 2,
                      offset: const Offset(0.5, 0.5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bolinha cinza clara
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.grey[400], // Cinza claro
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 2),
                    // Texto do peso
                    const Text(
                      '2.5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            // Lado esquerdo da barra com anilhas
            ..._buildPlatesStack(),
            // Barra central
            Container(
              width: 15,
              height: 32,
              decoration: BoxDecoration(
                color: Color(0xB03F3F3F),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Container(
              width: 80,
              height: 18,
              decoration: BoxDecoration(
                color: Color(0xB0A9A9A9),
              ),
              child: Center(
                child: Text(
                  useCollars ? '25kg' : '20kg',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPlatesStack() {
    List<Widget> stack = [];

    for (int i = plates.length - 1; i >= 0; i--) {
      final plate = plates[i];
      for (int j = 0; j < plate.quantity; j++) {
        stack.add(
          _buildSinglePlate(plate.weight, plate.color),
        );
      }
    }

    return stack;
  }

  Widget _buildSinglePlate(double weight, String color) {
    // Reduz a altura da anilha conforme o peso (anilhas mais pesadas são maiores)
    // Tamanhos reduzidos para evitar overflow com muitas anilhas
    double heightFactor = weight / 25.0;
    double plateHeight = 40 + (heightFactor * 30); // Reduzido de 60 + 40
    double plateWidth = 8 + (heightFactor * 8); // Reduzido de 12 + 10

    // Define a cor da borda (mais escura para anilhas brancas)
    Color borderColor = weight == 5.0 ? Colors.black54 : Colors.black38;
    double borderWidth = weight == 5.0 ? 1.5 : 0.5;

    return Container(
      width: plateWidth,
      height: plateHeight,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: Color(PlateCalculator.getPlateHexColor(weight)),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: const Offset(0.5, 0.5),
          ),
        ],
      ),
      child: Center(
        child: RotatedBox(
          quarterTurns: 1,
          child: Text(
            weight.toStringAsFixed(1),
            style: TextStyle(
              color: weight == 5.0 ? Colors.black : Colors.white,
              fontSize: 6,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildPlatesList(BuildContext context) {
    if (plates.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          color: Colors.red[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red[700], size: 32),
                const SizedBox(height: 8),
                Text(
                  'Peso inválido!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Não é possível montar este peso com as anilhas disponíveis.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.red[700],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final totalPerSide = PlateCalculator.calculateTotalWeight(plates);
    final barTotalWeight = useCollars ? PlateCalculator.barWeight + PlateCalculator.collarWeight : PlateCalculator.barWeight;
    final totalWeight = barTotalWeight + (totalPerSide * 2);
    final difference = (totalWeight - this.totalWeight).abs();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anilhas por lado:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            ...plates.map((plate) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color(PlateCalculator.getPlateHexColor(plate.weight)),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black26),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${plate.weight.toStringAsFixed(1)}kg',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    Text(
                      'x${plate.quantity}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
            Divider(color: Colors.grey[400]),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total por lado:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${totalPerSide.toStringAsFixed(1)}kg',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Peso total montado:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                      ),
                ),
                Text(
                  '${totalWeight.toStringAsFixed(1)}kg',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: difference > 0.01 ? Colors.orange[700] : Colors.green[700],
                      ),
                ),
              ],
            ),
            if (difference > 0.01)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Diferença: ${difference.toStringAsFixed(2)}kg',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.orange[700],
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
