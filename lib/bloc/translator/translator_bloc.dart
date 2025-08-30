import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/foundation.dart';
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
          messages: [],
          isRecording: false,
          recorderController: RecorderController(),
        ),
      ) {
    on<TranslatorEvent>((event, emit) async {});
    on<StartRecordingEvent>(startRecording);
    on<StopRecordingAndSendEvent>(stopRecordingAndSend);
    on<RecordStopEvent>(recordStop);
    on<ClearMessagesEvent>(clearMessages);
  }

  recordStop(RecordStopEvent event, Emitter<TranslatorState> emit) {
    state.recorderController.stop();
    emit(state.copyWith(status: Status.pure, error: ''));
  }

  Future<void> startRecording(
    StartRecordingEvent event,
    Emitter<TranslatorState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, isRecording: true));
    UniversalData data = await translatorRepository.startRecording(
      state.recorderController,
    );
    if (data.error.isNotEmpty) {
      emit(state.copyWith(status: Status.error, error: data.error));
    } else {
      emit(state.copyWith(status: Status.success));
    }
  }

  Future<void> stopRecordingAndSend(
    StopRecordingAndSendEvent event,
    Emitter<TranslatorState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, isRecording: false));
    UniversalData data = await translatorRepository.stopRecordingAndSend(
      state.recorderController,
    );
    debugPrint('Data: ${data.data.toString()}');
    debugPrint('Error: ${data.error}');
    if (data.error.isNotEmpty) {
      emit(state.copyWith(status: Status.error, error: data.error));
    } else {
      emit(
        state.copyWith(
          status: Status.success,
          messages: state.messages + data.data,
        ),
      );
    }
  }

  clearMessages(ClearMessagesEvent event, Emitter<TranslatorState> emit) {
    emit(state.copyWith(messages: []));
  }
}
