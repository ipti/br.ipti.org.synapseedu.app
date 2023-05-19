import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/task/data/datasource/multimedia_remote_datasource.dart';
import 'package:elesson/app/core/task/data/repository/multimedia_repository_interface.dart';
import 'package:elesson/app/util/failures/failures.dart';

class MultimediaRepositoryImpl extends IMultimediaRepository{
  final IMultimediaRemoteDatasource multimediaRemoteDataSource;

  MultimediaRepositoryImpl({required this.multimediaRemoteDataSource});

  @override
  Future<Either<Failure, String>> getTextById(int id) async {
    try {
      final multimedia = await multimediaRemoteDataSource.getTextById(id);
      return Right(multimedia);
    } on Exception {
      return Left(Failure("Erro desconhecido"));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getBytesByMultimediaId(int id) async {
    try {
      final referenceImage = await multimediaRemoteDataSource.getImageMultimediaReference(id);
      final bytes = await multimediaRemoteDataSource.getBytesByMultimediaReference(referenceImage);
      return Right(bytes);
    } on Exception {
      return Left(Failure("Erro desconhecido"));
    }
  }

}