part of '../foundation.dart';

class Note {
  final String number;
  final String path;
  final bool hasSound;

  Note(
    this.number, {
    String? path,
    this.hasSound = true,
  }) : path = path ?? number;

  static final $1 = Note("1");
  static final $2 = Note("2");
  static final $3 = Note("3");
  static final $4 = Note("4");
  static final $5 = Note("5");
  static final $6 = Note("6");
  static final $7 = Note("7");
  static final $8 = Note("8");
  static final $9 = Note("9");
  static final $plus = Note("+", path: "plus");
  static final $minus = Note("-", path: "minus");
  static final $div = Note("/", path: "div");
  static final $mul = Note("x", path: "mul");
  static final $eq = Note("=", path: "eq");
}

class Sound {}
