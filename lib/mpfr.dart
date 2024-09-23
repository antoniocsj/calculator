import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:math' as math;

// Types in C vesus Types in FFI
// mpfr_rnd_t -> Int
// mpfr_prec_t -> Long
// mpfr_exp_t -> Long
// mpfr_sign_t -> Int
// mpfr_srcptr -> Pointer<mpfr_t>
// mpfr_ptr -> Pointer<mpfr_t>
// size_t -> UnsignedLong -> int

final class mpfr_t extends Struct {
  @Long()
  external int _mpfr_prec;
  @Int()
  external int _mpfr_sign;
  @Long()
  external int _mpfr_exp;
  external Pointer<UnsignedLong> _mpfr_d;
}

// Definição da enumeração Round (MPFR), equivalente a mpfr_rnd_t em C
class MPFRRound {
  static const int RNDN = 0;
  static const int RNDZ = 1;
  static const int RNDU = 2;
  static const int RNDD = 3;
  static const int RNDA = 4;
  static const int RNDF = 5;
  static const int RNDNA = -1;
}

// Carregar a biblioteca MPFR
final DynamicLibrary mpfrLib = DynamicLibrary.open('libmpfr.so');

// Definir a função mpc_init2
typedef mpfr_init2_native = Void Function(Pointer<mpfr_t>, Long);
typedef mpfr_init2_dart = void Function(Pointer<mpfr_t>, int);
final mpfr_init2_dart mpfr_init2 = mpfrLib.lookupFunction<mpfr_init2_native, mpfr_init2_dart>('mpfr_init2');

// Definir a função mpfr_clear
typedef mpfr_clear_native = Void Function(Pointer<mpfr_t>);
typedef mpfr_clear_dart = void Function(Pointer<mpfr_t>);
final mpfr_clear_dart mpfr_clear = mpfrLib.lookupFunction<mpfr_clear_native, mpfr_clear_dart>('mpfr_clear');

// Definir a função mpfr_set
typedef mpfr_set_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_set_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_set_dart mpfr_set = mpfrLib.lookupFunction<mpfr_set_native, mpfr_set_dart>('mpfr_set');

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

// Definir a função mpfr_set_zero
typedef mpfr_set_zero_native = Void Function(Pointer<mpfr_t>, Int);
typedef mpfr_set_zero_dart = void Function(Pointer<mpfr_t>, int);
final mpfr_set_zero_dart mpfr_set_zero = mpfrLib.lookupFunction<mpfr_set_zero_native, mpfr_set_zero_dart>('mpfr_set_zero');

// Definir a função mpfr_add
typedef mpfr_add_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_add_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_add_dart mpfr_add = mpfrLib.lookupFunction<mpfr_add_native, mpfr_add_dart>('mpfr_add');

// Definir a função mpfr_add_ui
typedef mpfr_add_ui_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, UnsignedLong, Int);
typedef mpfr_add_ui_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_add_ui_dart mpfr_add_ui = mpfrLib.lookupFunction<mpfr_add_ui_native, mpfr_add_ui_dart>('mpfr_add_ui');

// Definir a função mpfr_add_si
typedef mpfr_add_si_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Long, Int);
typedef mpfr_add_si_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_add_si_dart mpfr_add_si = mpfrLib.lookupFunction<mpfr_add_si_native, mpfr_add_si_dart>('mpfr_add_si');

// Definir a função mpfr_add_d
typedef mpfr_add_d_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Double, Int);
typedef mpfr_add_d_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, double, int);
final mpfr_add_d_dart mpfr_add_d = mpfrLib.lookupFunction<mpfr_add_d_native, mpfr_add_d_dart>('mpfr_add_d');

// Definir a função mpfr_sub
typedef mpfr_sub_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_sub_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_sub_dart mpfr_sub = mpfrLib.lookupFunction<mpfr_sub_native, mpfr_sub_dart>('mpfr_sub');

// Definir a função mpfr_sub_ui
typedef mpfr_sub_ui_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, UnsignedLong, Int);
typedef mpfr_sub_ui_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_sub_ui_dart mpfr_sub_ui = mpfrLib.lookupFunction<mpfr_sub_ui_native, mpfr_sub_ui_dart>('mpfr_sub_ui');

// Definir a função mpfr_sub_si
typedef mpfr_sub_si_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Long, Int);
typedef mpfr_sub_si_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_sub_si_dart mpfr_sub_si = mpfrLib.lookupFunction<mpfr_sub_si_native, mpfr_sub_si_dart>('mpfr_sub_si');

// Definir a função mpfr_sub_d
typedef mpfr_sub_d_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Double, Int);
typedef mpfr_sub_d_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, double, int);
final mpfr_sub_d_dart mpfr_sub_d = mpfrLib.lookupFunction<mpfr_sub_d_native, mpfr_sub_d_dart>('mpfr_sub_d');

// Definir a função mpfr_ui_sub
typedef mpfr_ui_sub_native = Int Function(Pointer<mpfr_t>, UnsignedLong, Pointer<mpfr_t>, Int);
typedef mpfr_ui_sub_dart = int Function(Pointer<mpfr_t>, int, Pointer<mpfr_t>, int);
final mpfr_ui_sub_dart mpfr_ui_sub = mpfrLib.lookupFunction<mpfr_ui_sub_native, mpfr_ui_sub_dart>('mpfr_ui_sub');

// Definir a função mpfr_si_sub
typedef mpfr_si_sub_native = Int Function(Pointer<mpfr_t>, Long, Pointer<mpfr_t>, Int);
typedef mpfr_si_sub_dart = int Function(Pointer<mpfr_t>, int, Pointer<mpfr_t>, int);
final mpfr_si_sub_dart mpfr_si_sub = mpfrLib.lookupFunction<mpfr_si_sub_native, mpfr_si_sub_dart>('mpfr_si_sub');

