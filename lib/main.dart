import 'package:flutter/material.dart';
import 'package:calculator/mpfr.dart';
import 'package:calculator/mpc.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String numberX = '';
  String numberY = '';
  String numberZ = '';
  String resultado = '';
  String resultado2 = '';

  void test_add_real_numbers() {
    Complex x = Complex.fromDouble(-3.6, 2.0);

    print('real: ${x.getReal().getDouble()}');
    print('imag: ${x.getImaginary().getDouble()}');
    print('complex: ${x.getString(numDigits: 3)}');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Testes',
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  test_add_real_numbers();
                });
              },
              child: const Text('Calcular'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  resultado = '';
                });
              },
              child: const Text('Limpar'),
            ),
            Text(resultado),
            Text(resultado2),
          ],
        ),
      ),
    );
  }
}
