import 'dart:ffi';
import 'package:ffi/ffi.dart';

final class mpfr extends Struct {
  @Long()
  external int _mpfr_prec;
  @Int()
  external int _mpfr_sign;
  @Long()
  external int _mpfr_exp;
  external Pointer<Uint64> _mpfr_d;
}

// Definindo a estrutura do número complexo
final class ComplexNumber extends Struct {
  external mpfr _mpfr_re;
  external mpfr _mpfr_im;
}

// Carregar a biblioteca MPC
final DynamicLibrary mpcLib = DynamicLibrary.open('libmpc.so');

// Definir a função mpc_init2
typedef mpc_init2_native = Void Function(Pointer<ComplexNumber>, Long);
typedef mpc_init2_dart = void Function(Pointer<ComplexNumber>, int);

// Definir a função mpc_set_d_d
typedef mpc_set_d_d_native = Int Function(Pointer<ComplexNumber>, Double, Double, Int);
typedef mpc_set_d_d_dart = int Function(Pointer<ComplexNumber>, double, double, int);

// Definir a função mpc_add
typedef mpc_add_native = Int Function(Pointer<ComplexNumber>, Pointer<ComplexNumber>, Pointer<ComplexNumber>, Int);
typedef mpc_add_dart = int Function(Pointer<ComplexNumber>, Pointer<ComplexNumber>, Pointer<ComplexNumber>, int);

// Definir a função mpc_get_str
typedef mpc_get_str_native = Pointer<Utf8> Function(Int, Size, Pointer<ComplexNumber>, Int);
typedef mpc_get_str_dart = Pointer<Utf8> Function(int, int, Pointer<ComplexNumber>, int);

// Definir a função mpc_clear
typedef mpc_clear_native = Void Function(Pointer<ComplexNumber>);
typedef mpc_clear_dart = void Function(Pointer<ComplexNumber>);

// Funções nativas do MPC que serão utilizadas no Dart
final mpc_init2_dart mpc_init2 = mpcLib.lookupFunction<mpc_init2_native, mpc_init2_dart>('mpc_init2');
final mpc_set_d_d_dart mpc_set_d_d = mpcLib.lookupFunction<mpc_set_d_d_native, mpc_set_d_d_dart>('mpc_set_d_d');
final mpc_add_dart mpc_add = mpcLib.lookupFunction<mpc_add_native, mpc_add_dart>('mpc_add');
final mpc_get_str_dart mpc_get_str = mpcLib.lookupFunction<mpc_get_str_native, mpc_get_str_dart>('mpc_get_str');
final mpc_clear_dart mpc_clear = mpcLib.lookupFunction<mpc_clear_native, mpc_clear_dart>('mpc_clear');

// Função que cria um número complexo com precisão de 256 bits
Pointer<ComplexNumber> createComplexNumber(double real, double imag) {
  // Alocar memória para um número complexo
  final Pointer<ComplexNumber> complexNumber = calloc<ComplexNumber>();

  // Inicializar o número complexo
  mpc_init2(complexNumber, 64);

  // Definir o número complexo
  mpc_set_d_d(complexNumber, real, imag, 0);

  // Retornar o número complexo
  return complexNumber;
}

// Função para somar dois números complexos
Pointer<ComplexNumber> addComplexNumbers(Pointer<ComplexNumber> a, Pointer<ComplexNumber> b) {
  // Alocar memória para um número complexo
  final Pointer<ComplexNumber> result = calloc<ComplexNumber>();

  // Inicializar o número complexo
  mpc_init2(result, 64);

  // Somar os números complexos
  mpc_add(result, a, b, 0);

  // Retornar o número complexo
  return result;
}

// Função para imprimir um número complexo
String printComplexNumber(Pointer<ComplexNumber> complexNumber) {
  // Obter a representação em string do número complexo
  final Pointer<Utf8> str = mpc_get_str(10, 2, complexNumber, 0);

  // Imprimir a representação em string do número complexo
  print(str.toDartString());
  String resultado = str.toDartString();

  // Liberar a memória alocada para a representação em string do número complexo
  calloc.free(str);
  return resultado;
}
