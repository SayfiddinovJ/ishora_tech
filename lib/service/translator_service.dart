import 'dart:convert';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:ishora_tech/data/universal_data.dart';
import 'package:permission_handler/permission_handler.dart';

class TranslatorService {
  File? audioFile;

  Future<UniversalData> startRecording(
    RecorderController recorderController,
  ) async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      return UniversalData(error: 'Microphone permission denied');
    }

    String path =
        '/storage/emulated/0/Download/${DateTime.now().millisecondsSinceEpoch}.mp3';
    // await _record.start(
    //   const RecordConfig(
    //     encoder: AudioEncoder.aacLc,
    //     bitRate: 128000,
    //     sampleRate: 44100,
    //   ),
    //   path: path,
    // );
    await recorderController.record(
      androidEncoder: AndroidEncoder.aac,
      bitRate: 128000,
      sampleRate: 44100,
      path: path,
    );
    audioFile = File(path);
    return UniversalData(data: audioFile);
  }

  Future<UniversalData> stopRecordingAndSend(
    RecorderController recorderController,
  ) async {
    String responseText = '';
    List<String> messages = [];

    final path = await recorderController.stop();

    if (path == null) return UniversalData(error: 'No recording to stop');

    final file = File(path);
    audioFile = file;

    final uri = Uri.parse('https://uzbekvoice.ai/api/v1/stt');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] =
        '4df53204-b1da-42ab-a7ba-0eb0a17e6388:d16b44e0-d719-447a-b52e-ccab181a5a09';

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType('audio', 'mp3'),
      ),
    );

    request.fields['return_offsets'] = 'false';
    request.fields['run_diarization'] = 'false';
    request.fields['language'] = 'uz';
    request.fields['blocking'] = 'true';

    try {
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        responseText = json['result']['text'] ?? 'Matn topilmadi';
        messages.add(responseText);
        return UniversalData(data: responseText);
      } else {
        responseText = 'Xatolik: ${response.statusCode}';
        return UniversalData(error: responseText);
      }
    } catch (e) {
      responseText = 'Xatolik: $e';
      return UniversalData(error: responseText);
    }
  }
}