// Definir a função mpfr_d_sub
typedef mpfr_d_sub_native = Int Function(Pointer<mpfr_t>, Double, Pointer<mpfr_t>, Int);
typedef mpfr_d_sub_dart = int Function(Pointer<mpfr_t>, double, Pointer<mpfr_t>, int);
final mpfr_d_sub_dart mpfr_d_sub = mpfrLib.lookupFunction<mpfr_d_sub_native, mpfr_d_sub_dart>('mpfr_d_sub');

// Definir a função mpfr_mul
typedef mpfr_mul_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_mul_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_mul_dart mpfr_mul = mpfrLib.lookupFunction<mpfr_mul_native, mpfr_mul_dart>('mpfr_mul');

// Definir a função mpfr_mul_ui
typedef mpfr_mul_ui_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, UnsignedLong, Int);
typedef mpfr_mul_ui_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_mul_ui_dart mpfr_mul_ui = mpfrLib.lookupFunction<mpfr_mul_ui_native, mpfr_mul_ui_dart>('mpfr_mul_ui');

// Definir a função mpfr_mul_si
typedef mpfr_mul_si_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Long, Int);
typedef mpfr_mul_si_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_mul_si_dart mpfr_mul_si = mpfrLib.lookupFunction<mpfr_mul_si_native, mpfr_mul_si_dart>('mpfr_mul_si');

// Definir a função mpfr_mul_d
typedef mpfr_mul_d_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Double, Int);
typedef mpfr_mul_d_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, double, int);
final mpfr_mul_d_dart mpfr_mul_d = mpfrLib.lookupFunction<mpfr_mul_d_native, mpfr_mul_d_dart>('mpfr_mul_d');

// Definir a função mpfr_div
typedef mpfr_div_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_div_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_div_dart mpfr_div = mpfrLib.lookupFunction<mpfr_div_native, mpfr_div_dart>('mpfr_div');

// Definir a função mpfr_div_ui
typedef mpfr_div_ui_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, UnsignedLong, Int);
typedef mpfr_div_ui_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_div_ui_dart mpfr_div_ui = mpfrLib.lookupFunction<mpfr_div_ui_native, mpfr_div_ui_dart>('mpfr_div_ui');

// Definir a função mpfr_div_si
typedef mpfr_div_si_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Long, Int);
typedef mpfr_div_si_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_div_si_dart mpfr_div_si = mpfrLib.lookupFunction<mpfr_div_si_native, mpfr_div_si_dart>('mpfr_div_si');

// Definir a função mpfr_div_d
typedef mpfr_div_d_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Double, Int);
typedef mpfr_div_d_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, double, int);
final mpfr_div_d_dart mpfr_div_d = mpfrLib.lookupFunction<mpfr_div_d_native, mpfr_div_d_dart>('mpfr_div_d');

// Definir a função mpfr_ui_div
typedef mpfr_ui_div_native = Int Function(Pointer<mpfr_t>, UnsignedLong, Pointer<mpfr_t>, Int);
typedef mpfr_ui_div_dart = int Function(Pointer<mpfr_t>, int, Pointer<mpfr_t>, int);
final mpfr_ui_div_dart mpfr_ui_div = mpfrLib.lookupFunction<mpfr_ui_div_native, mpfr_ui_div_dart>('mpfr_ui_div');

// Definir a função mpfr_si_div
typedef mpfr_si_div_native = Int Function(Pointer<mpfr_t>, Long, Pointer<mpfr_t>, Int);
typedef mpfr_si_div_dart = int Function(Pointer<mpfr_t>, int, Pointer<mpfr_t>, int);
final mpfr_si_div_dart mpfr_si_div = mpfrLib.lookupFunction<mpfr_si_div_native, mpfr_si_div_dart>('mpfr_si_div');

// Definir a função mpfr_d_div
typedef mpfr_d_div_native = Int Function(Pointer<mpfr_t>, Double, Pointer<mpfr_t>, Int);
typedef mpfr_d_div_dart = int Function(Pointer<mpfr_t>, double, Pointer<mpfr_t>, int);
final mpfr_d_div_dart mpfr_d_div = mpfrLib.lookupFunction<mpfr_d_div_native, mpfr_d_div_dart>('mpfr_d_div');

// Definir a função mpfr_fmod
typedef mpfr_fmod_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_fmod_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_fmod_dart mpfr_fmod = mpfrLib.lookupFunction<mpfr_fmod_native, mpfr_fmod_dart>('mpfr_fmod');

// Definir a função mpfr_fmod_ui
typedef mpfr_fmod_ui_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, UnsignedLong, Int);
typedef mpfr_fmod_ui_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_fmod_ui_dart mpfr_fmod_ui = mpfrLib.lookupFunction<mpfr_fmod_ui_native, mpfr_fmod_ui_dart>('mpfr_fmod_ui');

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

// Definir a função mpfr_cmp_ui
typedef mpfr_cmp_ui_native = Int Function(Pointer<mpfr_t>, UnsignedLong);
typedef mpfr_cmp_ui_dart = int Function(Pointer<mpfr_t>, int);
final mpfr_cmp_ui_dart mpfr_cmp_ui = mpfrLib.lookupFunction<mpfr_cmp_ui_native, mpfr_cmp_ui_dart>('mpfr_cmp_ui');

// Definir a função mpfr_cmp_si
typedef mpfr_cmp_si_native = Int Function(Pointer<mpfr_t>, Long);
typedef mpfr_cmp_si_dart = int Function(Pointer<mpfr_t>, int);
final mpfr_cmp_si_dart mpfr_cmp_si = mpfrLib.lookupFunction<mpfr_cmp_si_native, mpfr_cmp_si_dart>('mpfr_cmp_si');

