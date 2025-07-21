import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final AudioRecorder _record = AudioRecorder();
  final PlayerController _playerController = PlayerController();

  bool _isRecording = false;
  String _responseText = '';
  List<String> messages = [];
  File? audioFile;

  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) return;

    String path = '/storage/emulated/0/Download/${DateTime.now().millisecondsSinceEpoch}.mp3';
    await _record.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: path,
    );
    setState(() {
      _isRecording = true;
      audioFile = File(path);
    });
  }

  Future<void> _stopRecordingAndSend() async {
    final path = await _record.stop();
    setState(() => _isRecording = false);

    if (path == null) return;

    final file = File(path);
    setState(() => audioFile = file);


    final uri = Uri.parse('https://uzbekvoice.ai/api/v1/stt');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = '4df53204-b1da-42ab-a7ba-0eb0a17e6388:d16b44e0-d719-447a-b52e-ccab181a5a09';

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
        setState(() {
          _responseText = json['result']['text'] ?? 'Matn topilmadi';
          messages.add(_responseText);
        });
      } else {
        setState(() => _responseText = 'Xatolik: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _responseText = 'Xatolik: $e');
    }
  }

  @override
  void dispose() {
    _record.dispose();
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkBlue = const Color(0xFF002D6B);

    return Scaffold(
      backgroundColor: darkBlue,
      body: SafeArea(
        child: Column(
          children: [
            // Message bubbles
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: messages.length,
                itemBuilder:
                    (_, i) => Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          messages[i],
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
              ),
            ),

            // Input area
            Container(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child:
                        _isRecording
                            ? AudioFileWaveforms(
                              playerController: _playerController,
                              size: const Size(double.infinity, 45),
                              playerWaveStyle: const PlayerWaveStyle(
                                liveWaveColor: Colors.purpleAccent,
                                fixedWaveColor: Colors.purple,
                                spacing: 3,
                                waveThickness: 2,
                              ),
                            )
                            : Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              alignment: Alignment.centerLeft,
                              child: const Text('Ovozli xabar yuboring...'),
                            ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap:
                        _isRecording ? _stopRecordingAndSend : _startRecording,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 24,
                      child: Icon(
                        _isRecording ? Icons.send : Icons.mic,
                        color: darkBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
