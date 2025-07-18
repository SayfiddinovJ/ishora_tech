import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ishora_tech/bloc/translator/translator_bloc.dart';
import 'package:ishora_tech/bloc/translator/translator_state.dart';
import 'package:ishora_tech/utils/app_colors/app_colors.dart';
import 'package:ishora_tech/utils/extensions/extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

String audioResponse = '';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final record = AudioRecorder();

  recordAudio() async {
    if (await record.hasPermission()) {
      await record.start(const RecordConfig(), path: DateTime.now().toString());
      final stream = await record.startStream(
        const RecordConfig(encoder: AudioEncoder.pcm16bits),
      );
    }
  }

  bool showPlayer = false;
  bool isRecording = false;

  final audioUploader = AudioRecorderUploader();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text('Tarjimon'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: BlocBuilder<TranslatorBloc, TranslatorState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(child: Text('Natija: $audioResponse')),
                  ),
                ),
                20.ph,
                ElevatedButton(
                  onPressed: () async {
                    await audioUploader.startRecording();
                    setState(() {});
                  },
                  child: Text("🎤 Start Recording"),
                ),

                // To‘xtatish va yuklash
                ElevatedButton(
                  onPressed: () async {
                    await audioUploader.stopAndUpload();
                    setState(() {});
                  },
                  child: Text("⏹ Stop & Upload"),
                ),

                10.ph,
              ],
            ),
          );
        },
      ),
    );
  }
}

class AudioRecorderUploader {
  final _record = AudioRecorder();
  late String _filePath;

  /// Ovoz yozishni boshlaydi
  Future<void> startRecording() async {
    if (await _record.hasPermission()) {
      final dir = await getApplicationDocumentsDirectory();
      _filePath =
          '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _record.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: _filePath,
      );

      debugPrint('🎙️ Recording started at $_filePath');
    } else {
      debugPrint('❌ Permission denied to record audio.');
    }
  }

  /// Yozishni to‘xtatadi va faylni serverga yuboradi
  Future<void> stopAndUpload() async {
    final path = await _record.stop();
    if (path == null) {
      debugPrint('⚠️ No recording to stop.');
      return;
    }

    debugPrint('✅ Recording stopped. File saved at: $path');
    await uploadAudio(path);
  }

  /// Audio faylni serverga yuklash
  Future<void> uploadAudio(String filePath) async {
    final file = File(filePath);

    if (!file.existsSync()) {
      debugPrint('❌ File does not exist: $filePath');
      return;
    }

    final dio = Dio();
    final url = 'https://uzbekvoice.ai/api/v1/stt';

    final formData = FormData.fromMap({
      'return_offsets': 'true',
      'run_diarization': 'false',
      'language': 'uz',
      'blocking': 'true',
      "file": await MultipartFile.fromFile(file.path, filename: "audio.m4a"),
    });

    try {
      final response = await dio.get(
        url,
        data: formData,
        options: Options(
          headers: {
            "Authorization":
                "4df53204-b1da-42ab-a7ba-0eb0a17e6388:d16b44e0-d719-447a-b52e-ccab181a5a09",
          },
          contentType: 'multipart/form-data',
        ),
      );
      audioResponse = response.data['text'];
      debugPrint('🚀 Upload successful: ${response.statusCode}');
      debugPrint('🔁 Response: ${response.data}');
    } catch (e) {
      debugPrint('❌ Upload error: $e');
    }
  }
}
