import 'package:ishora_tech/data/universal_data.dart';
import 'package:ishora_tech/service/translator_service.dart';

class TranslatorRepository {
  final TranslatorService apiService;

  TranslatorRepository({required this.apiService});

  Future<UniversalData> stt(String filePath) => apiService.stt(filePath);
}
