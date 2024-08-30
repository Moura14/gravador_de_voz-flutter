import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayScreens extends StatefulWidget {
  final List<String> audioPaths;

  const PlayScreens({super.key, required this.audioPaths});

  @override
  State<PlayScreens> createState() => _PlayScreensState();
}

class _PlayScreensState extends State<PlayScreens> {
  final AudioPlayer audioPlayer = AudioPlayer();
  int? selectedAudioIndex;
  bool isPlaying = false;

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final audioPath = widget.audioPaths[index];
        return ListTile(
          title: Text('Áudio ${index + 1}'),
          leading: const Icon(Icons.music_note),
          trailing: IconButton(
              onPressed: () async {
                if (selectedAudioIndex == index && isPlaying) {
                  await audioPlayer.stop();
                  setState(() {
                    isPlaying = false;
                    selectedAudioIndex = null;
                  });
                } else {
                  await audioPlayer.setFilePath(audioPath);
                  await audioPlayer.play();
                  setState(() {
                    isPlaying = true;
                    selectedAudioIndex = index;
                  });
                }
              },
              icon: Icon(selectedAudioIndex == index && isPlaying
                  ? Icons.stop
                  : Icons.play_arrow)),
        );
      },
      itemCount: widget.audioPaths.length,
    ));
  }
}
