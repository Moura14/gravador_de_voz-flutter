import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;

class MicScreens extends StatefulWidget {
  const MicScreens({super.key});

  @override
  State<MicScreens> createState() => _MicScreensState();
}

class _MicScreensState extends State<MicScreens> {
  final AudioRecorder audioRecorder = AudioRecorder();
  final AudioPlayer audioPlayer = AudioPlayer();

  bool isRecording = false, isPlaying = false;
  String? recordingPath;
  List<String> audioPaths = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: IconButton(
                onPressed: () async {
                  if (isRecording) {
                    recordingPath = await audioRecorder.stop();
                    setState(() {
                      isRecording = false;
                    });
                    if (recordingPath != null) {
                      audioPaths.add(recordingPath!);
                      setState(() {
                        isRecording = false;
                      });
                    }
                  } else {
                    if (await audioRecorder.hasPermission()) {
                      final Directory audioDocument =
                          await getApplicationDocumentsDirectory();
                      final String fileName =
                          'audio_${DateTime.now().microsecond}.wav';
                      final String filePath =
                          p.join(audioDocument.path, fileName);
                      await audioRecorder.start(const RecordConfig(),
                          path: filePath);

                      setState(() {
                        isRecording = true;
                        recordingPath = filePath;
                      });

                      print('Gravando audio em $filePath');
                    }
                  }
                },
                icon: Icon(
                  isRecording ? Icons.stop : Icons.mic,
                  size: 120,
                )),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
    audioRecorder.dispose();
  }
}
