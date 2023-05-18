enum MultimediaTypes { text, image, audio }

extension MultimediaTypesExtension on MultimediaTypes {
  int get type_id {
    switch (this) {
      case MultimediaTypes.text:
        return 1;
      case MultimediaTypes.image:
        return 2;
      case MultimediaTypes.audio:
        return 3;
    }
  }
}