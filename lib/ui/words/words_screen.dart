import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ishora_tech/bloc/word_bloc.dart';
import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/data/status.dart';
import 'package:ishora_tech/routes/app_route.dart';
import 'package:ishora_tech/utils/app_colors/app_colors.dart';

class WordsScreen extends StatelessWidget {
  const WordsScreen({super.key});

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
                    return ListTile(
                      title: Text(word.word),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          RouteNames.details,
                          arguments: word,
                        );
                      },
                    );
                  },
                );
          }
          return Center(child: Text('Hali hech qanday so\'z yo\'q'));
        },
      ),
    );
  }
}
