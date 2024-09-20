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



// final class mpfr_t extends Struct {
//   @Long()
//   external int _mpfr_prec;
//   @Int()
//   external int _mpfr_sign;
//   @Long()
//   external int _mpfr_exp;
//   external Pointer<UnsignedLong> _mpfr_d;
// }

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

class Complex {
  late Pointer<mpc_t> _complex;

  // Getter para acessar o número complexo
  Pointer<mpc_t> get complex => _complex;

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

  // Retorna a parte real do número complexo como um objeto Real
  Real getReal() {
    Pointer<mpfr_t> rePtr = _complex.cast<mpfr_t>()+0;
    Real r = Real();
    Pointer<mpfr_t> mpfrPtr = r.getPointer();
    mpfr_set(mpfrPtr, rePtr, MPFRRound.RNDN);
    return r;
  }

  // Retorna a parte imaginária do número complexo como um objeto Real
  Real getImaginary() {
    Pointer<mpfr_t> imPtr = _complex.cast<mpfr_t>()+1;
    Real r = Real();
    Pointer<mpfr_t> mpfrPtr = r.getPointer();
    mpfr_set(mpfrPtr, imPtr, MPFRRound.RNDN);
    return r;
  }

}