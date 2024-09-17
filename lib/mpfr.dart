import 'dart:ffi';
import 'package:ffi/ffi.dart';

// mpfr_rnd_t -> Int
// mpfr_prec_t -> Long

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
final mpfr_init2_dart mpfr_init2 = mpfrLib.lookupFunction<mpfr_init2_native, mpfr_init2_dart>('mpfr_init2');

// Definir a função mpfr_clear
typedef mpfr_clear_native = Void Function(Pointer<mpfr_t>);
typedef mpfr_clear_dart = void Function(Pointer<mpfr_t>);
final mpfr_clear_dart mpfr_clear = mpfrLib.lookupFunction<mpfr_clear_native, mpfr_clear_dart>('mpfr_clear');

// Definir a função mpfr_set_ui
typedef mpfr_set_ui_native = Int Function(Pointer<mpfr_t>, UnsignedLong, Int);
typedef mpfr_set_ui_dart = int Function(Pointer<mpfr_t>, int, int);
final mpfr_set_ui_dart mpfr_set_ui = mpfrLib.lookupFunction<mpfr_set_ui_native, mpfr_set_ui_dart>('mpfr_set_ui');

// Definir a função mpfr_set_si
typedef mpfr_set_si_native = Int Function(Pointer<mpfr_t>, Long, Int);
typedef mpfr_set_si_dart = int Function(Pointer<mpfr_t>, int, int);
final mpfr_set_si_dart mpfr_set_si = mpfrLib.lookupFunction<mpfr_set_si_native, mpfr_set_si_dart>('mpfr_set_si');

// Definir a função mpfr_set_flt
typedef mpfr_set_flt_native = Int Function(Pointer<mpfr_t>, Float, Int);
typedef mpfr_set_flt_dart = int Function(Pointer<mpfr_t>, double, int);
final mpfr_set_flt_dart mpfr_set_flt = mpfrLib.lookupFunction<mpfr_set_flt_native, mpfr_set_flt_dart>('mpfr_set_flt');

// Definir a função mpfr_set_d
typedef mpfr_set_d_native = Int Function(Pointer<mpfr_t>, Double, Int);
typedef mpfr_set_d_dart = int Function(Pointer<mpfr_t>, double, int);
final mpfr_set_d_dart mpfr_set_d = mpfrLib.lookupFunction<mpfr_set_d_native, mpfr_set_d_dart>('mpfr_set_d');

// Definir a função mpfr_set
typedef mpfr_set_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_set_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_set_dart mpfr_set = mpfrLib.lookupFunction<mpfr_set_native, mpfr_set_dart>('mpfr_set');

// Definir a função mpfr_set_zero
typedef mpfr_set_zero_native = Int Function(Pointer<mpfr_t>, Int);
typedef mpfr_set_zero_dart = int Function(Pointer<mpfr_t>, int);
final mpfr_set_zero_dart mpfr_set_zero = mpfrLib.lookupFunction<mpfr_set_zero_native, mpfr_set_zero_dart>('mpfr_set_zero');

// Definir a função mpfr_add
typedef mpfr_add_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_add_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_add_dart mpfr_add = mpfrLib.lookupFunction<mpfr_add_native, mpfr_add_dart>('mpfr_add');

// Definir a função mpfr_sub
typedef mpfr_sub_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_sub_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_sub_dart mpfr_sub = mpfrLib.lookupFunction<mpfr_sub_native, mpfr_sub_dart>('mpfr_sub');

// Definir a função mpfr_mul
typedef mpfr_mul_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_mul_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_mul_dart mpfr_mul = mpfrLib.lookupFunction<mpfr_mul_native, mpfr_mul_dart>('mpfr_mul');

// Definir a função mpfr_div
typedef mpfr_div_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_div_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_div_dart mpfr_div = mpfrLib.lookupFunction<mpfr_div_native, mpfr_div_dart>('mpfr_div');

// Definir a função mpfr_get_si
typedef mpfr_get_si_native = Long Function(Pointer<mpfr_t>, Int);
typedef mpfr_get_si_dart = int Function(Pointer<mpfr_t>, int);
final mpfr_get_si_dart mpfr_get_si = mpfrLib.lookupFunction<mpfr_get_si_native, mpfr_get_si_dart>('mpfr_get_si');

