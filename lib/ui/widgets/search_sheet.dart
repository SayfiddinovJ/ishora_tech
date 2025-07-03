import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/ui/widgets/dialog.dart';
import 'package:ishora_tech/utils/extensions/extensions.dart';

class SearchSheet extends StatefulWidget {
  const SearchSheet({super.key});

  @override
  State<SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<SearchSheet> {
  List<WordModel> allWords = [];
  List<WordModel> filteredWords = [];

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  Future<void> loadWords() async {
    final String response = await rootBundle.loadString(
      'assets/word/word.json',
    );
    final List<dynamic> data = jsonDecode(response);
    final words = data.map((json) => WordModel.fromJson(json)).toList();

    setState(() {
      allWords = words;
      filteredWords = words;
    });
  }

  void _filterWords(String query) {
    final results =
        allWords.where((word) {
          return word.word.toLowerCase().contains(query.toLowerCase());
        }).toList();

    setState(() {
      filteredWords = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      builder:
          (context, scrollController) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Qidiruv...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _filterWords,
                ),
                const SizedBox(height: 12),
                Expanded(
                  child:
                      filteredWords.isEmpty
                          ? const Center(child: Text("Hech narsa topilmadi"))
                          : ListView.builder(
                            controller: scrollController,
                            itemCount: filteredWords.length,
                            itemBuilder: (context, index) {
                              final word = filteredWords[index];
                              return ListTile(
                                title: Text(word.word.capitalize()),
                                subtitle: Text(word.category.capitalize()),
                                onTap: () {
                                  Navigator.pop(context); // bottomSheet yopish
                                  showVideoDialog(context, word);
                                },
                              );
                            },
                          ),
                ),
              ],
            ),
          ),
    );
  }
}
