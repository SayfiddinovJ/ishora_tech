import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ishora_tech/bloc/translator/translator_bloc.dart';
import 'package:ishora_tech/bloc/translator/translator_event.dart';
import 'package:ishora_tech/bloc/translator/translator_state.dart';
import 'package:ishora_tech/ui/stt/widgets/messages_list.dart';
import 'package:ishora_tech/ui/stt/widgets/record_button.dart';

class STTScreen extends StatefulWidget {
  const STTScreen({super.key});

  @override
  State<STTScreen> createState() => _STTScreenState();
}

class _STTScreenState extends State<STTScreen> {
  @override
  void deactivate() {
    context.read<TranslatorBloc>().add(RecordStopEvent());
    context.read<TranslatorBloc>().add(ClearMessagesEvent());
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final darkBlue = const Color(0xFF002D6B);

    return Scaffold(
      backgroundColor: darkBlue,
      appBar: AppBar(
        backgroundColor: darkBlue,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: BlocBuilder<TranslatorBloc, TranslatorState>(
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                if (state.messages.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Center(
                      child: Text(
                        state.error.isNotEmpty
                            ? 'Server bilan xatolik yuz berdi'
                            : 'Ovozingizni matnga aylantirish uchun mikrofonni bosing va gapirishni boshlang.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                else
                  MessagesList(messages: state.messages),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: RecordButton(
                    onTap: () {
                      state.isRecording
                          ? context.read<TranslatorBloc>().add(
                            StopRecordingAndSendEvent(),
                          )
                          : context.read<TranslatorBloc>().add(
                            StartRecordingEvent(),
                          );
                    },
                    isRecording: state.isRecording,
                    recorderController: state.recorderController,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
