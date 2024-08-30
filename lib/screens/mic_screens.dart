import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;

class MicScreens extends StatefulWidget {
  final Function(List<String>) onAudioRecorded;

  const MicScreens({super.key, required this.onAudioRecorded});

  @override
  State<MicScreens> createState() => _MicScreensState();
}

class _MicScreensState extends State<MicScreens> {
  final Record audioRecorder = Record();
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
                  // Parar a gravação
                  recordingPath = await audioRecorder.stop();
                  setState(() {
                    isRecording = false;
                  });
                  if (recordingPath != null) {
                    audioPaths.add(recordingPath!);
                    widget.onAudioRecorded(
                        audioPaths); // Passa os caminhos para HomeScreens
                    print('Áudio salvo em: $recordingPath');
                  }
                } else {
                  // Verificar permissões e iniciar a gravação
                  if (await audioRecorder.hasPermission()) {
                    // Obter o diretório de documentos do aplicativo de forma dinâmica
                    final Directory audioDocument =
                        await getApplicationDocumentsDirectory();

                    // Criar um nome de arquivo único baseado na data e hora atuais
                    final String fileName =
                        'audio_${DateTime.now().millisecondsSinceEpoch}.wav';

                    // Construir o caminho completo do arquivo usando a biblioteca path
                    final String filePath =
                        p.join(audioDocument.path, fileName);

                    // Iniciar a gravação
                    await audioRecorder.start(path: filePath);
                    setState(() {
                      isRecording = true;
                      recordingPath = filePath;
                    });

                    print('Gravando áudio em: $filePath');
                  }
                }
              },
              icon: Icon(
                isRecording ? Icons.stop : Icons.mic,
                size: 120,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (audioPlayer.playing) {
                await audioPlayer.stop();
                setState(() {
                  isPlaying = false;
                });
              } else if (recordingPath != null) {
                await audioPlayer.setFilePath(recordingPath!);
                await audioPlayer.play();
                setState(() {
                  isPlaying = true;
                });
              }
            },
            child: Text(isPlaying ? 'Parar reprodução' : 'Reproduzir áudio'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }
}