// Definir a função mpfr_get_ui
typedef mpfr_get_ui_native = UnsignedLong Function(Pointer<mpfr_t>, Int);
typedef mpfr_get_ui_dart = int Function(Pointer<mpfr_t>, int);
final mpfr_get_ui_dart mpfr_get_ui = mpfrLib.lookupFunction<mpfr_get_ui_native, mpfr_get_ui_dart>('mpfr_get_ui');

// Definir a função mpfr_get_flt
typedef mpfr_get_flt_native = Float Function(Pointer<mpfr_t>, Int);
typedef mpfr_get_flt_dart = double Function(Pointer<mpfr_t>, int);
final mpfr_get_flt_dart mpfr_get_flt = mpfrLib.lookupFunction<mpfr_get_flt_native, mpfr_get_flt_dart>('mpfr_get_flt');

// Definir a função mpfr_get_d
typedef mpfr_get_d_native = Double Function(Pointer<mpfr_t>, Int);
typedef mpfr_get_d_dart = double Function(Pointer<mpfr_t>, int);
final mpfr_get_d_dart mpfr_get_d = mpfrLib.lookupFunction<mpfr_get_d_native, mpfr_get_d_dart>('mpfr_get_d');

// Definir a função mpfr_const_pi
typedef mpfr_const_pi_native = Int Function(Pointer<mpfr_t>, Int);
typedef mpfr_const_pi_dart = int Function(Pointer<mpfr_t>, int);
final mpfr_const_pi_dart mpfr_const_pi = mpfrLib.lookupFunction<mpfr_const_pi_native, mpfr_const_pi_dart>('mpfr_const_pi');

// Definir a função mpfr_const_log2
typedef mpfr_const_log2_native = Int Function(Pointer<mpfr_t>, Int);
typedef mpfr_const_log2_dart = int Function(Pointer<mpfr_t>, int);
final mpfr_const_log2_dart mpfr_const_log2 = mpfrLib.lookupFunction<mpfr_const_log2_native, mpfr_const_log2_dart>('mpfr_const_log2');

// Definir a função mpfr_const_euler
typedef mpfr_const_euler_native = Int Function(Pointer<mpfr_t>, Int);
typedef mpfr_const_euler_dart = int Function(Pointer<mpfr_t>, int);
final mpfr_const_euler_dart mpfr_const_euler = mpfrLib.lookupFunction<mpfr_const_euler_native, mpfr_const_euler_dart>('mpfr_const_euler');

// Definir a função mpfr_const_catalan
typedef mpfr_const_catalan_native = Int Function(Pointer<mpfr_t>, Int);
typedef mpfr_const_catalan_dart = int Function(Pointer<mpfr_t>, int);
final mpfr_const_catalan_dart mpfr_const_catalan = mpfrLib.lookupFunction<mpfr_const_catalan_native, mpfr_const_catalan_dart>('mpfr_const_catalan');

// Definir a função mpfr_zero_p
typedef mpfr_zero_p_native = Int Function(Pointer<mpfr_t>);
typedef mpfr_zero_p_dart = int Function(Pointer<mpfr_t>);
final mpfr_zero_p_dart mpfr_zero_p = mpfrLib.lookupFunction<mpfr_zero_p_native, mpfr_zero_p_dart>('mpfr_zero_p');

// Definir a função mpfr_sgn
typedef mpfr_sgn_native = Int Function(Pointer<mpfr_t>);
typedef mpfr_sgn_dart = int Function(Pointer<mpfr_t>);
final mpfr_sgn_dart mpfr_sgn = mpfrLib.lookupFunction<mpfr_sgn_native, mpfr_sgn_dart>('mpfr_sgn');

// Definir a função mpfr_equal_p
typedef mpfr_equal_p_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>);
typedef mpfr_equal_p_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>);
final mpfr_equal_p_dart mpfr_equal_p = mpfrLib.lookupFunction<mpfr_equal_p_native, mpfr_equal_p_dart>('mpfr_equal_p');

