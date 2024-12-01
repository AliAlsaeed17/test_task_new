import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:test_task/bussiness/controllers/auth_controller.dart';
import 'package:test_task/presentation/resources/app_styles.dart';
import 'package:test_task/presentation/widgets/accept_button.dart';
import 'package:test_task/presentation/widgets/custom_app_bar.dart';
import 'package:test_task/presentation/widgets/spacer.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final authController = Get.find<AuthController>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Change Password'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 40.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: currentPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: authInputsStyle.copyWith(
                    hintText: 'Current Password',
                    prefix: Container(width: 60),
                    suffixIcon: const Icon(Icons.visibility),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Current Password required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    authController.currentPassword = value!;
                  },
                ),
                SpacerHeight(height: 20.h),
                TextFormField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: authInputsStyle.copyWith(
                    hintText: 'Password',
                    prefix: Container(width: 60),
                    suffixIcon: const Icon(Icons.visibility),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password required';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    authController.password = value!;
                  },
                ),
                SpacerHeight(height: 20.h),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: authInputsStyle.copyWith(
                    hintText: 'Confirm Password',
                    prefix: Container(width: 60),
                    suffixIcon: const Icon(Icons.visibility),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Confirm Password required';
                    } else if (value != passwordController.text) {
                      return 'Password does not match';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    authController.confirmPassword = value!;
                  },
                ),
                SpacerHeight(height: 20.h),
                AcceptButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await authController.changePassword();
                    }
                  },
                  buttonText: 'Save',
                  buttonStyle: acceptButtonStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
