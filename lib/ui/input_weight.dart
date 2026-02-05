import 'package:flutter/material.dart';
import 'dart:async';

class InputWeight extends StatefulWidget {
  final Function(double, bool) onWeightChanged; // Recebe peso E presilhas

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
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.text = _formatWeight(_currentWeight);
  }


  @override
  void dispose() {
    _debounce?.cancel();
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

  /// Formata o peso com até 2 casas decimais quando necessário, removendo zeros desnecessários
  String _formatWeight(double weight) {
    if (weight == weight.toInt()) {
      // Se é um inteiro, mostra sem casas decimais
      return weight.toInt().toString();
    }
    // Formata com 2 casas decimais e remove zeros desnecessários do final
    String formatted = weight.toStringAsFixed(2);
    // Remove o zero final se existir (ex: 1.20 -> 1.2)
    if (formatted.endsWith('0') && formatted.contains('.')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
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
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixText: 'kg',
                        hintText: 'Ex: 152,5 ou 160',
                        helperText: 'Ou use os botões abaixo',
                        helperMaxLines: 2,
                      ),
                      onChanged: (value) {
                        // Cancela o debounce anterior
                        _debounce?.cancel();
                        
                        // Cria um novo timer de debounce
                        _debounce = Timer(const Duration(milliseconds: 1000), () {
                          if (value.isEmpty) {
                            return;
                          }
                          try {
                            String normalizedValue = value.replaceAll(',', '.');
                            double weight = double.parse(normalizedValue);
                            if (weight >= 0) {
                              _updateWeight(weight);
                            }
                          } catch (e) {
                            // Valor inválido, ignora
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Botões de ajuste fino
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botão -2.5
                  ElevatedButton(
                    onPressed: () => _updateWeight(_currentWeight - 2.5),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Text(
                      '-2,5',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Botão -0.5
                  ElevatedButton(
                    onPressed: () => _updateWeight(_currentWeight - 0.5),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Text(
                      '-0,5',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Botão +0.5
                  ElevatedButton(
                    onPressed: () => _updateWeight(_currentWeight + 0.5),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Text(
                      '+0,5',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Botão +2.5
                  ElevatedButton(
                    onPressed: () => _updateWeight(_currentWeight + 2.5),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Text(
                      '+2,5',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Toggle para presilhas de competição
              Card(
                color: _useCollars ? const Color(0xFF3A1F1F) : const Color(0xFF2A2A2A),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _useCollars ? 'Com presilhas' : 'Sem presilhas',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: _useCollars ? Colors.red[300] : Colors.grey[300],
                                  ),
                            ),
                            Text(
                              _useCollars
                                  ? 'Barra: 20kg + 2 presilhas = 25kg'
                                  : 'Barra: 20kg (sem presilhas)',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[500],
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _useCollars,
                        activeThumbColor: Colors.red[400],
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
