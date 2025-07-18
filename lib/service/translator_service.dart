import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ishora_tech/data/universal_data.dart';

class TranslatorService {
  static const String baseUrl = 'https://uzbekvoice.ai/developers/api/stt';

  Future<UniversalData> stt(String filePath) async {
    final dio = Dio();

    final url = 'https://uzbekvoice.ai/api/v1/stt';

    final file = await MultipartFile.fromFile(
      filePath,
      filename: 'audio.mp3',
      contentType: DioMediaType('audio', 'mpeg'),
    );

    final formData = FormData.fromMap({
      'file': file,
      'return_offsets': 'true',
      'run_diarization': 'false',
      'language': 'uz',
      'blocking': 'true',
    });

    try {
      final response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization':
                '4df53204-b1da-42ab-a7ba-0eb0a17e6388:d16b44e0-d719-447a-b52e-ccab181a5a09',
          },
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Success: ${response.data}');
        return UniversalData(data: response.data);
      } else {
        debugPrint('❗ Error: ${response.data}');
        return UniversalData(error: response.data);
      }
    } on DioException catch (e) {
      debugPrint('❗ Dio error: ${e.response?.statusCode} - ${e.message}');
      return UniversalData(error: e.message!);
    } catch (e) {
      debugPrint('❗ Unknown error: $e');
      return UniversalData(data: e);
    }
  }
}
