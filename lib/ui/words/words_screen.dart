import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ishora_tech/bloc/word_bloc.dart';
import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/data/status.dart';
import 'package:ishora_tech/ui/widgets/search_delegate.dart';
import 'package:ishora_tech/ui/widgets/word_tile.dart';
import 'package:ishora_tech/utils/app_colors/app_colors.dart';

class WordsScreen extends StatefulWidget {
  const WordsScreen({super.key});

  @override
  State<WordsScreen> createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen> {
  List<WordModel> words = [];

  @override
  void initState() {
    words = BlocProvider.of<WordBloc>(context).state.wordsList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text('So\'zlar'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: WordSearchDelegate(words));
            },
          ),
        ],
      ),
      body: BlocBuilder<WordBloc, WordState>(
        builder: (context, state) {
          if (state.status == Status.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == Status.error) {
            return Center(child: Text(state.error));
          }
          if (state.status == Status.success) {
            return state.wordsList.isEmpty
                ? Center(child: Text('Hali hech qanday so\'z yo\'q'))
                : ListView.builder(
                  itemCount: state.wordsList.length,
                  itemBuilder: (context, index) {
                    WordModel word = state.wordsList[index];
                    return WordTile(word: word);
                  },
                );
          }
          return Center(child: Text('Hali hech qanday so\'z yo\'q'));
        },
      ),
    );
  }
}
