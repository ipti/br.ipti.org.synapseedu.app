enum TemplateTypes { MTE, PRE, AEL, TEXT, MTE2, MTE4 }

TemplateTypes templateTypesfromTemplateId(int templateId) {
  switch (templateId) {
    case 1:
      return TemplateTypes.MTE;
    case 2:
      return TemplateTypes.PRE;
    case 3:
      return TemplateTypes.AEL;
    case 4:
      return TemplateTypes.TEXT;
    case 5:
      return TemplateTypes.MTE2;
    case 6:
      return TemplateTypes.MTE4;
    default:
      return TemplateTypes.MTE;
  }
}

extension TemplateTypesExtension on TemplateTypes {
  int get templateId {
    switch (this) {
      case TemplateTypes.MTE:
        return 1;
      case TemplateTypes.PRE:
        return 2;
      case TemplateTypes.AEL:
        return 3;
      case TemplateTypes.TEXT:
        return 4;
      case TemplateTypes.MTE2:
        return 5;
      case TemplateTypes.MTE4:
        return 6;
      default:
        return 1;
    }
  }



  // factory TemplateTypes.fromTemplateId(int templateId) {
  //   switch (templateId) {
  //     case 1:
  //       return TemplateTypes.MTE;
  //     case 2:
  //       return TemplateTypes.PRE;
  //     case 3:
  //       return TemplateTypes.AEL;
  //     case 4:
  //       return TemplateTypes.TEXT;
  //     default:
  //       return TemplateTypes.MTE;
  //   }
  // }
  //

  void task() {
    print("a");
  }

  TemplateTypes get number {
    switch (templateId) {
      case 1:
        return TemplateTypes.MTE;
      case 2:
        return TemplateTypes.PRE;
      case 3:
        return TemplateTypes.AEL;
      case 4:
        return TemplateTypes.TEXT;
      case 5:
        return TemplateTypes.MTE2;
      case 6:
        return TemplateTypes.MTE4;
      default:
        return TemplateTypes.MTE;
    }
  }
}
