import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:calculator/mpfr.dart';

// Types in C vesus Types in FFI versus Types in Dart
// mpfr_rnd_t -> Int -> MPFRRound -> Int
// mpc_rnd_t -> Int -> MPCRound -> int
// mpfr_prec_t -> Long -> int
// mpfr_exp_t -> Long -> int
// mpfr_sign_t -> Int -> int
// mpfr_srcptr -> Pointer<mpfr_t>
// mpfr_ptr -> Pointer<mpfr_t>
// mpc_ptr -> Pointer<mpc_t>
// mpc_srcptr -> Pointer<mpc_t>
// size_t -> UnsignedLong -> int

// Definindo a estrutura do número complexo
final class mpc_t extends Struct {
  external mpfr_t _mpfr_re;
  external mpfr_t _mpfr_im;
}

// Definição da enumeração Round (MPC), equivalente a mpc_rnd_t em C
class MPCRound {
  static const int MPC_RNDNN = (MPFRRound.RNDN + (MPFRRound.RNDN << 4));
  static const int MPC_RNDNZ = (MPFRRound.RNDN + (MPFRRound.RNDZ << 4));
  static const int MPC_RNDNU = (MPFRRound.RNDN + (MPFRRound.RNDU << 4));
  static const int MPC_RNDND = (MPFRRound.RNDN + (MPFRRound.RNDD << 4));
  static const int MPC_RNDNA = (MPFRRound.RNDN + (MPFRRound.RNDA << 4));
  static const int MPC_RNDZN = (MPFRRound.RNDZ + (MPFRRound.RNDN << 4));
  static const int MPC_RNDZZ = (MPFRRound.RNDZ + (MPFRRound.RNDZ << 4));
  static const int MPC_RNDZU = (MPFRRound.RNDZ + (MPFRRound.RNDU << 4));
  static const int MPC_RNDZD = (MPFRRound.RNDZ + (MPFRRound.RNDD << 4));
  static const int MPC_RNDZA = (MPFRRound.RNDZ + (MPFRRound.RNDA << 4));
  static const int MPC_RNDUN = (MPFRRound.RNDU + (MPFRRound.RNDN << 4));
  static const int MPC_RNDUZ = (MPFRRound.RNDU + (MPFRRound.RNDZ << 4));
  static const int MPC_RNDUU = (MPFRRound.RNDU + (MPFRRound.RNDU << 4));
  static const int MPC_RNDUD = (MPFRRound.RNDU + (MPFRRound.RNDD << 4));
  static const int MPC_RNDUA = (MPFRRound.RNDU + (MPFRRound.RNDA << 4));
  static const int MPC_RNDDN = (MPFRRound.RNDD + (MPFRRound.RNDN << 4));
  static const int MPC_RNDDZ = (MPFRRound.RNDD + (MPFRRound.RNDZ << 4));
  static const int MPC_RNDDU = (MPFRRound.RNDD + (MPFRRound.RNDU << 4));
  static const int MPC_RNDDD = (MPFRRound.RNDD + (MPFRRound.RNDD << 4));
  static const int MPC_RNDDA = (MPFRRound.RNDD + (MPFRRound.RNDA << 4));
  static const int MPC_RNDAN = (MPFRRound.RNDA + (MPFRRound.RNDN << 4));
  static const int MPC_RNDAZ = (MPFRRound.RNDA + (MPFRRound.RNDZ << 4));
  static const int MPC_RNDAU = (MPFRRound.RNDA + (MPFRRound.RNDU << 4));
  static const int MPC_RNDAD = (MPFRRound.RNDA + (MPFRRound.RNDD << 4));
  static const int MPC_RNDAA = (MPFRRound.RNDA + (MPFRRound.RNDA << 4));

  static int getRealPart(int mode) {
    return mode & 0x0F;
  }

  static int getImaginaryPart(int mode) {
    return mode >> 4;
  }
}

class MPCInexact {
  static int inexPos(int inex) {
    if (inex < 0) {
      return 2;
    } else if (inex == 0) {
      return 0;
    } else {
      return 1;
    }
  }

  static int inexNeg(int inex) {
    if (inex == 2) {
      return -1;
    } else if (inex == 0) {
      return 0;
    } else {
      return 1;
    }
  }

  static int inex(int inexRe, int inexIm) {
    return inexPos(inexRe) | (inexPos(inexIm) << 2);
  }

  static int inexRe(int inex) {
    return inexNeg(inex & 3);
  }

  static int inexIm(int inex) {
    return inexNeg(inex >> 2);
  }

  static int inex12(int inex1, int inex2) {
    return inex1 | (inex2 << 4);
  }

