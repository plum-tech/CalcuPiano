part of '../foundation.dart';

class Note {
  final String number;
  /// The default path is `"$number.wav"`.
  final String path;

  Note(
    this.number, {
    String? name,
  }) : path = name ?? "$number.wav";

  static final $1 = Note("1");
  static final $2 = Note("2");
  static final $3 = Note("3");
  static final $4 = Note("4");
  static final $5 = Note("5");
  static final $6 = Note("6");
  static final $7 = Note("7");
  static final $8 = Note("8");
  static final $9 = Note("9");
  static final $plus = Note("+", name: "plus.wav");
  static final $minus = Note("-", name: "minus.wav");
  static final $div = Note("/", name: "div.wav");
  static final $mul = Note("x", name: "mul.wav");
  static final $eq = Note("=", name: "eq.wav");
}

class Sound {}
