import 'dart:ffi';
import 'package:ffi/ffi.dart';

// Carregar a biblioteca MPFR
final DynamicLibrary mpfr = DynamicLibrary.open('libmpfr.so');

// Definição da enumeração Round
class Round {
  static const int NEAREST = 0;
  static const int ZERO = 1;
  static const int UP = 2;
  static const int DOWN = 3;
  static const int AWAY = 4;
  static const int FAITHFUL = 5;
  static const int NEARESTAWAY = 6;
}

// Definição da estrutura Precision
final class Precision extends Struct {
  @Long()
  external int value;
}

// Definição da estrutura Real
final class Real extends Struct {
  external Pointer<Precision> prec;

  // Função para inicializar a estrutura Real
  static void Function(Pointer<Real>, int) mpfr_init2 = mpfr
      .lookup<NativeFunction<Void Function(Pointer<Real>, Int32)>>('mpfr_init2')
      .asFunction();

  // Função para definir um inteiro sem sinal
  static int Function(Pointer<Real>, int, int) mpfr_set_ui = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Uint64, Int32)>>('mpfr_set_ui')
      .asFunction();

  // Função para definir um inteiro com sinal
  static int Function(Pointer<Real>, int, int) mpfr_set_si = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Int64, Int32)>>('mpfr_set_si')
      .asFunction();

  // Função para definir um float
  static int Function(Pointer<Real>, double, int) mpfr_set_flt = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Float, Int32)>>('mpfr_set_flt')
      .asFunction();

  // Função para definir um double
  static int Function(Pointer<Real>, double, int) mpfr_set_d = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Double, Int32)>>('mpfr_set_d')
      .asFunction();

  // Função para definir um Real
  static int Function(Pointer<Real>, Pointer<Real>, int) mpfr_set = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Pointer<Real>, Int32)>>('mpfr_set')
      .asFunction();

  // Função para definir zero
  static int Function(Pointer<Real>, int) mpfr_set_zero = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Int32)>>('mpfr_set_zero')
      .asFunction();

  // Função para adicionar
  static int Function(Pointer<Real>, Pointer<Real>, Pointer<Real>, int) mpfr_add = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Pointer<Real>, Pointer<Real>, Int32)>>('mpfr_add')
      .asFunction();

  // Função para subtrair
  static int Function(Pointer<Real>, Pointer<Real>, Pointer<Real>, int) mpfr_sub = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Pointer<Real>, Pointer<Real>, Int32)>>('mpfr_sub')
      .asFunction();

  // Função para multiplicar
  static int Function(Pointer<Real>, Pointer<Real>, Pointer<Real>, int) mpfr_mul = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Pointer<Real>, Pointer<Real>, Int32)>>('mpfr_mul')
      .asFunction();

  // Função para dividir
  static int Function(Pointer<Real>, Pointer<Real>, Pointer<Real>, int) mpfr_div = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Pointer<Real>, Pointer<Real>, Int32)>>('mpfr_div')
      .asFunction();

  // Função para obter inteiro com sinal
  static int Function(Pointer<Real>, int) mpfr_get_si = mpfr
      .lookup<NativeFunction<Int64 Function(Pointer<Real>, Int32)>>('mpfr_get_si')
      .asFunction();

  // Função para obter inteiro sem sinal
  static int Function(Pointer<Real>, int) mpfr_get_ui = mpfr
      .lookup<NativeFunction<Uint64 Function(Pointer<Real>, Int32)>>('mpfr_get_ui')
      .asFunction();

  // Função para obter float
  static double Function(Pointer<Real>, int) mpfr_get_flt = mpfr
      .lookup<NativeFunction<Float Function(Pointer<Real>, Int32)>>('mpfr_get_flt')
      .asFunction();

  // Função para obter double
  static double Function(Pointer<Real>, int) mpfr_get_d = mpfr
      .lookup<NativeFunction<Double Function(Pointer<Real>, Int32)>>('mpfr_get_d')
      .asFunction();

  // Função para definir pi
  static int Function(Pointer<Real>, int) mpfr_const_pi = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Int32)>>('mpfr_const_pi')
      .asFunction();

  // Função para definir log2
  static int Function(Pointer<Real>, int) mpfr_const_log2 = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Int32)>>('mpfr_const_log2')
      .asFunction();

  // Função para definir euler
  static int Function(Pointer<Real>, int) mpfr_const_euler = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Int32)>>('mpfr_const_euler')
      .asFunction();

  // Função para definir catalan
  static int Function(Pointer<Real>, int) mpfr_const_catalan = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Int32)>>('mpfr_const_catalan')
      .asFunction();

  // Função para verificar se é zero
  static int Function(Pointer<Real>) mpfr_zero_p = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>)>>('mpfr_zero_p')
      .asFunction();

  // Função para obter sinal
  static int Function(Pointer<Real>) mpfr_sgn = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>)>>('mpfr_sgn')
      .asFunction();

  // Função para verificar igualdade
  static int Function(Pointer<Real>, Pointer<Real>) mpfr_equal_p = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Pointer<Real>)>>('mpfr_equal_p')
      .asFunction();

  // Função para comparar
  static int Function(Pointer<Real>, Pointer<Real>) mpfr_cmp = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Pointer<Real>)>>('mpfr_cmp')
      .asFunction();

  // Função para raiz quadrada
  static int Function(Pointer<Real>, Pointer<Real>, int) mpfr_sqrt = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Pointer<Real>, Int32)>>('mpfr_sqrt')
      .asFunction();

  // Função para negar
  static int Function(Pointer<Real>, Pointer<Real>, int) mpfr_neg = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Pointer<Real>, Int32)>>('mpfr_neg')
      .asFunction();

  // Função para potência com inteiro com sinal
  static int Function(Pointer<Real>, Pointer<Real>, int, int) mpfr_pow_si = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Pointer<Real>, Int64, Int32)>>('mpfr_pow_si')
      .asFunction();

  // Função para multiplicar por inteiro com sinal
  static int Function(Pointer<Real>, Pointer<Real>, int, int) mpfr_mul_si = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Pointer<Real>, Int64, Int32)>>('mpfr_mul_si')
      .asFunction();

  // Função para dividir por inteiro com sinal
  static int Function(Pointer<Real>, Pointer<Real>, int, int) mpfr_div_si = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Pointer<Real>, Int64, Int32)>>('mpfr_div_si')
      .asFunction();

  // Função para dividir inteiro com sinal
  static int Function(int, Pointer<Real>, int) mpfr_si_div = mpfr
      .lookup<NativeFunction<Int32 Function(Int64, Pointer<Real>, Int32)>>('mpfr_si_div')
      .asFunction();

  // Função para dividir por inteiro sem sinal
  static int Function(Pointer<Real>, Pointer<Real>, int, int) mpfr_div_ui = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>, Pointer<Real>, Uint64, Int32)>>('mpfr_div_ui')
      .asFunction();

  // Função para dividir inteiro sem sinal
  static int Function(int, Pointer<Real>, int) mpfr_ui_div = mpfr
      .lookup<NativeFunction<Int32 Function(Uint64, Pointer<Real>, Int32)>>('mpfr_ui_div')
      .asFunction();

  // Função para verificar se é inteiro
  static int Function(Pointer<Real>) mpfr_integer_p = mpfr
      .lookup<NativeFunction<Int32 Function(Pointer<Real>)>>('mpfr_integer_p')
      .asFunction();

  // Função para verificar underflow
  static int Function() mpfr_underflow_p = mpfr
      .lookup<NativeFunction<Int32 Function()>>('mpfr_underflow_p')
      .asFunction();

  // Função para verificar overflow
  static int Function() mpfr_overflow_p = mpfr
      .lookup<NativeFunction<Int32 Function()>>('mpfr_overflow_p')
      .asFunction();
}

void main() {
  // Inicializa uma variável Real com precisão 100
  Pointer<Real> real = calloc<Real>();
  Real.mpfr_init2(real, 100);

  // Define um valor inteiro sem sinal
  Real.mpfr_set_ui(real, 42, Round.NEAREST);

  // Libera a memória alocada
  calloc.free(real);
}
