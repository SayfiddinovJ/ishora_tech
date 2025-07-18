import 'package:ishora_tech/data/models/stt_model.dart';
import 'package:ishora_tech/data/status.dart';

class TranslatorState {
  final STTModel sttModel;
  final Status status;
  final String error;

  TranslatorState({
    required this.sttModel,
    required this.status,
    required this.error,
  });

  TranslatorState copyWith({
    STTModel? sttModel,
    Status? status,
    String? error,
  }) {
    return TranslatorState(
      sttModel: sttModel ?? this.sttModel,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}