// Definir a função mpfr_cmp
typedef mpfr_cmp_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>);
typedef mpfr_cmp_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>);
final mpfr_cmp_dart mpfr_cmp = mpfrLib.lookupFunction<mpfr_cmp_native, mpfr_cmp_dart>('mpfr_cmp');

// Definir a função mpfr_sqrt
typedef mpfr_sqrt_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_sqrt_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_sqrt_dart mpfr_sqrt = mpfrLib.lookupFunction<mpfr_sqrt_native, mpfr_sqrt_dart>('mpfr_sqrt');

// Definir a função mpfr_neg
typedef mpfr_neg_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_neg_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_neg_dart mpfr_neg = mpfrLib.lookupFunction<mpfr_neg_native, mpfr_neg_dart>('mpfr_neg');

// Definir a função mpfr_pow_si
typedef mpfr_pow_si_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Long, Int);
typedef mpfr_pow_si_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_pow_si_dart mpfr_pow_si = mpfrLib.lookupFunction<mpfr_pow_si_native, mpfr_pow_si_dart>('mpfr_pow_si');

// Definir a função mpfr_mul_si
typedef mpfr_mul_si_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Long, Int);
typedef mpfr_mul_si_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_mul_si_dart mpfr_mul_si = mpfrLib.lookupFunction<mpfr_mul_si_native, mpfr_mul_si_dart>('mpfr_mul_si');

// Definir a função mpfr_div_si
typedef mpfr_div_si_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Long, Int);
typedef mpfr_div_si_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_div_si_dart mpfr_div_si = mpfrLib.lookupFunction<mpfr_div_si_native, mpfr_div_si_dart>('mpfr_div_si');

// Definir a função mpfr_si_div
typedef mpfr_si_div_native = Int Function(Pointer<mpfr_t>, Long, Pointer<mpfr_t>, Int);
typedef mpfr_si_div_dart = int Function(Pointer<mpfr_t>, int, Pointer<mpfr_t>, int);
final mpfr_si_div_dart mpfr_si_div = mpfrLib.lookupFunction<mpfr_si_div_native, mpfr_si_div_dart>('mpfr_si_div');

// Definir a função mpfr_div_ui
typedef mpfr_div_ui_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, UnsignedLong, Int);
typedef mpfr_div_ui_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_div_ui_dart mpfr_div_ui = mpfrLib.lookupFunction<mpfr_div_ui_native, mpfr_div_ui_dart>('mpfr_div_ui');

// Definir a função mpfr_ui_div
typedef mpfr_ui_div_native = Int Function(Pointer<mpfr_t>, UnsignedLong, Pointer<mpfr_t>, Int);
typedef mpfr_ui_div_dart = int Function(Pointer<mpfr_t>, int, Pointer<mpfr_t>, int);
final mpfr_ui_div_dart mpfr_ui_div = mpfrLib.lookupFunction<mpfr_ui_div_native, mpfr_ui_div_dart>('mpfr_ui_div');

// Definir a função mpfr_integer_p
typedef mpfr_integer_p_native = Int Function(Pointer<mpfr_t>);
typedef mpfr_integer_p_dart = int Function(Pointer<mpfr_t>);
final mpfr_integer_p_dart mpfr_integer_p = mpfrLib.lookupFunction<mpfr_integer_p_native, mpfr_integer_p_dart>('mpfr_integer_p');

// Definir a função mpfr_underflow_p
typedef mpfr_underflow_p_native = Int Function();
typedef mpfr_underflow_p_dart = int Function();
final mpfr_underflow_p_dart mpfr_underflow_p = mpfrLib.lookupFunction<mpfr_underflow_p_native, mpfr_underflow_p_dart>('mpfr_underflow_p');

// Definir a função mpfr_overflow_p
typedef mpfr_overflow_p_native = Int Function();
typedef mpfr_overflow_p_dart = int Function();
final mpfr_overflow_p_dart mpfr_overflow_p = mpfrLib.lookupFunction<mpfr_overflow_p_native, mpfr_overflow_p_dart>('mpfr_overflow_p');
