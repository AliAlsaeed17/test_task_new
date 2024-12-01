import 'package:dartz/dartz.dart';
import 'package:get/get.dart';
import 'package:test_task/core/classes/exceptions.dart';
import 'package:test_task/core/classes/failures.dart';
import 'package:test_task/data/data_sources/local/user_local_data_source.dart';
import 'package:test_task/data/data_sources/remote/user_remote_data_source.dart';
import 'package:test_task/data/models/response_model.dart' as r;
import 'package:test_task/data/models/user_model.dart';

class UserRepository {
  final UserRemoteDataSource _remoteDataSource = UserRemoteDataSource();
  final UserLocalDataSource _localDataSource = Get.find<UserLocalDataSource>();

  Future<Either<Failure, User>> getUser(
      {required int id, required String token}) async {
    try {
      r.Response response = await _remoteDataSource.getUser(id, token);
      if (response.success) {
        User user = User.fromJson(response.data);
        return Right(user);
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } on ServerException catch (failure) {
      return left(ServerFailure(message: failure.message.toString()));
    }
  }

  Future<Either<Failure, (String, User)>> updateUser(
      {required String name,
      required String countryCode,
      required String phone,
      required String email}) async {
    try {
      r.Response response = await _remoteDataSource.updateUser({
        'name': name,
        'country_code': countryCode,
        'phone': phone,
        'email': email,
      });
      if (response.success) {
        User user = User.fromJson(response.data);
        return Right((response.message, user));
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } on ServerException catch (failure) {
      return left(ServerFailure(message: failure.message.toString()));
    }
  }

  Future<Either<Failure, String>> deleteUser() async {
    try {
      r.Response response = await _remoteDataSource.deleteUser();
      if (response.success) {
        await _localDataSource.removeUserToken();
        await _localDataSource.removeUserId();
        return Right((response.message));
      } else {
        return Left(ServerFailure(message: response.message));
      }
    } on ServerException catch (failure) {
      return left(ServerFailure(message: failure.message.toString()));
    }
  }
}