// Definir a função mpfr_cmp_d
typedef mpfr_cmp_d_native = Int Function(Pointer<mpfr_t>, Double);
typedef mpfr_cmp_d_dart = int Function(Pointer<mpfr_t>, double);
final mpfr_cmp_d_dart mpfr_cmp_d = mpfrLib.lookupFunction<mpfr_cmp_d_native, mpfr_cmp_d_dart>('mpfr_cmp_d');

// Definir a função mpfr_sqrt
typedef mpfr_sqrt_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_sqrt_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_sqrt_dart mpfr_sqrt = mpfrLib.lookupFunction<mpfr_sqrt_native, mpfr_sqrt_dart>('mpfr_sqrt');

// Definir a função mpfr_sqrt_ui
typedef mpfr_sqrt_ui_native = Int Function(Pointer<mpfr_t>, UnsignedLong, Int);
typedef mpfr_sqrt_ui_dart = int Function(Pointer<mpfr_t>, int, int);
final mpfr_sqrt_ui_dart mpfr_sqrt_ui = mpfrLib.lookupFunction<mpfr_sqrt_ui_native, mpfr_sqrt_ui_dart>('mpfr_sqrt_ui');

// Definir a função mpfr_neg
typedef mpfr_neg_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_neg_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_neg_dart mpfr_neg = mpfrLib.lookupFunction<mpfr_neg_native, mpfr_neg_dart>('mpfr_neg');

// Definir a função mpfr_pow
typedef mpfr_pow_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_pow_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_pow_dart mpfr_pow = mpfrLib.lookupFunction<mpfr_pow_native, mpfr_pow_dart>('mpfr_pow');

// Definir a função mpfr_pow_si
typedef mpfr_pow_si_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Long, Int);
typedef mpfr_pow_si_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_pow_si_dart mpfr_pow_si = mpfrLib.lookupFunction<mpfr_pow_si_native, mpfr_pow_si_dart>('mpfr_pow_si');

// Definir a função mpfr_pow_ui
typedef mpfr_pow_ui_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, UnsignedLong, Int);
typedef mpfr_pow_ui_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_pow_ui_dart mpfr_pow_ui = mpfrLib.lookupFunction<mpfr_pow_ui_native, mpfr_pow_ui_dart>('mpfr_pow_ui');

// Definir a função mpfr_gamma
typedef mpfr_gamma_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_gamma_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_gamma_dart mpfr_gamma = mpfrLib.lookupFunction<mpfr_gamma_native, mpfr_gamma_dart>('mpfr_gamma');

// Definir a função mpfr_underflow_p
typedef mpfr_underflow_p_native = Int Function();
typedef mpfr_underflow_p_dart = int Function();
final mpfr_underflow_p_dart mpfr_underflow_p = mpfrLib.lookupFunction<mpfr_underflow_p_native, mpfr_underflow_p_dart>('mpfr_underflow_p');

// Definir a função mpfr_overflow_p
typedef mpfr_overflow_p_native = Int Function();
typedef mpfr_overflow_p_dart = int Function();
final mpfr_overflow_p_dart mpfr_overflow_p = mpfrLib.lookupFunction<mpfr_overflow_p_native, mpfr_overflow_p_dart>('mpfr_overflow_p');

// Definir a função mpfr_divby0_p
typedef mpfr_divby0_p_native = Int Function();
typedef mpfr_divby0_p_dart = int Function();
final mpfr_divby0_p_dart mpfr_divby0_p = mpfrLib.lookupFunction<mpfr_divby0_p_native, mpfr_divby0_p_dart>('mpfr_divby0_p');

// Definir a função mpfr_nan_p
typedef mpfr_nan_p_native = Int Function(Pointer<mpfr_t>);
typedef mpfr_nan_p_dart = int Function(Pointer<mpfr_t>);
final mpfr_nan_p_dart mpfr_nan_p = mpfrLib.lookupFunction<mpfr_nan_p_native, mpfr_nan_p_dart>('mpfr_nan_p');

// Definir a função mpfr_inf_p
typedef mpfr_inf_p_native = Int Function(Pointer<mpfr_t>);
typedef mpfr_inf_p_dart = int Function(Pointer<mpfr_t>);
final mpfr_inf_p_dart mpfr_inf_p = mpfrLib.lookupFunction<mpfr_inf_p_native, mpfr_inf_p_dart>('mpfr_inf_p');

// Definir a função mpfr_number_p
typedef mpfr_number_p_native = Int Function(Pointer<mpfr_t>);
typedef mpfr_number_p_dart = int Function(Pointer<mpfr_t>);
final mpfr_number_p_dart mpfr_number_p = mpfrLib.lookupFunction<mpfr_number_p_native, mpfr_number_p_dart>('mpfr_number_p');

// Definir a função mpfr_integer_p
typedef mpfr_integer_p_native = Int Function(Pointer<mpfr_t>);
typedef mpfr_integer_p_dart = int Function(Pointer<mpfr_t>);
final mpfr_integer_p_dart mpfr_integer_p = mpfrLib.lookupFunction<mpfr_integer_p_native, mpfr_integer_p_dart>('mpfr_integer_p');

// Definir a função mpfr_zero_p
typedef mpfr_zero_p_native = Int Function(Pointer<mpfr_t>);
typedef mpfr_zero_p_dart = int Function(Pointer<mpfr_t>);
final mpfr_zero_p_dart mpfr_zero_p = mpfrLib.lookupFunction<mpfr_zero_p_native, mpfr_zero_p_dart>('mpfr_zero_p');

