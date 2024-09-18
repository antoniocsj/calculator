import 'package:flutter/material.dart';
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'package:calculator/mpfr.dart';


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
  String resultado = '';
  String resultado2 = '';

  void test_add_real_numbers() {
    Real x = Real();
    Real y = Real();
    // x.setDouble(0.0000000000000001);
    // y.setDouble(0.0000000000000002);
    x.setString('0.00000000000000000000000000000000000000000000555');
    y.setString('0.00000000000000000000000000000000000000000000444');

    Real z = Real();
    z.add(x, y);

    resultado = z.getString();
    resultado2 = z.getDouble().toString();
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
