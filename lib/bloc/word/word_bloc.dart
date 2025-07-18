import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/data/status.dart';
import 'package:ishora_tech/data/universal_data.dart';
import 'package:ishora_tech/repository/word_repository.dart';

part 'word_event.dart';

part 'word_state.dart';

class WordBloc extends Bloc<WordEvent, WordState> {
  final WordRepository wordRepository;

  WordBloc(this.wordRepository)
    : super(
        WordState(
          wordModel: WordModel(
            word: '',
            category: '',
            videoUrl: '',
            definition: '',
            wordUzCyrillic: '',
            definitionUzCyrillic: '',
            wordRu: '',
            definitionRu: '',
          ),
          wordsList: [],
          status: Status.pure,
          error: '',
        ),
      ) {
    on<WordEvent>((event, emit) {});
    on<GetEvent>(getWord);
  }

  Future<void> getWord(GetEvent event, Emitter<WordState> emit) async {
    emit(state.copyWith(status: Status.loading));
    UniversalData data = await wordRepository.getWords();

    List<WordModel> filteredWords = [];

    data.data.map((e) {
      if (e['category'].contains(event.categoryName)) {
        filteredWords.add(WordModel.fromJson(e));
      }
    }).toList();

    if (data.data.isNotEmpty) {
      emit(state.copyWith(status: Status.success, wordsList: filteredWords));
    } else {
      emit(state.copyWith(status: Status.error, error: data.error));
    }
  }
}