// Definir a função mpfr_regular_p
typedef mpfr_regular_p_native = Int Function(Pointer<mpfr_t>);
typedef mpfr_regular_p_dart = int Function(Pointer<mpfr_t>);
final mpfr_regular_p_dart mpfr_regular_p = mpfrLib.lookupFunction<mpfr_regular_p_native, mpfr_regular_p_dart>('mpfr_regular_p');

// Definir a função mpfr_get_str
typedef mpfr_get_str_native = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Long>, Int, Long, Pointer<mpfr_t>, Int);
typedef mpfr_get_str_dart = Pointer<Utf8> Function(Pointer<Utf8>, Pointer<Long>, int, int, Pointer<mpfr_t>, int);
final mpfr_get_str_dart mpfr_get_str = mpfrLib.lookupFunction<mpfr_get_str_native, mpfr_get_str_dart>('mpfr_get_str');

// Definir a função mpfr_set_str
typedef mpfr_set_str_native = Int Function(Pointer<mpfr_t>, Pointer<Utf8>, Int, Int);
typedef mpfr_set_str_dart = int Function(Pointer<mpfr_t>, Pointer<Utf8>, int, int);
final mpfr_set_str_dart mpfr_set_str = mpfrLib.lookupFunction<mpfr_set_str_native, mpfr_set_str_dart>('mpfr_set_str');

// Definir a função mpfr_free_str
typedef mpfr_free_str_native = Void Function(Pointer<Utf8>);
typedef mpfr_free_str_dart = void Function(Pointer<Utf8>);
final mpfr_free_str_dart mpfr_free_str = mpfrLib.lookupFunction<mpfr_free_str_native, mpfr_free_str_dart>('mpfr_free_str');

// Definir a função mpfr_exp
typedef mpfr_exp_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_exp_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_exp_dart mpfr_exp = mpfrLib.lookupFunction<mpfr_exp_native, mpfr_exp_dart>('mpfr_exp');

// Definir a função mpfr_exp2
typedef mpfr_exp2_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_exp2_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_exp2_dart mpfr_exp2 = mpfrLib.lookupFunction<mpfr_exp2_native, mpfr_exp2_dart>('mpfr_exp2');

// Definir a função mpfr_exp10
typedef mpfr_exp10_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_exp10_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_exp10_dart mpfr_exp10 = mpfrLib.lookupFunction<mpfr_exp10_native, mpfr_exp10_dart>('mpfr_exp10');

// Definir a função mpfr_log
typedef mpfr_log_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_log_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_log_dart mpfr_log = mpfrLib.lookupFunction<mpfr_log_native, mpfr_log_dart>('mpfr_log');

// Definir a função mpfr_log2
typedef mpfr_log2_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_log2_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_log2_dart mpfr_log2 = mpfrLib.lookupFunction<mpfr_log2_native, mpfr_log2_dart>('mpfr_log2');

// Definir a função mpfr_log10
typedef mpfr_log10_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_log10_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_log10_dart mpfr_log10 = mpfrLib.lookupFunction<mpfr_log10_native, mpfr_log10_dart>('mpfr_log10');

// Definir a função mpfr_sin
typedef mpfr_sin_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_sin_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_sin_dart mpfr_sin = mpfrLib.lookupFunction<mpfr_sin_native, mpfr_sin_dart>('mpfr_sin');

// Definir a função mpfr_cos
typedef mpfr_cos_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_cos_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_cos_dart mpfr_cos = mpfrLib.lookupFunction<mpfr_cos_native, mpfr_cos_dart>('mpfr_cos');

// Definir a função mpfr_tan
typedef mpfr_tan_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_tan_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_tan_dart mpfr_tan = mpfrLib.lookupFunction<mpfr_tan_native, mpfr_tan_dart>('mpfr_tan');

// Definir a função mpfr_sec
typedef mpfr_sec_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_sec_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_sec_dart mpfr_sec = mpfrLib.lookupFunction<mpfr_sec_native, mpfr_sec_dart>('mpfr_sec');

// Definir a função mpfr_csc
typedef mpfr_csc_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_csc_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_csc_dart mpfr_csc = mpfrLib.lookupFunction<mpfr_csc_native, mpfr_csc_dart>('mpfr_csc');

// Definir a função mpfr_cot
typedef mpfr_cot_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_cot_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_cot_dart mpfr_cot = mpfrLib.lookupFunction<mpfr_cot_native, mpfr_cot_dart>('mpfr_cot');

// Definir a função mpfr_asin
typedef mpfr_asin_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_asin_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_asin_dart mpfr_asin = mpfrLib.lookupFunction<mpfr_asin_native, mpfr_asin_dart>('mpfr_asin');

// Definir a função mpfr_acos
typedef mpfr_acos_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_acos_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_acos_dart mpfr_acos = mpfrLib.lookupFunction<mpfr_acos_native, mpfr_acos_dart>('mpfr_acos');

// Definir a função mpfr_atan
typedef mpfr_atan_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_atan_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_atan_dart mpfr_atan = mpfrLib.lookupFunction<mpfr_atan_native, mpfr_atan_dart>('mpfr_atan');

// Definir a função mpfr_sinh
typedef mpfr_sinh_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_sinh_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_sinh_dart mpfr_sinh = mpfrLib.lookupFunction<mpfr_sinh_native, mpfr_sinh_dart>('mpfr_sinh');

// Definir a função mpfr_cosh
typedef mpfr_cosh_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_cosh_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_cosh_dart mpfr_cosh = mpfrLib.lookupFunction<mpfr_cosh_native, mpfr_cosh_dart>('mpfr_cosh');

// Definir a função mpfr_tanh
typedef mpfr_tanh_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_tanh_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_tanh_dart mpfr_tanh = mpfrLib.lookupFunction<mpfr_tanh_native, mpfr_tanh_dart>('mpfr_tanh');

