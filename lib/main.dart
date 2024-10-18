import 'package:flutter/material.dart';
import 'package:calculator/calccmd.dart';


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
                  // test_1();
                  testCases1();
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
