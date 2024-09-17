import 'dart:ffi';
import 'package:ffi/ffi.dart';

// Carregar a biblioteca MPC
final DynamicLibrary mpc = DynamicLibrary.open('libmpc.so');

// Definição da enumeração Round
class Round {
  static const int MPC_RNDNN = 0;
  static const int MPC_RNDZN = 1;
  static const int MPC_RNDUN = 2;
  static const int MPC_RNDDN = 3;
  static const int MPC_RNDNA = 4;
  static const int MPC_RNDNZ = 5;
  static const int MPC_RNDNU = 6;
  static const int MPC_RNDDD = 7;
}

// Definição da estrutura MPCComplex
final class MPCComplex extends Struct {
  external Pointer<Void> real;
  external Pointer<Void> imag;

  // Função para inicializar a estrutura MPCComplex
  static void Function(Pointer<MPCComplex>, int) mpc_init2 = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Int32)>>('mpc_init2')
      .asFunction();

  // Função para definir um número complexo a partir de dois reais
  static void Function(Pointer<MPCComplex>, Pointer<Void>, Pointer<Void>, int) mpc_set_fr_fr = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<Void>, Pointer<Void>, Int32)>>('mpc_set_fr_fr')
      .asFunction();

  // Função para adicionar dois números complexos
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_add = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_add')
      .asFunction();

  // Função para subtrair dois números complexos
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_sub = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_sub')
      .asFunction();

  // Função para multiplicar dois números complexos
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_mul = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_mul')
      .asFunction();

  // Função para dividir dois números complexos
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_div = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_div')
      .asFunction();

  // Função para calcular o conjugado de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>) mpc_conj = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>)>>('mpc_conj')
      .asFunction();

  // Função para calcular o módulo de um número complexo
  static void Function(Pointer<Void>, Pointer<MPCComplex>, int) mpc_abs = mpc
      .lookup<NativeFunction<Void Function(Pointer<Void>, Pointer<MPCComplex>, Int32)>>('mpc_abs')
      .asFunction();

  // Função para calcular a fase de um número complexo
  static void Function(Pointer<Void>, Pointer<MPCComplex>, int) mpc_arg = mpc
      .lookup<NativeFunction<Void Function(Pointer<Void>, Pointer<MPCComplex>, Int32)>>('mpc_arg')
      .asFunction();

  // Função para calcular a exponencial de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_exp = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_exp')
      .asFunction();

  // Função para calcular o logaritmo natural de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_log = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_log')
      .asFunction();

  // Função para calcular a potência de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_pow = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_pow')
      .asFunction();

  // Função para calcular a raiz quadrada de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_sqrt = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_sqrt')
      .asFunction();

  // Função para calcular o seno de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_sin = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_sin')
      .asFunction();

  // Função para calcular o cosseno de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_cos = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_cos')
      .asFunction();

  // Função para calcular a tangente de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_tan = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_tan')
      .asFunction();

  // Função para calcular o arco seno de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_asin = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_asin')
      .asFunction();

  // Função para calcular o arco cosseno de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_acos = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_acos')
      .asFunction();

  // Função para calcular o arco tangente de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_atan = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_atan')
      .asFunction();

  // Função para calcular o seno hiperbólico de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_sinh = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_sinh')
      .asFunction();

  // Função para calcular o cosseno hiperbólico de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_cosh = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_cosh')
      .asFunction();

  // Função para calcular a tangente hiperbólica de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_tanh = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_tanh')
      .asFunction();

  // Função para calcular o arco seno hiperbólico de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_asinh = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_asinh')
      .asFunction();

  // Função para calcular o arco cosseno hiperbólico de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_acosh = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_acosh')
      .asFunction();

  // Função para calcular o arco tangente hiperbólico de um número complexo
  static void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, int) mpc_atanh = mpc
      .lookup<NativeFunction<Void Function(Pointer<MPCComplex>, Pointer<MPCComplex>, Int32)>>('mpc_atanh')
      .asFunction();
}

void main() {
  // Inicializa uma variável MPCComplex com precisão 100
  Pointer<MPCComplex> complex = calloc<MPCComplex>();
  MPCComplex.mpc_init2(complex, 100);

  // Define um número complexo a partir de dois reais
  Pointer<Void> real = calloc<Void>();
  Pointer<Void> imag = calloc<Void>();
  MPCComplex.mpc_set_fr_fr(complex, real, imag, Round.MPC_RNDNN);

  // Libera a memória alocada
  calloc.free(complex);
  calloc.free(real);
  calloc.free(imag);
}
