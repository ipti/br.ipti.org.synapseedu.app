import 'package:audioplayers/audioplayers.dart';
import '../template_questoes/model.dart';
import '../template_questoes/question_provider.dart';
import 'package:flutter/material.dart';

// Contém alguns métodos e variáveis globais necessárias para as questões.

const String BASE_URL = 'https://elesson.com.br/app/library';

AudioPlayer player = new AudioPlayer();
void playSound(String sound) async {
  await player.play(BASE_URL + '/sound/' + sound);

  // FlutterRingtonePlayer.playNotification();
}

Widget soundButton(BuildContext context, Question question) {
  return question.header["sound"].isNotEmpty
      ? IconButton(
          icon: Icon(Icons.volume_up),
          highlightColor: Theme.of(context).primaryColor,
          splashColor: Theme.of(context).primaryColor,
          onPressed: () {
            playSound(question.header["sound"]);
          },
        )
      : null;
}