  static int inex1(int inex) {
    return inex & 15;
  }

  static int inex2(int inex) {
    return inex >> 4;
  }
}

// Carregar a biblioteca MPC
final DynamicLibrary mpcLib = DynamicLibrary.open('libmpc.so');

// Definir a função mpc_abs
typedef mpc_abs_native = Int Function(Pointer<mpfr_t>, Pointer<mpc_t>, Int);
typedef mpc_abs_dart = int Function(Pointer<mpfr_t>, Pointer<mpc_t>, int);
final mpc_abs_dart mpc_abs = mpcLib.lookupFunction<mpc_abs_native, mpc_abs_dart>('mpc_abs');

// Definir a função mpc_arg
typedef mpc_arg_native = Int Function(Pointer<mpfr_t>, Pointer<mpc_t>, Int);
typedef mpc_arg_dart = int Function(Pointer<mpfr_t>, Pointer<mpc_t>, int);
final mpc_arg_dart mpc_arg = mpcLib.lookupFunction<mpc_arg_native, mpc_arg_dart>('mpc_arg');

// Definir a função mpc_init2
typedef mpc_init2_native = Void Function(Pointer<mpc_t>, Long);
typedef mpc_init2_dart = void Function(Pointer<mpc_t>, int);
final mpc_init2_dart mpc_init2 = mpcLib.lookupFunction<mpc_init2_native, mpc_init2_dart>('mpc_init2');

// Definir a função mpc_clear
typedef mpc_clear_native = Void Function(Pointer<mpc_t>);
typedef mpc_clear_dart = void Function(Pointer<mpc_t>);
final mpc_clear_dart mpc_clear = mpcLib.lookupFunction<mpc_clear_native, mpc_clear_dart>('mpc_clear');

// Definir a função mpc_set_prec
typedef mpc_set_prec_native = Void Function(Pointer<mpc_t>, Long);
typedef mpc_set_prec_dart = void Function(Pointer<mpc_t>, int);
final mpc_set_prec_dart mpc_set_prec = mpcLib.lookupFunction<mpc_set_prec_native, mpc_set_prec_dart>('mpc_set_prec');

// Definir a função mpc_set
typedef mpc_set_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_set_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_set_dart mpc_set = mpcLib.lookupFunction<mpc_set_native, mpc_set_dart>('mpc_set');

// Definir a função mpc_set_ui_ui
typedef mpc_set_ui_ui_native = Int Function(Pointer<mpc_t>, UnsignedLong, UnsignedLong, Int);
typedef mpc_set_ui_ui_dart = int Function(Pointer<mpc_t>, int, int, int);
final mpc_set_ui_ui_dart mpc_set_ui_ui = mpcLib.lookupFunction<mpc_set_ui_ui_native, mpc_set_ui_ui_dart>('mpc_set_ui_ui');

// Definir a função mpc_set_si_si
typedef mpc_set_si_si_native = Int Function(Pointer<mpc_t>, Long, Long, Int);
typedef mpc_set_si_si_dart = int Function(Pointer<mpc_t>, int, int, int);
final mpc_set_si_si_dart mpc_set_si_si = mpcLib.lookupFunction<mpc_set_si_si_native, mpc_set_si_si_dart>('mpc_set_si_si');

// Definir a função mpc_set_d_d
typedef mpc_set_d_d_native = Int Function(Pointer<mpc_t>, Double, Double, Int);
typedef mpc_set_d_d_dart = int Function(Pointer<mpc_t>, double, double, int);
final mpc_set_d_d_dart mpc_set_d_d = mpcLib.lookupFunction<mpc_set_d_d_native, mpc_set_d_d_dart>('mpc_set_d_d');

// Definir a função mpc_set_si
typedef mpc_set_si_native = Int Function(Pointer<mpc_t>, Long, Int);
typedef mpc_set_si_dart = int Function(Pointer<mpc_t>, int, int);
final mpc_set_si_dart mpc_set_si = mpcLib.lookupFunction<mpc_set_si_native, mpc_set_si_dart>('mpc_set_si');

// Definir a função mpc_set_ui
typedef mpc_set_ui_native = Int Function(Pointer<mpc_t>, UnsignedLong, Int);
typedef mpc_set_ui_dart = int Function(Pointer<mpc_t>, int, int);
final mpc_set_ui_dart mpc_set_ui = mpcLib.lookupFunction<mpc_set_ui_native, mpc_set_ui_dart>('mpc_set_ui');

