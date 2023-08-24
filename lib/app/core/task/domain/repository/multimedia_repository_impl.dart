import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:elesson/app/core/task/data/datasource/multimedia_remote_datasource.dart';
import 'package:elesson/app/core/task/data/repository/multimedia_repository_interface.dart';
import 'package:elesson/app/util/failures/failures.dart';
import 'package:elesson/share/google_api.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<String> converter(File imageFile) async {
    List<int> imageBytes = imageFile.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  Future<String> pickImage() async {
      ImagePicker picker = ImagePicker();

      XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
      );

      File imageFile = File(pickedFile!.path);

      return await converter(imageFile);
  }

  @override
  Future<Either<Failure, String>> readTextOfImage() async {
    try{
      String base64Image = await pickImage();
      String googleApiToken = await getGoogleApiToken();
      String textOfImage = await multimediaRemoteDataSource.getTextOfImage(base64Image, googleApiToken);
      return Right(textOfImage);
    } on Exception {
      return Left(Failure("Erro desconhecido"));
    }
  }


}