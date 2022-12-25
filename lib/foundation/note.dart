class Note {
  final String id;

  const Note.named(this.id);

  static const $none = Note.named("none");
  static const $1 = Note.named("1");
  static const $2 = Note.named("2");
  static const $3 = Note.named("3");
  static const $4 = Note.named("4");
  static const $5 = Note.named("5");
  static const $6 = Note.named("6");
  static const $7 = Note.named("7");
  static const $8 = Note.named("8");
  static const $9 = Note.named("9");
  static const $plus = Note.named("plus");
  static const $minus = Note.named("minus");
  static const $mul = Note.named("mul");
  static const $div = Note.named("div");
  static const $eq = Note.named("eq");

  @override
  String toString() => id;

  static const all = [$1, $2, $3, $4, $5, $6, $7, $8, $9, $plus, $minus, $mul, $div, $eq];

  static const note2Numbered = {
    $1: "1",
    $2: "2",
    $3: "3",
    $4: "4",
    $5: "5",
    $6: "6",
    $7: "7",
    $8: "8",
    $9: "9",
    $plus: "+",
    $minus: "-",
    $mul: "*",
    $div: "/",
    $eq: "="
  };
  static const note2TonicSolfa = {
    $1: "Do",
    $2: "Re",
    $3: "Mi",
    $4: "Fa",
    $5: "So",
    $6: "La",
    $7: "Ti",
    $8: "Do+",
    $9: "Re+",
    $plus: "Mi+",
    $minus: "Fa+",
    $mul: "La+",
    $div: "So+",
    $eq: "Ti+"
  };
  static const id2Note = {
    "1": $1,
    "2": $2,
    "3": $3,
    "4": $4,
    "5": $5,
    "6": $6,
    "7": $7,
    "8": $8,
    "9": $9,
    "plus": $plus,
    "minus": $minus,
    "mul": $mul,
    "div": $div,
    "eq": $eq
  };

  static Note of(String id, {Note fallback = $none}) {
    return id2Note[id] ?? fallback;
  }

  static Iterable<Note> loopSequence(int count, {bool reversed = false, int step = 1}) sync* {
    final len = Note.all.length;
    if (reversed) {
      // TODO: Does this work?
      step = -step.abs();
      for (int i = 0; i < count; i++) {
        yield Note.all[(i * step) % len];
      }
    } else {
      step = step.abs();
      for (int i = 0; i < count; i++) {
        yield Note.all[(i * step) % len];
      }
    }
  }
}

extension NoteX on Note {
  String get assetsName => "$id.wav";

  String get numberedText => Note.note2Numbered[this] ?? "?";

  String get tonicSolfaText => Note.note2TonicSolfa[this] ?? "?";
}