// Definir a função mpc_set_d
typedef mpc_set_d_native = Int Function(Pointer<mpc_t>, Double, Int);
typedef mpc_set_d_dart = int Function(Pointer<mpc_t>, double, int);
final mpc_set_d_dart mpc_set_d = mpcLib.lookupFunction<mpc_set_d_native, mpc_set_d_dart>('mpc_set_d');

// Definir a função mpc_set_fr_fr
typedef mpc_set_fr_fr_native = Int Function(Pointer<mpc_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, Int);
typedef mpc_set_fr_fr_dart = int Function(Pointer<mpc_t>, Pointer<mpfr_t>, Pointer<mpfr_t>, int);
final mpc_set_fr_fr_dart mpc_set_fr_fr = mpcLib.lookupFunction<mpc_set_fr_fr_native, mpc_set_fr_fr_dart>('mpc_set_fr_fr');

// Definir a função mpc_set_fr
typedef mpc_set_fr_native = Int Function(Pointer<mpc_t>, Pointer<mpfr_t>, Int);
typedef mpc_set_fr_dart = int Function(Pointer<mpc_t>, Pointer<mpfr_t>, int);
final mpc_set_fr_dart mpc_set_fr = mpcLib.lookupFunction<mpc_set_fr_native, mpc_set_fr_dart>('mpc_set_fr');

// Definir a função mpc_get_str
typedef mpc_get_str_native = Pointer<Utf8> Function(Int, UnsignedLong, Pointer<mpc_t>, Int);
typedef mpc_get_str_dart = Pointer<Utf8> Function(int, int, Pointer<mpc_t>, int);
final mpc_get_str_dart mpc_get_str = mpcLib.lookupFunction<mpc_get_str_native, mpc_get_str_dart>('mpc_get_str');

// Definir a função mpc_add
typedef mpc_add_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_add_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_add_dart mpc_add = mpcLib.lookupFunction<mpc_add_native, mpc_add_dart>('mpc_add');

// Definir a função mpc_add_fr
typedef mpc_add_fr_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpfr_t>, Int);
typedef mpc_add_fr_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpfr_t>, int);
final mpc_add_fr_dart mpc_add_fr = mpcLib.lookupFunction<mpc_add_fr_native, mpc_add_fr_dart>('mpc_add_fr');

// Definir a função mpc_add_ui
typedef mpc_add_ui_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, UnsignedLong, Int);
typedef mpc_add_ui_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int, int);
final mpc_add_ui_dart mpc_add_ui = mpcLib.lookupFunction<mpc_add_ui_native, mpc_add_ui_dart>('mpc_add_ui');

// Definir a função mpc_sub
typedef mpc_sub_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_sub_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_sub_dart mpc_sub = mpcLib.lookupFunction<mpc_sub_native, mpc_sub_dart>('mpc_sub');

// Definir a função mpc_sub_fr
typedef mpc_sub_fr_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpfr_t>, Int);
typedef mpc_sub_fr_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpfr_t>, int);
final mpc_sub_fr_dart mpc_sub_fr = mpcLib.lookupFunction<mpc_sub_fr_native, mpc_sub_fr_dart>('mpc_sub_fr');

// Definir a função mpc_sub_ui
typedef mpc_sub_ui_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, UnsignedLong, Int);
typedef mpc_sub_ui_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int, int);
final mpc_sub_ui_dart mpc_sub_ui = mpcLib.lookupFunction<mpc_sub_ui_native, mpc_sub_ui_dart>('mpc_sub_ui');

// Definir a função mpc_fr_sub
typedef mpc_fr_sub_native = Int Function(Pointer<mpc_t>, Pointer<mpfr_t>, Pointer<mpc_t>, Int);
typedef mpc_fr_sub_dart = int Function(Pointer<mpc_t>, Pointer<mpfr_t>, Pointer<mpc_t>, int);
final mpc_fr_sub_dart mpc_fr_sub = mpcLib.lookupFunction<mpc_fr_sub_native, mpc_fr_sub_dart>('mpc_fr_sub');

// Definir a função mpc_ui_sub
typedef mpc_ui_sub_native = Int Function(Pointer<mpc_t>, UnsignedLong, Pointer<mpc_t>, Int);
typedef mpc_ui_sub_dart = int Function(Pointer<mpc_t>, int, Pointer<mpc_t>, int);
final mpc_ui_sub_dart mpc_ui_sub = mpcLib.lookupFunction<mpc_ui_sub_native, mpc_ui_sub_dart>('mpc_ui_sub');

