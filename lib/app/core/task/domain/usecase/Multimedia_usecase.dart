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

  Future<Either<Failure, Uint8List>> getSoundByMultimediaId(int multimediaId) async {
    Either<Failure, String> audioString = await multimediaRepository.getSoundByMultimediaId(multimediaId);
    return await audioString.fold((l) => Left(l), (r) async {
      Either<Failure, Stream<Uint8List>> resStreamAudio = await multimediaRepository.downloadSound(r);
      return await resStreamAudio.fold((l) => Left(l), (stream) async {
        Uint8List bytes = Uint8List.fromList([]);
        await for (final element in stream) bytes = Uint8List.fromList([...bytes, ...element]);
        return Right(bytes);
      });
    });
  }

  Future<Either<Failure, String>> readTextOfImage() async {
    return await multimediaRepository.readTextOfImage();
  }
}