// Definir a função mpfr_asinh
typedef mpfr_asinh_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_asinh_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_asinh_dart mpfr_asinh = mpfrLib.lookupFunction<mpfr_asinh_native, mpfr_asinh_dart>('mpfr_asinh');

// Definir a função mpfr_acosh
typedef mpfr_acosh_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_acosh_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_acosh_dart mpfr_acosh = mpfrLib.lookupFunction<mpfr_acosh_native, mpfr_acosh_dart>('mpfr_acosh');

// Definir a função mpfr_atanh
typedef mpfr_atanh_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_atanh_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_atanh_dart mpfr_atanh = mpfrLib.lookupFunction<mpfr_atanh_native, mpfr_atanh_dart>('mpfr_atanh');

// Definir a função mpfr_abs
typedef mpfr_abs_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_abs_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_abs_dart mpfr_abs = mpfrLib.lookupFunction<mpfr_abs_native, mpfr_abs_dart>('mpfr_abs');

// Definir a função mpfr_ceil
typedef mpfr_ceil_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>);
typedef mpfr_ceil_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>);
final mpfr_ceil_dart mpfr_ceil = mpfrLib.lookupFunction<mpfr_ceil_native, mpfr_ceil_dart>('mpfr_ceil');

// Definir a função mpfr_floor
typedef mpfr_floor_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>);
typedef mpfr_floor_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>);
final mpfr_floor_dart mpfr_floor = mpfrLib.lookupFunction<mpfr_floor_native, mpfr_floor_dart>('mpfr_floor');

// Definir a função mpfr_trunc
typedef mpfr_trunc_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>);
typedef mpfr_trunc_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>);
final mpfr_trunc_dart mpfr_trunc = mpfrLib.lookupFunction<mpfr_trunc_native, mpfr_trunc_dart>('mpfr_trunc');

// Definir a função mpfr_round
typedef mpfr_round_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>);
typedef mpfr_round_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>);
final mpfr_round_dart mpfr_round = mpfrLib.lookupFunction<mpfr_round_native, mpfr_round_dart>('mpfr_round');

// Definir a função mpfr_rint
typedef mpfr_rint_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_rint_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_rint_dart mpfr_rint = mpfrLib.lookupFunction<mpfr_rint_native, mpfr_rint_dart>('mpfr_rint');

// Definir a função mpfr_frac
typedef mpfr_frac_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpfr_frac_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpfr_frac_dart mpfr_frac = mpfrLib.lookupFunction<mpfr_frac_native, mpfr_frac_dart>('mpfr_frac');

// Definir a função mpfr_root
typedef mpfr_root_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, UnsignedLong, Int);
typedef mpfr_root_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_root_dart mpfr_root = mpfrLib.lookupFunction<mpfr_root_native, mpfr_root_dart>('mpfr_root');

// Definir a função mpfr_rootn_ui
typedef mpfr_rootn_ui_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, UnsignedLong, Int);
typedef mpfr_rootn_ui_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_rootn_ui_dart mpfr_rootn_ui = mpfrLib.lookupFunction<mpfr_rootn_ui_native, mpfr_rootn_ui_dart>('mpfr_rootn_ui');

// Definir a função mpfr_rootn_si
typedef mpfr_rootn_si_native = Int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, Long, Int);
typedef mpfr_rootn_si_dart = int Function(Pointer<mpfr_t>, Pointer<mpfr_t>, int, int);
final mpfr_rootn_si_dart mpfr_rootn_si = mpfrLib.lookupFunction<mpfr_rootn_si_native, mpfr_rootn_si_dart>('mpfr_rootn_si');

// Definir a função mpfr_asprintf
typedef mpfr_asprintf_native = Int Function(Pointer<Pointer<Utf8>>, Pointer<Utf8>, Pointer<mpfr_t>);
typedef mpfr_asprintf_dart = int Function(Pointer<Pointer<Utf8>>, Pointer<Utf8>, Pointer<mpfr_t>);
final mpfr_asprintf_dart mpfr_asprintf = mpfrLib.lookupFunction<mpfr_asprintf_native, mpfr_asprintf_dart>('mpfr_asprintf');


// classe Real: Representa um número real com precisão arbitrária
class Real {
  // Ponteiro para a estrutura mpfr_t
  late Pointer<mpfr_t> _number;

  // Retorna um ponteiro para a estrutura mpfr_t
  Pointer<mpfr_t> getPointer(){
    return _number;
  }

  final int _precision; // precisão em bits

  // Getter para a precisão
  int get precision => _precision;

  // Obter a precisão em dígitos decimais
  int get precisionInDigits => _calulatePrecisionInDigits;

  // calcular a precisão em dígitos decimais a partir da precisão em bits.
  // fórmula usada: n_digits = floor(n_bits * log10(2))
  int get _calulatePrecisionInDigits {
    return (_precision * math.log(2) / math.log(10)).floor();
  }

  // calcular a precisão em bits a partir da precisão em dígitos decimais.
  // fórmula usada: n_bits = ceil(n_digits * log2(10))
  int get _calulatePrecisionInBits {
    return (precisionInDigits * math.log(10) / math.log(2)).ceil();
  }

  // calcular o número de dígitos a partir do número de bits e da base
  int _calculateDigits(int bits, int base) {
    if (base <= 1) {
      throw ArgumentError('Base must be greater than 1');
    }
    return (bits * math.log(2) / math.log(base)).floor();
  }

  // calcular o número de bits a partir do número de dígitos e da base
  int _calculateBits(int digits, int base) {
    if (base <= 1) {
      throw ArgumentError('Base must be greater than 1');
    }
    return (digits * math.log(base) / math.log(2)).ceil();
  }

  // Construtor
  Real(this._precision) {
    _number = calloc<mpfr_t>();
    mpfr_init2(_number, _precision);
  }

