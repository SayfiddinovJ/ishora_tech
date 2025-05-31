class WordModel {
  final String word;
  final String category;
  final String videoUrl;
  final String definition;

  WordModel({
    required this.word,
    required this.category,
    required this.videoUrl,
    required this.definition,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      word: json['word'] ?? '',
      category: json['category'] ?? '',
      videoUrl: json['video_url'] ?? '',
      definition: json['definition'] ?? '',
    );
  }
}
