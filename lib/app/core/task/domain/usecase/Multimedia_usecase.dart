import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:elesson/app/core/task/data/repository/multimedia_repository_interface.dart';
import 'package:elesson/app/util/failures/failures.dart';
import 'package:elesson/share/question_widgets.dart';
import 'package:soundpool/soundpool.dart';

class MultimediaUseCase {
  final IMultimediaRepository multimediaRepository;

  MultimediaUseCase({required this.multimediaRepository});

  Future<Either<Failure, String>> getTextById(int id) async {
    return await multimediaRepository.getTextById(id);
  }

  Future<Either<Failure, List<int>>> getBytesByMultimediaId(int id) async {
    return await multimediaRepository.getBytesByMultimediaId(id);
  }

  int cont = 0;
  bool audioBlocked = false;

  Future<Either<Failure, void>> getAndPlaySoundByMultimediaId(int multimediaId, Map<int, int> soundIdByMultimediaId, Soundpool soundpool) async {
    if(audioBlocked) return Left(Failure("Audio bloqueado"));
    audioBlocked = true;
    cont++;

    if (soundIdByMultimediaId[multimediaId] == null) {
      Either<Failure, String> audioString = await multimediaRepository.getSoundByMultimediaId(multimediaId);

      audioString.fold((l) => l, (r) async {
        Either<Failure, Stream<Uint8List>> resStreamAudio = await multimediaRepository.downloadSound(r);
        resStreamAudio.fold((l) => l, (stream) async {
          Uint8List bytes = Uint8List.fromList([]);
          await for (final element in stream) bytes = Uint8List.fromList([...bytes, ...element]);
          int soundId = await soundpool.loadUint8List(bytes);
          if (soundId > -1) soundIdByMultimediaId[multimediaId] = soundId;
          await playSound(multimediaId, soundIdByMultimediaId, soundpool);
          audioBlocked = false;
        });
      });
    } else {
      await playSound(multimediaId, soundIdByMultimediaId, soundpool);
      audioBlocked = false;

    }


    return Left(Failure("Erro desconhecido"));
  }

  Future<void> playSound(int multimediaId, Map<int, int> soundIdByMultimediaId, Soundpool soundpool) async {
    if (soundIdByMultimediaId[multimediaId] == null) return;
    int streamId = await soundpool.play(soundIdByMultimediaId[multimediaId]!));
    soundpool.onPlayerStateChanged.listen((event) {
      if (event == null) return;
      if (event == SoundpoolPlayerState.STOPPED) {
        soundpool.stop(streamId);
        soundpool.dispose();
        soundIdByMultimediaId.remove(multimediaId);
      }
    });
    return;
  }

  //read Text Of Image
  Future<Either<Failure, String>> readTextOfImage() async {
    return await multimediaRepository.readTextOfImage();
  }
}
