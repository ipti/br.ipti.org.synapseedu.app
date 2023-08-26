import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:elesson/app/util/failures/failures.dart';

abstract class IMultimediaRepository {
  Future<Either<Failure, String>> getTextById(int id);

  Future<Either<Failure, List<int>>> getBytesByMultimediaId(int id);

  Future<Either<Failure, String>> readTextOfImage();

  Future<Either<Failure, String>> getSoundByMultimediaId(int id);

  Future<Either<Failure, Stream<Uint8List>>> downloadSound(String nameAudio);
}