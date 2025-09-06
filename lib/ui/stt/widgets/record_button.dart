import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class RecordButton extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onTap;
  final RecorderController recorderController;

  const RecordButton({
    super.key,
    required this.isRecording,
    required this.recorderController,
    required this.onTap,
  });

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child:
          widget.isRecording
              ? Lottie.asset(
                'assets/lottie/recording.json',
                height: 200.w,
                width: 200.w,
                fit: BoxFit.cover,
              )
              : Container(
                key: const ValueKey("mic"),
                height: 100.w,
                width: 100.w,
                margin: EdgeInsets.only(bottom: 50.h),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.mic_none, size: 50),
              ),
    );
  }
}
