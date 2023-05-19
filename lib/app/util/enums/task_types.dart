enum TemplateTypes { MTE, PRE, AEL, TEXT }

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
      default:
        return 1;
    }
  }

  void a(int s){}

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
      default:
        return TemplateTypes.MTE;
    }
  }

}
