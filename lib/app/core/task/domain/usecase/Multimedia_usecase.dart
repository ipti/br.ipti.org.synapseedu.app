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

  Future<Either<Failure, void>> getAndPlaySoundByMultimediaId(int multimediaId, Map<int, List<int>> soundIdByMultimediaId, Soundpool soundpool) async {

    if (soundIdByMultimediaId[multimediaId] == null) {
      soundIdByMultimediaId[multimediaId] = List.empty(growable: true);
      Either<Failure, String> audioString = await multimediaRepository.getSoundByMultimediaId(multimediaId);

      audioString.fold((l) => l, (r) async {
        Either<Failure, Stream<Uint8List>> resStreamAudio = await multimediaRepository.downloadSound(r);
        resStreamAudio.fold((l) => l, (stream) async {
          await for (final element in stream) {
            int soundId = await soundpool.loadUint8List(element);
            if (soundId > -1) {
              soundIdByMultimediaId[multimediaId]!.add(soundId);
            }
          }
          playSound(multimediaId, soundIdByMultimediaId, soundpool);
          print("Play Without Cache");
        });
      });
    } else {
      playSound(multimediaId, soundIdByMultimediaId, soundpool);
      print("PLAY WITH CACHE");
    }

    return Left(Failure("Erro desconhecido"));
  }

  Future<void> playSound(int multimediaId, Map<int, List<int>> soundIdByMultimediaId, Soundpool soundpool) async {
    print(soundIdByMultimediaId);
    if(soundIdByMultimediaId[multimediaId] == null) return;

    // await soundIdByMultimediaId[multimediaId].forEach((element) { });
    for(int i = 0 ; i < soundIdByMultimediaId[multimediaId]!.length ; i++){
      print("play");
      await soundpool.play(soundIdByMultimediaId[multimediaId]![i]);
    }

    // soundIdByMultimediaId[multimediaId]!.forEach((soundId) async {
    //   soundpool.play(soundId);
    //   print("play");
    //   Future.delayed(Duration(seconds: 2));
    // });
    //
    return;
  }

  //read Text Of Image
  Future<Either<Failure, String>> readTextOfImage() async {
    return await multimediaRepository.readTextOfImage();
  }
}
