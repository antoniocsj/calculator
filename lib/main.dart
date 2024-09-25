import 'package:flutter/material.dart';
import 'package:calculator/mpfr.dart';
import 'package:calculator/mpc.dart';
import 'dart:async';

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

  void test_1() {
    Complex x = Complex.fromDouble(-3.6, 2.0);

    print('precision: ${x.precision}');

    Real realPart = x.getReal();
    print('real: ${realPart.getDouble()}');
    realPart.dispose();

    Real imaginaryPart = x.getImaginary();
    print('imag: ${imaginaryPart.getDouble()}');
    imaginaryPart.dispose();

    print('complex: ${x.getString()}');

    print('real: ${x.getRealDouble()}');
    print('imag: ${x.getImaginaryDouble()}');

    x.dispose();
  }

  void test_2() async {
    while (true) {
      // Real x = Real.fromDouble(3.6, 1000);
      Real x = Real.fromString('3.6', 10, 100000);
      // print('x: ${x.getDouble()}');
      // print('x: ${x.getString1()}');
      await Future.delayed(const Duration(milliseconds: 1));
      // x.dispose();
    }

    // Real x = Real.fromDouble(3.6, 64);
    // print('x: ${x.getDouble()}');
    // // x.dispose();
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
                  test_2();
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
