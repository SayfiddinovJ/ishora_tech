import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/data/universal_data.dart';
import 'package:ishora_tech/service/word_service.dart';

class WordRepository {
  final WordService service;

  WordRepository({required this.service});

  Future<UniversalData> getWords() => service.getWords();

  Future<List<WordModel>> searchWords(String query) =>
      service.searchWords(query);
}
