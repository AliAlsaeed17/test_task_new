import 'package:get/get.dart';
import 'package:test_task/core/router/get_routes.dart';
import 'package:test_task/data/models/user_model.dart';
import 'package:test_task/data/repositories/user_repository.dart';
import 'package:test_task/presentation/widgets/snackbars.dart';

class UserController extends GetxController {
  User? user;
  String name = '';
  String countryCode = '';
  String phone = '';
  String email = '';
  final UserRepository _repository = UserRepository();

  Future<bool> getUser(id, token) async {
    final result = await _repository.getUser(id: id, token: token);
    return result.fold(
      (failure) => false,
      (userData) {
        user = userData;
        return true;
      },
    );
  }

  Future<void> updateUserInfo() async {
    final result = await _repository.updateUser(
        name: name, countryCode: countryCode, phone: phone, email: email);
    result.fold(
      (failure) {
        SnackBars.showError(failure.message);
      },
      (userData) {
        user = userData.$2;
        SnackBars.showSuccess(userData.$1);
        update();
      },
    );
  }

  Future<void> deleteAccount() async {
    final result = await _repository.deleteUser();
    result.fold(
      (failure) {
        SnackBars.showError(failure.message);
      },
      (message) {
        SnackBars.showSuccess(message);
        Get.offAllNamed(AppRoutes.welcomeScreen);
      },
    );
  }
}
