import 'dart:ffi';
import 'package:ffi/ffi.dart';

// mpfr_rnd_t -> int
// mpfr_prec_t -> long

final class mpfr_t extends Struct {
  @Long()
  external int _mpfr_prec;
  @Int()
  external int _mpfr_sign;
  @Long()
  external int _mpfr_exp;
  external Pointer<Uint64> _mpfr_d;
}

// Carregar a biblioteca MPFR
final DynamicLibrary mpfrLib = DynamicLibrary.open('libmpfr.so');

// Definição da enumeração Round, equivalente a mpfr_rnd_t em C
class Round {
  static const int MPFR_RNDN = 0;
  static const int MPFR_RNDZ = 1;
  static const int MPFR_RNDU = 2;
  static const int MPFR_RNDD = 3;
  static const int MPFR_RNDA = 4;
  static const int MPFR_RNDF = 5;
  static const int MPFR_RNDNA = -1;
}

// Definir a função mpc_init2
typedef mpfr_init2_native = Void Function(Pointer<mpfr_t>, Long);
typedef mpfr_init2_dart = void Function(Pointer<mpfr_t>, int);

// Definir a função mpfr_clear
typedef mpfr_clear_native = Void Function(Pointer<mpfr_t>);
typedef mpfr_clear_dart = void Function(Pointer<mpfr_t>);

// Definir a função mpfr_set_ui
typedef mpfr_set_ui_native = Int Function(Pointer<mpfr_t>, UnsignedLong, Int);
typedef mpfr_set_ui_dart = int Function(Pointer<mpfr_t>, int, int);

// Definir a função mpfr_set_si
typedef mpfr_set_si_native = Int Function(Pointer<mpfr_t>, Long, Int);
typedef mpfr_set_si_dart = int Function(Pointer<mpfr_t>, int, int);

// Definir a função mpfr_set_flt
typedef mpfr_set_flt_native = Int Function(Pointer<mpfr_t>, Float, Int);
typedef mpfr_set_flt_dart = int Function(Pointer<mpfr_t>, double, int);

// Definir a função mpfr_set_d
typedef mpfr_set_d_native = Int Function(Pointer<mpfr_t>, Double, Int);
typedef mpfr_set_d_dart = int Function(Pointer<mpfr_t>, double, int);

// Definir a função mpfr_set
typedef mpfr_set_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_set_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);

// Definir a função mpfr_set_zero
typedef mpfr_set_zero_native = Int Function(Pointer<mpfr_t>, Int);
typedef mpfr_set_zero_dart = int Function(Pointer<mpfr_t>, int);

// Definir a função mpfr_add
typedef mpfr_add_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_add_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, int);

// Funções nativas do MPFR que serão utilizadas no Dart
final mpfr_init2_dart mpfr_init2 = mpfrLib.lookupFunction<mpfr_init2_native, mpfr_init2_dart>('mpfr_init2');
final mpfr_clear_dart mpfr_clear = mpfrLib.lookupFunction<mpfr_clear_native, mpfr_clear_dart>('mpfr_clear');
final mpfr_set_ui_dart mpfr_set_ui = mpfrLib.lookupFunction<mpfr_set_ui_native, mpfr_set_ui_dart>('mpfr_set_ui');
final mpfr_set_si_dart mpfr_set_si = mpfrLib.lookupFunction<mpfr_set_si_native, mpfr_set_si_dart>('mpfr_set_si');
final mpfr_set_flt_dart mpfr_set_flt = mpfrLib.lookupFunction<mpfr_set_flt_native, mpfr_set_flt_dart>('mpfr_set_flt');
final mpfr_set_d_dart mpfr_set_d = mpfrLib.lookupFunction<mpfr_set_d_native, mpfr_set_d_dart>('mpfr_set_d');
final mpfr_set_dart mpfr_set = mpfrLib.lookupFunction<mpfr_set_native, mpfr_set_dart>('mpfr_set');
final mpfr_set_zero_dart mpfr_set_zero = mpfrLib.lookupFunction<mpfr_set_zero_native, mpfr_set_zero_dart>('mpfr_set_zero');
final mpfr_add_dart mpfr_add = mpfrLib.lookupFunction<mpfr_add_native, mpfr_add_dart>('mpfr_add');
