import 'dart:typed_data';

import 'package:dartz/dartz.dart';
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

  Future<Either<Failure, void>> getAndPlaySoundByMultimediaId(int multimediaId, Map<int, int> soundIdByMultimediaId, Soundpool soundpool) async {
    if (soundIdByMultimediaId[multimediaId] == null) {
      Either<Failure, String> audioString = await multimediaRepository.getSoundByMultimediaId(multimediaId);

      await audioString.fold((l) => l, (r) async {
        Either<Failure, Stream<Uint8List>> resStreamAudio = await multimediaRepository.downloadSound(r);
        await resStreamAudio.fold((l) => l, (r) async {
          await for (final element in r) {
            //Adicionar audio a SoundPool
            int soundId = await soundpool.loadUint8List(element);
            if (soundId > -1) {
              soundIdByMultimediaId[multimediaId] = soundId;
            }
            playSound(multimediaId, soundIdByMultimediaId, soundpool);
          }
          print("Play Without Cache");
        });
      });
    } else {
      playSound(multimediaId, soundIdByMultimediaId, soundpool);
    print("PLAY WITH CACHE");
    }


    return Left(Failure("Erro desconhecido"));
  }

  Future<void> playSound(int multimediaId, Map<int, int> soundIdByMultimediaId, Soundpool soundpool) async {
    int soundId = soundIdByMultimediaId[multimediaId] ?? 0;
    await soundpool.play(soundId);
    return;
  }

  //read Text Of Image
  Future<Either<Failure, String>> readTextOfImage() async {
    return await multimediaRepository.readTextOfImage();
  }
}
