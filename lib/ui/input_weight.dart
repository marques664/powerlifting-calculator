import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputWeight extends StatefulWidget {
  final Function(double, bool) onWeightChanged; // Agora recebe peso E presilhas

  const InputWeight({
    super.key,
    required this.onWeightChanged,
  });

  @override
  State<InputWeight> createState() => _InputWeightState();
}

class _InputWeightState extends State<InputWeight> {
  final TextEditingController _controller = TextEditingController();
  double _currentWeight = 60.0;
  bool _useCollars = false; // Toggle para presilhas de competição

  @override
  void initState() {
    super.initState();
    _controller.text = _formatWeight(_currentWeight);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateWeight(double weight) {
    // Validação: peso deve ser não-negativo e múltiplo de 0.5
    if (weight < 0) return;

    // Arredonda para o múltiplo de 0.5 mais próximo
    double roundedWeight = (weight * 2).round() / 2;

    setState(() {
      _currentWeight = roundedWeight;
      _controller.text = _formatWeight(roundedWeight);
      widget.onWeightChanged(roundedWeight, _useCollars);
    });
  }

  /// Formata o peso com até 1 casa decimal, removendo .0 se for inteiro
  String _formatWeight(double weight) {
    if (weight == weight.toInt()) {
      return weight.toInt().toString();
    }
    return weight.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Peso desejado',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType:  TextInputType.numberWithOptions(decimal: true, signed: false),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*[.,]?\d*$'),
                      ),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixText: 'kg',
                      hintText: 'Ex: 152,5 ou 160',
                      helperText: 'Incrementos de 0,5kg (aceita vírgula ou ponto)',
                      helperMaxLines: 2,
                    ),
                    onChanged: (value) {
                      if (value.isEmpty) {
                        // Campo vazio, não atualiza
                        return;
                      }
                      try {
                        // Substitui vírgula por ponto para aceitar ambos os separadores
                        String normalizedValue = value.replaceAll(',', '.');
                        double weight = double.parse(normalizedValue);
                        if (weight >= 0) {
                          _updateWeight(weight);
                        }
                      } catch (e) {
                        // Valor inválido, ignora
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Toggle para presilhas de competição
            Card(
              color: _useCollars ? Colors.red[50] : Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _useCollars ? 'Modo Competição' : 'Modo Academia',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: _useCollars ? Colors.red[700] : Colors.blue[700],
                                ),
                          ),
                          Text(
                            _useCollars
                                ? 'Barra: 20kg + 2 presilhas (2×2,5kg) = 25kg'
                                : 'Barra: 20kg (sem presilhas)',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _useCollars,
                      activeThumbColor: Colors.red[700],
                      onChanged: (value) {
                        setState(() {
                          _useCollars = value;
                          // Notifica a mudança de presilhas
                          widget.onWeightChanged(_currentWeight, _useCollars);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Botões rápidos com padding
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildQuickButton(75),
                  const SizedBox(width: 8),
                  _buildQuickButton(125),
                  const SizedBox(width: 8),
                  _buildQuickButton(175),
                  const SizedBox(width: 8),
                  _buildQuickButton(200),
                  const SizedBox(width: 8),
                  _buildQuickButton(225),
                  const SizedBox(width: 8),
                  _buildQuickButton(275),
                  const SizedBox(width: 8),
                  _buildQuickButton(300),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton(double weight) {
    return ElevatedButton(
      onPressed: () => _updateWeight(weight),
      style: ElevatedButton.styleFrom(
        backgroundColor: _currentWeight == weight
            ? Theme.of(context).primaryColor
            : Colors.grey[300],
      ),
      child: Text(
        '${_formatWeight(weight)}kg',
        style: TextStyle(
          color: _currentWeight == weight ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
