extension DistinctEx<E> on List<E> {
  List<E> distinct({bool inplace = true}) {
    final ids = <E>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(x));
    return list;
  }

  List<E> distinctBy<Id>(Id Function(E element) id, {bool inplace = true}) {
    final ids = <Id>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id(x)));
    return list;
  }
}

extension StringX on String? {
  bool get isEmptyOrNull {
    final self = this;
    return self == null || self.isEmpty;
  }

  String notEmptyNullOr(String replacement) {
    final self = this;
    if (self == null) {
      return replacement;
    } else if (self.isEmpty) {
      return replacement;
    } else {
      return self;
    }
  }
}
