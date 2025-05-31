import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ishora_tech/data/models/word_model.dart';
import 'package:ishora_tech/utils/extensions/extensions.dart';
import 'package:video_player/video_player.dart';

void showVideoDialog(BuildContext context, WordModel word) {
  final controller = VideoPlayerController.networkUrl(Uri.parse(word.videoUrl));

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.all(16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: FutureBuilder(
          future: controller.initialize().then((_) => controller.play()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return StatefulBuilder(
                builder: (context, setState) {
                  bool isVideoFinished = false;

                  controller.addListener(() {
                    final finished =
                        controller.value.position >= controller.value.duration;
                    if (finished != isVideoFinished) {
                      setState(() {
                        isVideoFinished = finished;
                      });
                    }
                  });

                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: VideoPlayer(controller),
                        ),
                        10.ph,
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (isVideoFinished) {
                                controller.seekTo(Duration.zero);
                                controller.play();
                              } else if (controller.value.isPlaying) {
                                controller.pause();
                              } else {
                                controller.play();
                              }
                            });
                          },
                          icon: Icon(
                            isVideoFinished
                                ? Icons.replay
                                : controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        ),
                        const Divider(),
                        Text(
                          word.word.capitalize(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'To\'plam: ${word.category.capitalize()}',
                          style: TextStyle(color: Colors.black),
                        ),
                        const Divider(),
                        Text(
                          'Ta\'rif: ${word.definition.capitalize()}',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  10.ph,
                  CircularProgressIndicator(),
                  5.ph,
                  Text(
                    'Video yuklanmoqda...',
                    style: TextStyle(color: Colors.black),
                  ),
                  10.ph,
                ],
              );
            }
          },
        ),
      );
    },
  ).then((_) => controller.dispose());
}
