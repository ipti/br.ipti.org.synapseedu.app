import 'package:dartz/dartz.dart';
import 'package:elesson/app/util/failures/failures.dart';

abstract class IMultimediaRepository {
  Future<Either<Failure, String>> getTextById(int id);

  Future<Either<Failure, List<int>>> getBytesByMultimediaId(int id);

  Future<Either<Failure, String>> readTextOfImage();
}