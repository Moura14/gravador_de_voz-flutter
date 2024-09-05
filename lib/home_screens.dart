import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gravador_de_voz/screens/mic_screens.dart';
import 'package:gravador_de_voz/screens/play_screens.dart';
import 'package:gravador_de_voz/screens/settingns_sreens.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  int selectIndex = 0;

  final List<String> audios = [];

  Future<List<String>> getAudioFilePaths() async {
    final directory = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = Directory(directory.path).listSync();

    final List<String> audioPaths = files
        .where((file) => file.path.endsWith('.wav'))
        .map((file) => file.path)
        .toList();

    return audioPaths;
  }

  void onTapButton(int index) {
    setState(() {
      selectIndex = index;
      print(selectIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
          future: getAudioFilePaths(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Erro ao carregar áudios');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('Nenhum áudio encontrado');
            } else {
              final List<Widget> listScreen = [
                const MicScreens(),
                PlayScreens(audioPaths: snapshot.data!),
                const SettignsScreens()
              ];

              return Scaffold(
                body: Center(
                  child: listScreen.elementAt(selectIndex),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.mic), label: 'Gravar'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.play_arrow),
                        label: "Reproduzir áudio"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings), label: "Configurações")
                  ],
                  currentIndex: selectIndex,
                  onTap: onTapButton,
                ),
              );
            }
          }),
    );
  }
}