// Definir a função mpc_ui_ui_sub
typedef mpc_ui_ui_sub_native = Int Function(Pointer<mpc_t>, UnsignedLong, UnsignedLong, Pointer<mpc_t>, Int);
typedef mpc_ui_ui_sub_dart = int Function(Pointer<mpc_t>, int, int, Pointer<mpc_t>, int);
final mpc_ui_ui_sub_dart mpc_ui_ui_sub = mpcLib.lookupFunction<mpc_ui_ui_sub_native, mpc_ui_ui_sub_dart>('mpc_ui_ui_sub');

// Definir a função mpc_neg
typedef mpc_neg_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_neg_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_neg_dart mpc_neg = mpcLib.lookupFunction<mpc_neg_native, mpc_neg_dart>('mpc_neg');

// Definir a função mpc_mul
typedef mpc_mul_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_mul_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_mul_dart mpc_mul = mpcLib.lookupFunction<mpc_mul_native, mpc_mul_dart>('mpc_mul');

// Definir a função mpc_mul_fr
typedef mpc_mul_fr_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpfr_t>, Int);
typedef mpc_mul_fr_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpfr_t>, int);
final mpc_mul_fr_dart mpc_mul_fr = mpcLib.lookupFunction<mpc_mul_fr_native, mpc_mul_fr_dart>('mpc_mul_fr');

// Definir a função mpc_mul_ui
typedef mpc_mul_ui_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, UnsignedLong, Int);
typedef mpc_mul_ui_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int, int);
final mpc_mul_ui_dart mpc_mul_ui = mpcLib.lookupFunction<mpc_mul_ui_native, mpc_mul_ui_dart>('mpc_mul_ui');

// Definir a função mpc_mul_si
typedef mpc_mul_si_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Long, Int);
typedef mpc_mul_si_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int, int);
final mpc_mul_si_dart mpc_mul_si = mpcLib.lookupFunction<mpc_mul_si_native, mpc_mul_si_dart>('mpc_mul_si');

// Definir a função mpc_div
typedef mpc_div_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_div_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_div_dart mpc_div = mpcLib.lookupFunction<mpc_div_native, mpc_div_dart>('mpc_div');

// Definir a função mpc_div_fr
typedef mpc_div_fr_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpfr_t>, Int);
typedef mpc_div_fr_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpfr_t>, int);
final mpc_div_fr_dart mpc_div_fr = mpcLib.lookupFunction<mpc_div_fr_native, mpc_div_fr_dart>('mpc_div_fr');

// Definir a função mpc_div_ui
typedef mpc_div_ui_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, UnsignedLong, Int);
typedef mpc_div_ui_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int, int);
final mpc_div_ui_dart mpc_div_ui = mpcLib.lookupFunction<mpc_div_ui_native, mpc_div_ui_dart>('mpc_div_ui');

// Definir a função mpc_ui_div
typedef mpc_ui_div_native = Int Function(Pointer<mpc_t>, UnsignedLong, Pointer<mpc_t>, Int);
typedef mpc_ui_div_dart = int Function(Pointer<mpc_t>, int, Pointer<mpc_t>, int);
final mpc_ui_div_dart mpc_ui_div = mpcLib.lookupFunction<mpc_ui_div_native, mpc_ui_div_dart>('mpc_ui_div');

// Definir a função mpc_fr_div
typedef mpc_fr_div_native = Int Function(Pointer<mpc_t>, Pointer<mpfr_t>, Pointer<mpc_t>, Int);
typedef mpc_fr_div_dart = int Function(Pointer<mpc_t>, Pointer<mpfr_t>, Pointer<mpc_t>, int);
final mpc_fr_div_dart mpc_fr_div = mpcLib.lookupFunction<mpc_fr_div_native, mpc_fr_div_dart>('mpc_fr_div');

// Definir a função mpc_sqrt
typedef mpc_sqrt_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_sqrt_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_sqrt_dart mpc_sqrt = mpcLib.lookupFunction<mpc_sqrt_native, mpc_sqrt_dart>('mpc_sqrt');

// Definir a função mpc_pow
typedef mpc_pow_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_pow_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_pow_dart mpc_pow = mpcLib.lookupFunction<mpc_pow_native, mpc_pow_dart>('mpc_pow');

// Definir a função mpc_pow_ui
typedef mpc_pow_ui_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, UnsignedLong, Int);
typedef mpc_pow_ui_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int, int);
final mpc_pow_ui_dart mpc_pow_ui = mpcLib.lookupFunction<mpc_pow_ui_native, mpc_pow_ui_dart>('mpc_pow_ui');

// Definir a função mpc_pow_si
typedef mpc_pow_si_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Long, Int);
typedef mpc_pow_si_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int, int);
final mpc_pow_si_dart mpc_pow_si = mpcLib.lookupFunction<mpc_pow_si_native, mpc_pow_si_dart>('mpc_pow_si');

