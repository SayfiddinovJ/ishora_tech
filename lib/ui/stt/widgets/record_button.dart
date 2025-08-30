import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

class _RecordButtonState extends State<RecordButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder:
            (child, animation) =>
                ScaleTransition(scale: animation, child: child),
        child:
            widget.isRecording
                ? AudioWaveforms(
                  size: Size(100.w, 100.w),
                  recorderController: widget.recorderController,
                  waveStyle: const WaveStyle(),
                  enableGesture: false,
                )
                : Container(
                  key: const ValueKey("mic"),
                  height: 100.w,
                  width: 100.w,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 1),
                        blurRadius: 10,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.mic_none, size: 50),
                ),
      ),
    );
  }
}
