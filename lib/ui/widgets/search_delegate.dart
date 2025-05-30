import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/routes/app_route.dart';

class RealTimeSearchPage extends StatefulWidget {
  const RealTimeSearchPage({super.key});

  @override
  State<RealTimeSearchPage> createState() => _RealTimeSearchPageState();
}

class _RealTimeSearchPageState extends State<RealTimeSearchPage> {
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
            child: Hero(
              tag: 'search',
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'So‘zni kiriting...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _filterWords,
              ),
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
                          title: Text(word.word),
                          subtitle: Text(word.category),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.details,
                              arguments: word,
                            );
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
