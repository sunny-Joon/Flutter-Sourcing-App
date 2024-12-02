import 'dart:core';
import 'dart:math';

class Validators {
  // The multiplication table
  static const List<List<int>> d = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
    [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
    [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
    [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
    [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
    [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
    [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
    [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
  ];

  // The permutation table
  static const List<List<int>> p = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
    [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
    [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
    [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
    [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
    [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
    [7, 0, 4, 6, 9, 1, 3, 2, 5, 8]
  ];

  // The inverse table
  static const List<int> inv = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9];

  static bool validateVerhoeff(String num) {
    int c = 0;
    if (num.toUpperCase().contains("X")) return false;

    List<int> myArray = stringToReversedIntArray(num);

    for (int i = 0; i < myArray.length; i++) {
      c = d[c][p[(i % 8)][myArray[i]]];
    }

    return c == 0;
  }

  static List<int> stringToReversedIntArray(String num) {
    List<int> myArray = List<int>.generate(num.length, (i) => int.parse(num[i]));
    return reverse(myArray);
  }

  static List<int> reverse(List<int> myArray) {
    List<int> reversed = List<int>.filled(myArray.length, 0);
    for (int i = 0; i < myArray.length; i++) {
      reversed[i] = myArray[myArray.length - (i + 1)];
    }
    return reversed;
  }

  static bool validatePan(String strPAN) {
    RegExp pattern = RegExp(r'^[A-Z]{3}P[A-Z]{1}[0-9]{4}[A-Z]{1}$');
    bool retVal = false;
    if (strPAN != null && strPAN.length == 10) {
      retVal = pattern.hasMatch(strPAN);
    }
    return retVal;
  }

  static bool validateIFSC(String strIFSC) {
    RegExp pattern = RegExp(r'^[A-Z]{4}0[A-Z,0-9]{6}$');
    bool retVal = false;
    if (strIFSC != null && strIFSC.length == 11) {
      retVal = pattern.hasMatch(strIFSC);
    }
    return retVal;
  }

  static bool validateCaseCode(String caseCode) {
    RegExp pattern = RegExp(r'^[A-Z]{4}[0-9]{6}$');
    bool retVal = false;
    if (caseCode != null && caseCode.length == 10) {
      retVal = pattern.hasMatch(caseCode);
    }
    return retVal;
  }
}
