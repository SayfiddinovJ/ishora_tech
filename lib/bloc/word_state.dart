part of 'word_bloc.dart';

class WordState {
  final WordModel wordModel;
  final List<WordModel> wordsList;
  final Status status;
  final String error;

  WordState({
    required this.wordModel,
    required this.wordsList,
    required this.status,
    required this.error,
  });

  WordState copyWith({
    WordModel? wordModel,
    List<WordModel>? wordsList,
    Status? status,
    String? error,
  }) {
    return WordState(
      wordModel: wordModel ?? this.wordModel,
      wordsList: wordsList ?? this.wordsList,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
