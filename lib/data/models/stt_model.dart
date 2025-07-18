class STTModel {
  final String text;
  final double confidence;

  STTModel({required this.text, required this.confidence});

  factory STTModel.fromJson(Map<String, dynamic> json) {
    return STTModel(text: json['text'], confidence: json['confidence']);
  }
}
