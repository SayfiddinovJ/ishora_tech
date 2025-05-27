class WordModel {
  final String word;
  final String category;
  final String videoUrl;

  WordModel({
    required this.word,
    required this.category,
    required this.videoUrl,
  });

  factory WordModel.fromJson(Map<String, dynamic> json) {
    return WordModel(
      word: json['word'],
      category: json['category'],
      videoUrl: json['video_url'],
    );
  }
}
