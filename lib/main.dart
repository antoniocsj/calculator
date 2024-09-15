import 'package:flutter/material.dart';
import 'dart:ffi' as ffi;
import 'mpc_bindings.dart';
import 'package:ffi/ffi.dart';

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

  void main() {
    // Criar dois números complexos (3 + 4i) e (1 + 2i)
    final complex1 = createComplexNumber(3.0, 4.0);
    final complex2 = createComplexNumber(1.0, 2.0);

    // Somar os números complexos
    final result = addComplexNumbers(complex1, complex2);

    // Imprimir o resultado
    resultado = printComplexNumber(result);

    // Liberar a memória alocada
    mpc_clear(complex1);
    mpc_clear(complex2);
    mpc_clear(result);

    if (complex1 != ffi.nullptr) {
      print('complex1 is not null');
      calloc.free(complex1);
    }

    if (complex2 != ffi.nullptr) {
      print('complex2 is not null');
      calloc.free(complex2);
    }

    if (result != ffi.nullptr) {
      print('result is not null');
      calloc.free(result);
    }
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
              'Somar',
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  main();
                });
              },
              child: const Text('Somar'),
            ),
            Text(resultado),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  resultado = '';
                });
              },
              child: const Text('Limpar'),
            ),
          ],
        ),
      ),
    );
  }
}
