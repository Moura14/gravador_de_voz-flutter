import 'package:flutter/material.dart';
import 'package:gravador_de_voz/screens/mic_screens.dart';
import 'package:gravador_de_voz/screens/play_screens.dart';
import 'package:gravador_de_voz/screens/settingns_sreens.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  int selectIndex = 0;

  final List<String> audios = [];

  static final List<Widget> _listScreens = [
    const MicScreens(),
    const PlayScreens(
      audioPaths: [
        '/data/user/0/com.example.gravador_de_voz/app_flutter/audio.wav',
        '/data/user/0/com.example.gravador_de_voz/app_flutter/audio_102.wav',
        '/data/user/0/com.example.gravador_de_voz/app_flutter/audio_304.wav'
      ],
    ),
    const SettignsScreens()
  ];

  void onTapButton(int index) {
    setState(() {
      selectIndex = index;
      print(selectIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listScreens.elementAt(selectIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: "Gravar"),
          BottomNavigationBarItem(
              icon: Icon(Icons.play_arrow), label: "Reproduzir"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Configurações"),
        ],
        onTap: onTapButton,
        currentIndex: selectIndex,
      ),
    );
  }
}
