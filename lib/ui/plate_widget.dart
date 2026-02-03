import 'package:flutter/material.dart';
import 'package:pwl_calc/logic/plate_calculator.dart';
import 'package:pwl_calc/ui/bar_visual.dart';
import 'package:pwl_calc/ui/input_weight.dart';

class PlateWidget extends StatefulWidget {
  const PlateWidget({super.key});

  @override
  State<PlateWidget> createState() => _PlateWidgetState();
}

class _PlateWidgetState extends State<PlateWidget> {
  double _selectedWeight = 60.0;
  bool _useCollars = false; // Estado das presilhas

  @override
  Widget build(BuildContext context) {
    // Passa useCollars ao calculatePlates
    final plates = PlateCalculator.calculatePlates(_selectedWeight, useCollars: _useCollars);

    return SingleChildScrollView(
      child: Column(
        children: [
          InputWeight(
            onWeightChanged: (weight, useCollars) {
              setState(() {
                _selectedWeight = weight;
                _useCollars = useCollars;
              });
            },
          ),
          BarVisual(
            plates: plates,
            totalWeight: _selectedWeight,
            useCollars: _useCollars,
          ),
        ],
      ),
    );
  }
}
