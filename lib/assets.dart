// ignore: non_constant_identifier_names
final Assets = _Assets();

class _Assets {
  static const _ns = "assets";
  final img = _Img();
}

class _Img {
  static const _ns = "${_Assets._ns}/img";
  final previewPlaceholder = "$_ns/preview-placeholder.svg";
}
