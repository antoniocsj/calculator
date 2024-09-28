// this file contains all the types used in the project.

// class to store the reference of an integer
class RefInt {
  int value;
  RefInt(this.value);
}

// class to store the reference of a double
class RefDouble {
  double value;
  RefDouble(this.value);
}

// class to store the reference of a string
class RefString {
  String value;
  RefString(this.value);
}

// class to store the reference of a boolean
class RefBool {
  bool value;
  RefBool(this.value);
}

class StringBuilder extends StringBuffer {
  StringBuilder([super.content]);

  void append(String object) {
    write(object);
  }

  void prepend(String str) {
    String result = str + toString();
    clear();
    write(result);
  }

  void assign(String object) {
    clear();
    write(object);
  }

  void truncate(int length) {
    if (length < 0) {
      throw RangeError.value(length);
    }
    if (length > length) {
      throw RangeError.value(length);
    }
    if (length == 0) {
      clear();
    } else {
      String truncated = toString().substring(0, length);
      clear();
      write(truncated);
    }
  }
}