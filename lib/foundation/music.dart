class Note {
  final String name;

  /// The default path is `"$number.wav"`.
  final String path;

  Note.named(
    this.name, {
    String? path,
  }) : path = path ?? "$name.wav";

  static final $1 = Note.named("1");
  static final $2 = Note.named("2");
  static final $3 = Note.named("3");
  static final $4 = Note.named("4");
  static final $5 = Note.named("5");
  static final $6 = Note.named("6");
  static final $7 = Note.named("7");
  static final $8 = Note.named("8");
  static final $9 = Note.named("9");
  static final $plus = Note.named("+", path: "plus.wav");
  static final $minus = Note.named("-", path: "minus.wav");
  static final $div = Note.named("/", path: "div.wav");
  static final $mul = Note.named("x", path: "mul.wav");
  static final $eq = Note.named("=", path: "eq.wav");
}

class Sound {}
