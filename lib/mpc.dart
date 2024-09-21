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

  final int _precision = 256; // Precisão padrão de 256 bits

  // Getter para acessar a precisão do número complexo
  int get precision => _precision;

  Complex() {
    _complex = calloc<mpc_t>();
    mpc_init2(_complex, _precision);
  }

  // Construtor a partir de dois doubles
  Complex.fromDouble(double real, double imaginary) {
    _complex = calloc<mpc_t>();
    mpc_init2(_complex, _precision);
    mpc_set_d_d(_complex, real, imaginary, MPCRound.MPC_RNDNN);
  }

  // Destrutor
  void dispose() {
    mpc_clear(_complex);
    calloc.free(_complex);
  }

  // Retorna a parte real do número complexo como um objeto Real
  Real getReal() {
    Pointer<mpfr_t> mpfrRealPtr = getRealPointer();
    Real temp = Real();

    Pointer<mpfr_t> mpfrPtr = temp.getPointer();
    mpfr_set(mpfrPtr, mpfrRealPtr, MPFRRound.RNDN);

    return temp;
  }

  // Retorna a parte imaginária do número complexo como um objeto Real
  Real getImaginary() {
    Pointer<mpfr_t> mpfrRealPtr = getImaginaryPointer();
    Real temp = Real();

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
}
