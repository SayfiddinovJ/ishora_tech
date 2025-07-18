class WordModel {
  final String word;
  final String category;
  final String videoUrl;
  final String definition;
  final String wordUzCyrillic;
  final String definitionUzCyrillic;
  final String wordRu;
  final String definitionRu;

  WordModel({
    required this.word,
    required this.category,
    required this.videoUrl,
    required this.definition,
    required this.wordUzCyrillic,
    required this.definitionUzCyrillic,
    required this.wordRu,
    required this.definitionRu,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      word: json['word'] ?? '',
      category: json['category'] ?? '',
      videoUrl: json['video_url'] ?? '',
      definition: json['definition'] ?? '',
      wordUzCyrillic: json['word_uz_cyrillic'] ?? '',
      definitionUzCyrillic: json['definition_uz_cyrillic'] ?? '',
      wordRu: json['word_ru'] ?? '',
      definitionRu: json['definition_ru'] ?? '',
    );
  }
}