  // Construtor a partir de um double
  Real.fromDouble(double value, this._precision) {
    _number = calloc<mpfr_t>();
    mpfr_init2(_number, _precision);
    mpfr_set_d(_number, value, MPFRRound.RNDN);
  }

  // Construtor a partir de um inteiro com sinal
  Real.fromInt(int value, this._precision)  {
    _number = calloc<mpfr_t>();
    mpfr_init2(_number, _precision);
    mpfr_set_si(_number, value, MPFRRound.RNDN);
  }

  // Construtor a partir de um inteiro sem sinal
  Real.fromUInt(int value, this._precision) {
    _number = calloc<mpfr_t>();
    mpfr_init2(_number, _precision);
    mpfr_set_ui(_number, value, MPFRRound.RNDN);
  }

  // Construtor a partir de uma string
  Real.fromString(String value, int base, this._precision) {
    _number = calloc<mpfr_t>();
    mpfr_init2(_number, _precision);
    mpfr_set_str(_number, value.toNativeUtf8().cast<Utf8>(), base, MPFRRound.RNDN);
  }

  // Construtor a partir de outro número real
  Real.fromReal(Real value, this._precision) {
    _number = calloc<mpfr_t>();
    mpfr_init2(_number, value._precision);
    mpfr_set(_number, value._number, MPFRRound.RNDN);
  }

  // Destrutor
  void dispose() {
    mpfr_clear(_number);
    calloc.free(_number);
  }

  // Atribui um valor double ao número real
  void setDouble(double value, [int round = MPFRRound.RNDN]) {
    mpfr_set_d(_number, value, round);
  }

  // Atribui um valor float ao número real
  void setFloat(double value, [int round = MPFRRound.RNDN]) {
    mpfr_set_flt(_number, value, round);
  }

  // Atribui um valor inteiro com sinal ao número real
  void setInt(int value, [int round = MPFRRound.RNDN]) {
    mpfr_set_si(_number, value, round);
  }

  // Atribui um valor inteiro sem sinal ao número real
  void setUInt(int value, [int round = MPFRRound.RNDN]) {
    mpfr_set_ui(_number, value, round);
  }

  // Atribui um valor string ao número real
  void setString(String value, {int base = 10, int round = MPFRRound.RNDN}) {
    mpfr_set_str(_number, value.toNativeUtf8().cast<Utf8>(), base, round);
  }

  // Atribui um valor real ao número real
  void setReal(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_set(_number, value._number, round);
  }

  // Atribui o valor zero ao número real
  void setZero([int round = MPFRRound.RNDN]) {
    mpfr_set_zero(_number, round);
  }

  // Atribui o valor pi ao número real
  void setPi([int round = MPFRRound.RNDN]) {
    mpfr_const_pi(_number, round);
  }

  // Atribui o valor log2 ao número real
  void setLog2([int round = MPFRRound.RNDN]) {
    mpfr_const_log2(_number, round);
  }

  // Atribui o valor euler ao número real
  void setEuler([int round = MPFRRound.RNDN]) {
    mpfr_const_euler(_number, round);
  }

  // Atribui o valor catalan ao número real
  void setCatalan([int round = MPFRRound.RNDN]) {
    mpfr_const_catalan(_number, round);
  }

  // Atribui o valor tau ao número real
  void setTau([int round = MPFRRound.RNDN]) {
    mpfr_const_pi(_number, round);
    mpfr_mul_si(_number, _number, 2, round);
  }

  // Retorna o valor do número real como double
  double getDouble([int round = MPFRRound.RNDN]) {
    return mpfr_get_d(_number, round);
  }

  // Retorna o valor do número real como float
  double getFloat([int round = MPFRRound.RNDN]) {
    return mpfr_get_flt(_number, round);
  }

  // Retorna o valor do número real como inteiro com sinal
  int getInt([int round = MPFRRound.RNDN]) {
    return mpfr_get_si(_number, round);
  }

  // Retorna o valor do número real como inteiro sem sinal
  int getUInt([int round = MPFRRound.RNDN]) {
    return mpfr_get_ui(_number, round);
  }

  // Retorna o valor do número real como string
  // usa a função mpfr_get_str para obter a string
  String getString1({int base = 10, int numDigits = 0, int round = MPFRRound.RNDN}) {
    Pointer<Long> exp = calloc.allocate<Long>(1);
    Pointer<Utf8> str;
    str = mpfr_get_str(nullptr, exp, base, numDigits, _number, round);

    String result = str.toDartString();
    mpfr_free_str(str);
    calloc.free(exp);

    return result;
  }

  // Retorna o valor do número real como string.
  // usa a função mpfr_asprintf para obter a string
  String getString2({int numDigits = 0, int round = MPFRRound.RNDN}) {
    Pointer<Pointer<Utf8>> str = calloc.allocate<Pointer<Utf8>>(1);
    int nDigits; // número de dígitos decimais efetivos
    int maxNumDigits = _calculateDigits(_precision, 10);

    if (numDigits <= 0) {
      nDigits = 0;
    } else {
      print('Number of digits: $numDigits');
      nDigits = math.min(numDigits, maxNumDigits);
      print('Number of digits (effective): $nDigits');
    }

    Pointer<Utf8> template = '%.${nDigits}Rf'.toNativeUtf8(allocator: calloc);
    mpfr_asprintf(str, template, _number);
    String result = str.value.toDartString();
    calloc.free(str);
    calloc.free(template);

    return result;
  }

  String getString([int round = MPFRRound.RNDN]) {
    return getDouble(round).toString();
  }

  // Retorna true se o número real for zero
  bool isZero() {
    return mpfr_zero_p(_number) != 0;
  }

  // Retorna o sinal do número real
  int getSign() {
    return mpfr_sgn(_number);
  }

