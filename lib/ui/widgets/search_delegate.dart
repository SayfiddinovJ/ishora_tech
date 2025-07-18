import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/ui/widgets/word_tile.dart';
import 'package:ishora_tech/utils/app_colors/app_colors.dart';

class WordSearchDelegate extends SearchDelegate<WordModel> {
  final List<WordModel> wordList;

  WordSearchDelegate(this.wordList);

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: AppColors.backgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white54),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontSize: 18.sp),
      ),
      scaffoldBackgroundColor: Colors.white,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.white),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        close(
          context,
          WordModel(
            word: '',
            category: '',
            videoUrl: '',
            definition: '',
            wordUzCyrillic: '',
            definitionUzCyrillic: '',
            wordRu: '',
            definitionRu: '',
          ),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredWordList =
        wordList
            .where(
              (word) => word.word.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView.builder(
      itemCount: filteredWordList.length,
      itemBuilder: (context, index) {
        final word = filteredWordList[index];
        return WordTile(word: word);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList =
        query.isEmpty
            ? wordList
            : wordList
                .where(
                  (word) =>
                      word.word.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final word = suggestionList[index];
        return WordTile(word: word);
      },
    );
  }
}
