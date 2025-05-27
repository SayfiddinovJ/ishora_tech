import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/data/universal_data.dart';

class WordService {
  Future<UniversalData> getWords() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/word/word.json',
      );
      final List<dynamic> data = jsonDecode(response);
      data.map((json) => WordModel.fromJson(json)).toList();

      return UniversalData(data: data);
    } catch (e) {
      return UniversalData(error: e.toString());
    }
  }

  Future<List<WordModel>> searchWords(String query) async {
    final String response = await rootBundle.loadString(
      'assets/word/word.json',
    );
    final List<dynamic> data = jsonDecode(response);
    data.map((json) => WordModel.fromJson(json)).toList();

    final List<WordModel> allWords =
        data.map((json) => WordModel.fromJson(json)).toList();
    return allWords.where((word) {
      return word.word.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