  // Retorna true se o número real for um inteiro
  bool isInteger() {
    return mpfr_integer_p(_number) != 0;
  }

  // Retorna true se o número real for um número regular
  bool isRegular() {
    return mpfr_regular_p(_number) != 0;
  }

  // Retorna true se o número real for um número finito
  bool isFinite() {
    return mpfr_number_p(_number) != 0;
  }

  // Retorna true se o número real for um número infinito
  bool isInfinity() {
    return mpfr_inf_p(_number) != 0;
  }

  // Retorna true se o número real for um número NaN
  bool isNaN() {
    return mpfr_nan_p(_number) != 0;
  }

  // Retorna true se o número real for um número normal
  bool isNormal() {
    return mpfr_number_p(_number) != 0;
  }

  // Testa se o número real é igual a outro número real
  bool isEqual(Real value) {
    return mpfr_equal_p(_number, value._number) != 0;
  }

  // Compara o número real com outro número real
  int cmp(Real value) {
    return mpfr_cmp(_number, value._number);
  }

  // Compara o número real com um inteiro sem sinal
  int cmpUInt(int value) {
    return mpfr_cmp_ui(_number, value);
  }

  // Compara o número real com um inteiro com sinal
  int cmpInt(int value) {
    return mpfr_cmp_si(_number, value);
  }

  // Compara o número real com um double
  int cmpDouble(double value) {
    return mpfr_cmp_d(_number, value);
  }

  // Calcula a soma de dois números reais
  void add(Real value1, Real value2, [int round = MPFRRound.RNDN]) {
    mpfr_add(_number, value1._number, value2._number, round);
  }

  // Calcula a soma de um número real com um inteiro com sinal
  void addInt(Real value, int num, [int round = MPFRRound.RNDN]) {
    mpfr_add_si(_number, value._number, num, round);
  }

  // Calcula a soma de um número real com um inteiro sem sinal
  void addUInt(Real value, int num, [int round = MPFRRound.RNDN]) {
    mpfr_add_ui(_number, value._number, num, round);
  }

  // Calcula a soma de um número real com um double
  void addDouble(Real value, double num, [int round = MPFRRound.RNDN]) {
    mpfr_add_d(_number, value._number, num, round);
  }

  // Calcula a subtração de dois números reais
  void sub(Real value1, Real value2, [int round = MPFRRound.RNDN]) {
    mpfr_sub(_number, value1._number, value2._number, round);
  }

  // Calcula a subtração de um número real com um inteiro com sinal
  void subInt(Real value, int num, [int round = MPFRRound.RNDN]) {
    mpfr_sub_si(_number, value._number, num, round);
  }

  // Calcula a subtração de um número real com um inteiro sem sinal
  void subUInt(Real value, int num, [int round = MPFRRound.RNDN]) {
    mpfr_sub_ui(_number, value._number, num, round);
  }

  // Calcula a subtração de um número real com um double
  void subDouble(Real value, double num, [int round = MPFRRound.RNDN]) {
    mpfr_sub_d(_number, value._number, num, round);
  }

  // Calcula a subtração de um inteiro com sinal com um número real
  void intSub(int num, Real value, [int round = MPFRRound.RNDN]) {
    mpfr_si_sub(_number, num, value._number, round);
  }

  // Calcula a subtração de um inteiro sem sinal com um número real
  void uintSub(int num, Real value, [int round = MPFRRound.RNDN]) {
    mpfr_ui_sub(_number, num, value._number, round);
  }

  // Calcula a subtração de um double com um número real
  void doubleSub(double num, Real value, [int round = MPFRRound.RNDN]) {
    mpfr_d_sub(_number, num, value._number, round);
  }

  // Calcula a multiplicação de dois números reais
  void mul(Real value1, Real value2, [int round = MPFRRound.RNDN]) {
    mpfr_mul(_number, value1._number, value2._number, round);
  }

  // Calcula a multiplicação de um número real com um inteiro com sinal
  void mulInt(Real value, int num, [int round = MPFRRound.RNDN]) {
    mpfr_mul_si(_number, value._number, num, round);
  }

  // Calcula a multiplicação de um número real com um inteiro sem sinal
  void mulUInt(Real value, int num, [int round = MPFRRound.RNDN]) {
    mpfr_mul_ui(_number, value._number, num, round);
  }

  // Calcula a multiplicação de um número real com um double
  void mulDouble(Real value, double num, [int round = MPFRRound.RNDN]) {
    mpfr_mul_d(_number, value._number, num, round);
  }

  // Calcula a divisão de dois números reais
  void div(Real value1, Real value2, [int round = MPFRRound.RNDN]) {
    mpfr_div(_number, value1._number, value2._number, round);
  }

  // Calcula a divisão de um número real com um inteiro com sinal
  void divInt(Real value, int num, [int round = MPFRRound.RNDN]) {
    mpfr_div_si(_number, value._number, num, round);
  }

  // Calcula a divisão de um número real com um inteiro sem sinal
  void divUInt(Real value, int num, [int round = MPFRRound.RNDN]) {
    mpfr_div_ui(_number, value._number, num, round);
  }

  // Calcula a divisão de um número real com um double
  void divDouble(Real value, double num, [int round = MPFRRound.RNDN]) {
    mpfr_div_d(_number, value._number, num, round);
  }

  // Calcula a divisão de um inteiro com sinal com um número real
  void intDiv(int num, Real value, [int round = MPFRRound.RNDN]) {
    mpfr_si_div(_number, num, value._number, round);
  }

  // Calcula a divisão de um inteiro sem sinal com um número real
  void uintDiv(int num, Real value, [int round = MPFRRound.RNDN]) {
    mpfr_ui_div(_number, num, value._number, round);
  }

