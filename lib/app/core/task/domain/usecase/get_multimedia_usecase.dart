import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/task/data/repository/multimedia_repository_interface.dart';
import 'package:elesson/app/util/failures/failures.dart';

class GetMultimediaUseCase{
  final IMultimediaRepository multimediaRepository;

  GetMultimediaUseCase({required this.multimediaRepository});

  Future<Either<Failure, String>> getTextById(int id) async {
    return await multimediaRepository.getTextById(id);
  }

  Future<Either<Failure, List<int>>> getBytesByMultimediaId(int id) async {
    return await multimediaRepository.getBytesByMultimediaId(id);
  }

  //read Text Of Image
  Future<Either<Failure, String>> readTextOfImage() async {
    return await multimediaRepository.readTextOfImage();
  }

}