// Definir a função mpc_pow_fr
typedef mpc_pow_fr_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpfr_t>, Int);
typedef mpc_pow_fr_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, Pointer<mpfr_t>, int);
final mpc_pow_fr_dart mpc_pow_fr = mpcLib.lookupFunction<mpc_pow_fr_native, mpc_pow_fr_dart>('mpc_pow_fr');

// Definir a função mpc_pow_d
typedef mpc_pow_d_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Double, Int);
typedef mpc_pow_d_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, double, int);
final mpc_pow_d_dart mpc_pow_d = mpcLib.lookupFunction<mpc_pow_d_native, mpc_pow_d_dart>('mpc_pow_d');

// Definir a função mpc_exp
typedef mpc_exp_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_exp_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_exp_dart mpc_exp = mpcLib.lookupFunction<mpc_exp_native, mpc_exp_dart>('mpc_exp');

// Definir a função mpc_log
typedef mpc_log_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_log_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_log_dart mpc_log = mpcLib.lookupFunction<mpc_log_native, mpc_log_dart>('mpc_log');

// Definir a função mpc_log10
typedef mpc_log10_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_log10_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_log10_dart mpc_log10 = mpcLib.lookupFunction<mpc_log10_native, mpc_log10_dart>('mpc_log10');

// Definir a função mpc_sin
typedef mpc_sin_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_sin_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_sin_dart mpc_sin = mpcLib.lookupFunction<mpc_sin_native, mpc_sin_dart>('mpc_sin');

// Definir a função mpc_cos
typedef mpc_cos_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_cos_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_cos_dart mpc_cos = mpcLib.lookupFunction<mpc_cos_native, mpc_cos_dart>('mpc_cos');

// Definir a função mpc_tan
typedef mpc_tan_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_tan_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_tan_dart mpc_tan = mpcLib.lookupFunction<mpc_tan_native, mpc_tan_dart>('mpc_tan');

// Definir a função mpc_sinh
typedef mpc_sinh_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_sinh_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_sinh_dart mpc_sinh = mpcLib.lookupFunction<mpc_sinh_native, mpc_sinh_dart>('mpc_sinh');

// Definir a função mpc_cosh
typedef mpc_cosh_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_cosh_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_cosh_dart mpc_cosh = mpcLib.lookupFunction<mpc_cosh_native, mpc_cosh_dart>('mpc_cosh');

// Definir a função mpc_tanh
typedef mpc_tanh_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_tanh_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_tanh_dart mpc_tanh = mpcLib.lookupFunction<mpc_tanh_native, mpc_tanh_dart>('mpc_tanh');

// Definir a função mpc_asin
typedef mpc_asin_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_asin_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_asin_dart mpc_asin = mpcLib.lookupFunction<mpc_asin_native, mpc_asin_dart>('mpc_asin');

// Definir a função mpc_acos
typedef mpc_acos_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_acos_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_acos_dart mpc_acos = mpcLib.lookupFunction<mpc_acos_native, mpc_acos_dart>('mpc_acos');

// Definir a função mpc_atan
typedef mpc_atan_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_atan_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_atan_dart mpc_atan = mpcLib.lookupFunction<mpc_atan_native, mpc_atan_dart>('mpc_atan');

// Definir a função mpc_asinh
typedef mpc_asinh_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_asinh_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_asinh_dart mpc_asinh = mpcLib.lookupFunction<mpc_asinh_native, mpc_asinh_dart>('mpc_asinh');

// Definir a função mpc_acosh
typedef mpc_acosh_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_acosh_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_acosh_dart mpc_acosh = mpcLib.lookupFunction<mpc_acosh_native, mpc_acosh_dart>('mpc_acosh');

// Definir a função mpc_atanh
typedef mpc_atanh_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_atanh_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_atanh_dart mpc_atanh = mpcLib.lookupFunction<mpc_atanh_native, mpc_atanh_dart>('mpc_atanh');

// Definir a função mpc_cmp
typedef mpc_cmp_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_cmp_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_cmp_dart mpc_cmp = mpcLib.lookupFunction<mpc_cmp_native, mpc_cmp_dart>('mpc_cmp');

// Definir a função mpc_cmp_si_si
typedef mpc_cmp_si_si_native = Int Function(Pointer<mpc_t>, Long, Long);
typedef mpc_cmp_si_si_dart = int Function(Pointer<mpc_t>, int, int);
final mpc_cmp_si_si_dart mpc_cmp_si_si = mpcLib.lookupFunction<mpc_cmp_si_si_native, mpc_cmp_si_si_dart>('mpc_cmp_si_si');

