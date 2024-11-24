import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IMCCalculator(),
    );
  }
}

class IMCCalculator extends StatefulWidget {
  const IMCCalculator({super.key});

  @override
  _IMCCalculatorState createState() => _IMCCalculatorState();
}

class _IMCCalculatorState extends State<IMCCalculator> {
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  String _resultado = '';
  String _categoria = '';
  String? _generoSelecionado = '';

  String _calcularCategoria(double imc) {
    if (imc < 17) {
      return 'Muito abaixo do peso';
    } else if (imc >= 17 && imc < 18.5) {
      return 'Abaixo do peso';
    } else if (imc >= 18.5 && imc < 25) {
      return 'Peso normal';
    } else if (imc >= 25 && imc < 30) {
      return 'Acima do peso';
    } else if (imc >= 30 && imc < 35) {
      return 'Obesidade I';
    } else if (imc >= 35 && imc < 40) {
      return 'Obesidade II (severa)';
    } else {
      return 'Obesidade III (mórbida)';
    }
  }

  void _calcularIMC() {
    final double? peso = double.tryParse(_pesoController.text);
    final double? altura = double.tryParse(_alturaController.text);

    if (peso != null && altura != null && altura > 0) {
      final double imc = peso / (altura * altura);
      setState(() {
        _resultado = 'Seu IMC é ${imc.toStringAsFixed(2)}';
        _categoria = _calcularCategoria(imc);
      });
    } else {
      setState(() {
        _resultado = 'Por favor, insira valores válidos!';
        _categoria = '';
      });
    }
  }

  void _resetarCampos() {
    _pesoController.clear();
    _alturaController.clear();
    setState(() {
      _resultado = '';
      _categoria = '';
      _generoSelecionado = '';
    });
  }

  void _mostrarCategorias(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Categorias de Peso'),
          content: const Text(
            'Abaixo de 17: Muito abaixo do peso\n'
                'Entre 17 e 18,4: Abaixo do peso\n'
                'Entre 18,5 e 24,9: Peso normal\n'
                'Entre 25 e 29,9: Acima do peso\n'
                'Entre 30 e 34,9: Obesidade I\n'
                'Entre 35 e 39,9: Obesidade II (severa)\n'
                'Acima de 40: Obesidade III (mórbida)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _generoSelecionado = 'masculino';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: _generoSelecionado == 'masculino'
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/male.png',
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Masculino',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _generoSelecionado = 'feminino';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: _generoSelecionado == 'feminino'
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/female.png',
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Feminino',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pesoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Peso (kg)',
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextField(
                    controller: _alturaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Altura (m)',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    _resultado,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_resultado.isNotEmpty && _categoria.isNotEmpty)
                    const SizedBox(height: 10),
                  if (_categoria.isNotEmpty)
                    Text(
                      _categoria,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _mostrarCategorias(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
              ),
              child: const Text('Categorias'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calcularIMC,
              child: const Text('Calcular IMC'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetarCampos,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Resetar'),
            ),
          ],
        ),
      ),
    );
  }
}