  // Calcula a divisão de um double com um número real
  void doubleDiv(double num, Real value, [int round = MPFRRound.RNDN]) {
    mpfr_d_div(_number, num, value._number, round);
  }

  // Calcula o resto da divisão de dois números reais
  void mod(Real value1, Real value2, [int round = MPFRRound.RNDN]) {
    mpfr_fmod(_number, value1._number, value2._number, round);
  }

  // Atribui o oposto de um número ao número real
  void neg(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_neg(_number, value._number, round);
  }

  // Calcula a potência de um número real com outro número real
  void pow(Real value, Real exp, [int round = MPFRRound.RNDN]) {
    mpfr_pow(_number, value._number, exp._number, round);
  }

  // Calcula a potência de um número real com um inteiro com sinal
  void powInt(Real value, int exp, [int round = MPFRRound.RNDN]) {
    mpfr_pow_si(_number, value._number, exp, round);
  }

  // Calcula a potência de um número real com um inteiro sem sinal
  void powUInt(Real value, int exp, [int round = MPFRRound.RNDN]) {
    mpfr_pow_ui(_number, value._number, exp, round);
  }

  // Calcula a exponencial de um número real
  void exp(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_exp(_number, value._number, round);
  }

  // Calcula a exponencial de base 2 de um número real
  void exp2(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_exp2(_number, value._number, round);
  }

  // Calcula a exponencial de base 10 de um número real
  void exp10(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_exp10(_number, value._number, round);
  }

  // Calcula a raiz quadrada de um número real
  void sqrt(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_sqrt(_number, value._number, round);
  }

  // Calcula a raiz quadrada de um inteiro sem sinal
  void sqrtUInt(int value, [int round = MPFRRound.RNDN]) {
    mpfr_sqrt_ui(_number, value, round);
  }

  // Calcula o valor absoluto de um número real
  void abs(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_abs(_number, value._number, round);
  }

  // Calcula o valor do seno de um número real
  void sin(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_sin(_number, value._number, round);
  }

  // Calcula o valor do cosseno de um número real
  void cos(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_cos(_number, value._number, round);
  }

  // Calcula o valor da tangente de um número real
  void tan(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_tan(_number, value._number, round);
  }

  // Calcula o valor da secante de um número real
  void sec(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_sec(_number, value._number, round);
  }

  // Calcula o valor da cossecante de um número real
  void csc(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_csc(_number, value._number, round);
  }

  // Calcula o valor da cotangente de um número real
  void cot(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_cot(_number, value._number, round);
  }

  // Calcula o valor do arco seno de um número real
  void asin(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_asin(_number, value._number, round);
  }

  // Calcula o valor do arco cosseno de um número real
  void acos(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_acos(_number, value._number, round);
  }

  // Calcula o valor do arco tangente de um número real
  void atan(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_atan(_number, value._number, round);
  }

  // Calcula o valor da seno hiperbólico de um número real
  void sinh(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_sinh(_number, value._number, round);
  }

  // Calcula o valor do cosseno hiperbólico de um número real
  void cosh(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_cosh(_number, value._number, round);
  }

  // Calcula o valor da tangente hiperbólica de um número real
  void tanh(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_tanh(_number, value._number, round);
  }

  // Calcula o valor do arco seno hiperbólico de um número real
  void asinh(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_asinh(_number, value._number, round);
  }

  // Calcula o valor do arco cosseno hiperbólico de um número real
  void acosh(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_acosh(_number, value._number, round);
  }

  // Calcula o valor do arco tangente hiperbólico de um número real
  void atanh(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_atanh(_number, value._number, round);
  }

  // Calcula o valor do logaritmo natural de um número real
  void log(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_log(_number, value._number, round);
  }

  // Calcula o valor do logaritmo de base 2 de um número real
  void log2(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_log2(_number, value._number, round);
  }

  // Calcula o valor do logaritmo de base 10 de um número real
  void log10(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_log10(_number, value._number, round);
  }

  // Calcula o valor do fatorial de um número real
  void gamma(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_gamma(_number, value._number, round);
  }

  // Calcula a raiz de um número real
  void root(Real value, int n, [int round = MPFRRound.RNDN]) {
    mpfr_root(_number, value._number, n, round);
  }

  // Calcula a raiz de um número real
  void rootUInt(Real value, int n, [int round = MPFRRound.RNDN]) {
    mpfr_rootn_ui(_number, value._number, n, round);
  }

  // Calcula a raiz de um número real
  void rootInt(Real value, int n, [int round = MPFRRound.RNDN]) {
    mpfr_rootn_si(_number, value._number, n, round);
  }

  // Arredonda o número real para cima
  void ceil([int round = MPFRRound.RNDN]) {
    mpfr_ceil(_number, _number);
  }

  // Arredonda o número real para baixo
  void floor([int round = MPFRRound.RNDN]) {
    mpfr_floor(_number, _number);
  }

  // Trunca o número real
  void trunc([int round = MPFRRound.RNDN]) {
    mpfr_trunc(_number, _number);
  }

  // Arredonda o número real
  void round([int round = MPFRRound.RNDN]) {
    mpfr_round(_number, _number);
  }

  // Arredonda o número real para o inteiro mais próximo
  void rint([int round = MPFRRound.RNDN]) {
    mpfr_rint(_number, _number, round);
  }

  // Calcula a parte fracionária de um número real
  void frac(Real value, [int round = MPFRRound.RNDN]) {
    mpfr_frac(_number, value._number, round);
  }

  // Retorna true se houver divisão por zero
  bool isDivByZero() {
    return mpfr_divby0_p() != 0;
  }

  // Retorna true se houver overflow
  bool isOverflow() {
    return mpfr_overflow_p() != 0;
  }

  // Retorna true se houver underflow
  bool isUnderflow() {
    return mpfr_underflow_p() != 0;
  }

}