// Definir a função mpc_cmp_si
typedef mpc_cmp_si_native = Int Function(Pointer<mpc_t>, Long);
typedef mpc_cmp_si_dart = int Function(Pointer<mpc_t>, int);
final mpc_cmp_si_dart mpc_cmp_si = mpcLib.lookupFunction<mpc_cmp_si_native, mpc_cmp_si_dart>('mpc_cmp_si');

// Definir a função mpc_cmp_abs
typedef mpc_cmp_abs_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>);
typedef mpc_cmp_abs_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>);
final mpc_cmp_abs_dart mpc_cmp_abs = mpcLib.lookupFunction<mpc_cmp_abs_native, mpc_cmp_abs_dart>('mpc_cmp_abs');

// Definir a função mpc_real
typedef mpc_real_native = Int Function(Pointer<mpfr_t>, Pointer<mpc_t>, Int);
typedef mpc_real_dart = int Function(Pointer<mpfr_t>, Pointer<mpc_t>, int);
final mpc_real_dart mpc_real = mpcLib.lookupFunction<mpc_real_native, mpc_real_dart>('mpc_real');

// Definir a função mpc_imag
typedef mpc_imag_native = Int Function(Pointer<mpfr_t>, Pointer<mpc_t>, Int);
typedef mpc_imag_dart = int Function(Pointer<mpfr_t>, Pointer<mpc_t>, int);
final mpc_imag_dart mpc_imag = mpcLib.lookupFunction<mpc_imag_native, mpc_imag_dart>('mpc_imag');

// Definir a função mpc_realref
typedef mpc_realref_native = Pointer<mpfr_t> Function(Pointer<mpc_t>);
typedef mpc_realref_dart = Pointer<mpfr_t> Function(Pointer<mpc_t>);
final mpc_realref_dart mpc_realref = mpcLib.lookupFunction<mpc_realref_native, mpc_realref_dart>('mpc_realref');

// Definir a função mpc_imagref
typedef mpc_imagref_native = Pointer<mpfr_t> Function(Pointer<mpc_t>);
typedef mpc_imagref_dart = Pointer<mpfr_t> Function(Pointer<mpc_t>);
final mpc_imagref_dart mpc_imagref = mpcLib.lookupFunction<mpc_imagref_native, mpc_imagref_dart>('mpc_imagref');

// Definir a função mpc_conj
typedef mpc_conj_native = Int Function(Pointer<mpc_t>, Pointer<mpc_t>, Int);
typedef mpc_conj_dart = int Function(Pointer<mpc_t>, Pointer<mpc_t>, int);
final mpc_conj_dart mpc_conj = mpcLib.lookupFunction<mpc_conj_native, mpc_conj_dart>('mpc_conj');


class Complex {
  late Pointer<mpc_t> _complex;

  // Retorna um ponteiro para a estrutura mpc_t
  Pointer<mpc_t> getPointer() {
    return _complex;
  }

  // Retorna um ponteiro para a parte real do número complexo
  Pointer<mpfr_t> getRealPointer() {
    return _complex.cast<mpfr_t>()+0;
  }

  // Retorna um ponteiro para a parte imaginária do número complexo
  Pointer<mpfr_t> getImaginaryPointer() {
    return _complex.cast<mpfr_t>()+1;
  }

  final int _precision; // Precisão do número complexo

  // Getter para acessar a precisão do número complexo
  int get precision => _precision;

  // Setter para alterar o número complexo
  void setComplex(Complex complex) {
    mpc_set(_complex, complex.getPointer(), MPCRound.MPC_RNDNN);
  }

  Complex([this._precision = 256]) {
    _complex = calloc<mpc_t>();
    mpc_init2(_complex, _precision);
  }

  // Construtor a partir de dois doubles
  Complex.fromDouble(double real, [double imaginary = 0, this._precision = 256]) {
    _complex = calloc<mpc_t>();
    mpc_init2(_complex, _precision);
    setDouble(real, imaginary);
  }

  // Construtor a partir de dois complexos
  Complex.fromComplex(Complex re, Complex imag, [this._precision = 256]) {
    _complex = calloc<mpc_t>();
    mpc_init2(_complex, _precision);
    setReal(re.getReal(), imag.getReal());
  }

  // Construtor a partir de dois inteiros com sinal
  Complex.fromInt(int real, int imaginary, [this._precision = 256]) {
    _complex = calloc<mpc_t>();
    mpc_init2(_complex, _precision);
    mpc_set_si_si(_complex, real, imaginary, MPCRound.MPC_RNDNN);
  }

