import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/ui/widgets/dialog.dart';
import 'package:ishora_tech/utils/extensions/extensions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<WordModel> allWords = [];
  List<WordModel> filteredWords = [];
  FocusNode focusNode = FocusNode();

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
      filteredWords = words; // boshlanishda hammasini ko‘rsatish
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Qidiruv"),
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              focusNode: focusNode,
              decoration: const InputDecoration(
                labelText: 'Qidiruv...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _filterWords,
            ),
          ),
          Expanded(
            child:
                filteredWords.isEmpty
                    ? const Center(child: Text("Hech narsa topilmadi"))
                    : ListView.builder(
                      itemCount: filteredWords.length,
                      itemBuilder: (context, index) {
                        final word = filteredWords[index];
                        return ListTile(
                          title: Text(word.word.capitalize()),
                          subtitle: Text(word.category.capitalize()),
                          onTap: () {
                            showVideoDialog(context, word);
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
