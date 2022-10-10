class LanguageModel {
  String flag;
  String language;
  String languageCode;
  LanguageModel(this.flag, this.language, this.languageCode);
  static List<LanguageModel> languageList() {
    return <LanguageModel>[
      LanguageModel("assets/flag/gb.png", "English", "en"),
      LanguageModel("assets/flag/es.png", "Spanish", "es"),
      LanguageModel("assets/flag/fr.png", "French", "fr"),
    ];
  }
}