  // Construtor a partir de dois inteiros sem sinal
  Complex.fromUInt(int real, int imaginary, [this._precision = 256]) {
    _complex = calloc<mpc_t>();
    mpc_init2(_complex, _precision);
    mpc_set_ui_ui(_complex, real, imaginary, MPCRound.MPC_RNDNN);
  }

  // Construtor a partir de dois objetos Real
  Complex.fromReal(Real real, Real? imaginary, [this._precision = 256]) {
    _complex = calloc<mpc_t>();
    mpc_init2(_complex, _precision);
    setReal(real, imaginary);
  }

  // Construtor da constante de Euler
  Complex.eulers([this._precision = 256]) {
    _complex = calloc<mpc_t>();
    mpc_init2(_complex, _precision);
    setInt(0, 0);
    var rePtr = getRealPointer();
    mpfr_const_euler(rePtr, MPFRRound.RNDN);
  }

  // Construtor da constante Pi
  Complex.pi([this._precision = 256]) {
    _complex = calloc<mpc_t>();
    mpc_init2(_complex, _precision);
    setInt(0, 0);
    var rePtr = getRealPointer();
    mpfr_const_pi(rePtr, MPFRRound.RNDN);
  }

  // Construtor da constante Tau (2*Pi)
  Complex.tau([this._precision = 256]) {
    _complex = calloc<mpc_t>();
    mpc_init2(_complex, _precision);
    setInt(0, 0);
    var rePtr = getRealPointer();
    mpfr_const_pi(rePtr, MPFRRound.RNDN);
    mpfr_mul_si(rePtr, rePtr, 2, MPFRRound.RNDN);
  }

  // Destrutor
  void dispose() {
    mpc_clear(_complex);
    calloc.free(_complex);
  }

  // Retorna a parte real do número complexo como um objeto Real
  Real getReal() {
    Pointer<mpfr_t> mpfrRealPtr = getRealPointer();
    Real temp = Real(precision);

    Pointer<mpfr_t> mpfrPtr = temp.getPointer();
    mpfr_set(mpfrPtr, mpfrRealPtr, MPFRRound.RNDN);

    return temp;
  }

  // Retorna a parte imaginária do número complexo como um objeto Real
  Real getImaginary() {
    Pointer<mpfr_t> mpfrRealPtr = getImaginaryPointer();
    Real temp = Real(precision);

    Pointer<mpfr_t> mpfrPtr = temp.getPointer();
    mpfr_set(mpfrPtr, mpfrRealPtr, MPFRRound.RNDN);

    return temp;
  }

  // Retorna a parte real do número complexo como um double
  double getRealDouble() {
    Pointer<mpfr_t> mpfrRealPtr = getRealPointer();
    return mpfr_get_d(mpfrRealPtr, MPFRRound.RNDN);
  }

  // Retorna a parte imaginária do número complexo como um double
  double getImaginaryDouble() {
    Pointer<mpfr_t> mpfrImagPtr = getImaginaryPointer();
    return mpfr_get_d(mpfrImagPtr, MPFRRound.RNDN);
  }

  // Retorna o valor do número complexo como string
  // usa a função mpc_get_str para obter a string
  String getString1({int base = 10, int numDigits = 0, int round = MPFRRound.RNDN}) {
    int base = 10;
    Pointer<Utf8> str = mpc_get_str(base, numDigits, _complex, MPCRound.MPC_RNDNN);
    return str.toDartString();
  }

  // Retorna o valor do número complexo como string no formato (a, b),
  // onde a é a parte real e b é a parte imaginária
  String getString([int round = MPFRRound.RNDN]) {
    Real real = getReal();
    Real imag = getImaginary();

    String strReal = real.getString(round);
    String strImag = imag.getString(round);

    return '($strReal, $strImag)';
  }

  int setReal(Real real, [Real? imag, int round = MPFRRound.RNDN]) {
    if (imag == null) {
      return mpc_set_fr(_complex, real.getPointer(), round);
    } else {
      return mpc_set_fr_fr(_complex, real.getPointer(), imag.getPointer(), round);
    }
  }

  int setDouble(double real, [double imag = 0.0, int round = MPFRRound.RNDN]) {
    return mpc_set_d_d(_complex, real, imag, round);
  }

  int setInt(int real, [int imag = 0, int round = MPFRRound.RNDN]) {
    return mpc_set_si_si(_complex, real, imag, round);
  }

  int setUInt(int real, [int imag = 0, int round = MPFRRound.RNDN]) {
    return mpc_set_ui_ui(_complex, real, imag, round);
  }

