import 'package:flutter/material.dart';
import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/ui/widgets/dialog.dart';
import 'package:ishora_tech/utils/extensions/extensions.dart';

class WordTile extends StatelessWidget {
  const WordTile({super.key, required this.word});

  final WordModel word;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(word.word.capitalize()),
      onTap: () {
        showVideoDialog(context, word);
      },
    );
  }
}
