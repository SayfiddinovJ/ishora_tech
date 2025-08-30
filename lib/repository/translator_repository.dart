import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:ishora_tech/data/universal_data.dart';
import 'package:ishora_tech/service/translator_service.dart';

class TranslatorRepository {
  final TranslatorService apiService;

  TranslatorRepository({required this.apiService});

  Future<UniversalData> startRecording(RecorderController recorderController) =>
      apiService.startRecording(recorderController);

  Future<UniversalData> stopRecordingAndSend(
    RecorderController recorderController,
  ) => apiService.stopRecordingAndSend(recorderController);
}