  bool isZero() {
    int res = mpc_cmp_si_si(_complex, 0, 0);
    return MPCInexact.inexRe(res) == 0 && MPCInexact.inexIm(res) == 0;
  }

  bool isEqual(Complex other) {
    int res = mpc_cmp(_complex, other.getPointer(), MPCRound.MPC_RNDNN);
    return MPCInexact.inexRe(res) == 0 && MPCInexact.inexIm(res) == 0;
  }

  int cmp(Complex other) {
    return mpc_cmp(_complex, other.getPointer(), MPCRound.MPC_RNDNN);
  }

  int cmpIntInt(int real, int imag) {
    return mpc_cmp_si_si(_complex, real, imag);
  }

  int add(Complex a, Complex b) {
    return mpc_add(_complex, a.getPointer(), b.getPointer(), MPCRound.MPC_RNDNN);
  }

  int subtract(Complex a, Complex b) {
    return mpc_sub(_complex, a.getPointer(), b.getPointer(), MPCRound.MPC_RNDNN);
  }

  int multiply(Complex a, Complex b) {
    return mpc_mul(_complex, a.getPointer(), b.getPointer(), MPCRound.MPC_RNDNN);
  }

  int multiplyInt(Complex a, int b) {
    return mpc_mul_si(_complex, a.getPointer(), b, MPCRound.MPC_RNDNN);
  }

  int multiplyReal(Complex a, Real b) {
    return mpc_mul_fr(_complex, a.getPointer(), b.getPointer(), MPCRound.MPC_RNDNN);
  }

  int divide(Complex a, Complex b) {
    return mpc_div(_complex, a.getPointer(), b.getPointer(), MPCRound.MPC_RNDNN);
  }

  int divideUInt(Complex a, int b) {
    return mpc_div_ui(_complex, a.getPointer(), b, MPCRound.MPC_RNDNN);
  }

  int uIntDivide(int a, Complex b) {
    return mpc_ui_div(_complex, a, b.getPointer(), MPCRound.MPC_RNDNN);
  }

  int divideReal(Complex a, Real b) {
    return mpc_div_fr(_complex, a.getPointer(), b.getPointer(), MPCRound.MPC_RNDNN);
  }

  int realDivide(Real a, Complex b) {
    return mpc_fr_div(_complex, a.getPointer(), b.getPointer(), MPCRound.MPC_RNDNN);
  }

  int negate(Complex a) {
    return mpc_neg(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int power(Complex a, Complex b) {
    return mpc_pow(_complex, a.getPointer(), b.getPointer(), MPCRound.MPC_RNDNN);
  }

  int powerInt(Complex a, int b) {
    return mpc_pow_si(_complex, a.getPointer(), b, MPCRound.MPC_RNDNN);
  }

  int powerUInt(Complex a, int b) {
    return mpc_pow_ui(_complex, a.getPointer(), b, MPCRound.MPC_RNDNN);
  }

  int powerReal(Complex a, Real b) {
    return mpc_pow_fr(_complex, a.getPointer(), b.getPointer(), MPCRound.MPC_RNDNN);
  }

  int powerDouble(Complex a, double b) {
    return mpc_pow_d(_complex, a.getPointer(), b, MPCRound.MPC_RNDNN);
  }

  int sqrt(Complex a) {
    return mpc_sqrt(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int exp(Complex a) {
    return mpc_exp(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int log(Complex a) {
    return mpc_log(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int log10(Complex a) {
    return mpc_log10(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int sin(Complex a) {
    return mpc_sin(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int cos(Complex a) {
    return mpc_cos(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int tan(Complex a) {
    return mpc_tan(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int sinh(Complex a) {
    return mpc_sinh(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int cosh(Complex a) {
    return mpc_cosh(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int tanh(Complex a) {
    return mpc_tanh(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int asin(Complex a) {
    return mpc_asin(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int acos(Complex a) {
    return mpc_acos(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int atan(Complex a) {
    return mpc_atan(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int asinh(Complex a) {
    return mpc_asinh(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int acosh(Complex a) {
    return mpc_acosh(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int atanh(Complex a) {
    return mpc_atanh(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  int conj(Complex a) {
    return mpc_conj(_complex, a.getPointer(), MPCRound.MPC_RNDNN);
  }

  double getRealAsDouble() {
    return mpfr_get_d(getRealPointer(), MPFRRound.RNDN);
  }

  double getImaginaryAsDouble() {
    return mpfr_get_d(getImaginaryPointer(), MPFRRound.RNDN);
  }
}
