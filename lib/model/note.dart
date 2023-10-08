class Note {
  String _title;
  String _subTitle;
  String _imageUrl;
  bool _isImportant;

  Note({
     required String title,
     required String subTitle,
     required String imageUrl,
    required bool isImportant,
  }): _title = title,
     _subTitle = subTitle,
     _imageUrl = imageUrl,
     _isImportant = isImportant;



  set subTitle(String subTitle) {
    _subTitle = subTitle;
  }

  String get subTitle {
    return _subTitle;
  }

  set title(String title) {
    _title = title;
  }

  String get title {
    return _title;
  }

  set imageUrl(String value) {
    _imageUrl = value;
  }

  String get imageUrl {
    return _imageUrl;
  }

  set isImportant(bool value) {
    _isImportant = value;
  }

  bool get isImportant {
    return _isImportant;
  }

}
