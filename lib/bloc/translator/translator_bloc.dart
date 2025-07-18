import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishora_tech/bloc/translator/translator_event.dart';
import 'package:ishora_tech/bloc/translator/translator_state.dart';
import 'package:ishora_tech/data/models/stt_model.dart';
import 'package:ishora_tech/data/status.dart';
import 'package:ishora_tech/data/universal_data.dart';
import 'package:ishora_tech/repository/translator_repository.dart';

class TranslatorBloc extends Bloc<TranslatorEvent, TranslatorState> {
  final TranslatorRepository translatorRepository;

  TranslatorBloc(this.translatorRepository)
    : super(
        TranslatorState(
          sttModel: STTModel(text: '', confidence: 0),
          status: Status.pure,
          error: '',
        ),
      ) {
    on<TranslatorEvent>((event, emit) async {});
  }

  Future<void> getSTT(
    TranslatorEvent event,
    Emitter<TranslatorState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading));
    UniversalData data = await translatorRepository.stt(event.filePath);
    if (data.error.isNotEmpty) {
      emit(state.copyWith(status: Status.error, error: data.error));
    } else {
      emit(state.copyWith(status: Status.success, sttModel: data.data));
    }
  }
}
