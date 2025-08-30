import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:ishora_tech/data/models/stt_model.dart';
import 'package:ishora_tech/data/status.dart';

class TranslatorState {
  final RecorderController recorderController;
  final STTModel sttModel;
  final List<String> messages;
  final Status status;
  final bool isRecording;
  final String error;

  TranslatorState({
    required this.recorderController,
    required this.sttModel,
    required this.messages,
    required this.isRecording,
    required this.status,
    required this.error,
  });

  TranslatorState copyWith({
    RecorderController? recorderController,
    STTModel? sttModel,
    List<String>? messages,
    bool? isRecording,
    Status? status,
    String? error,
  }) {
    return TranslatorState(
      recorderController: recorderController ?? this.recorderController,
      sttModel: sttModel ?? this.sttModel,
      messages: messages ?? this.messages,
      isRecording: isRecording ?? this.isRecording,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
