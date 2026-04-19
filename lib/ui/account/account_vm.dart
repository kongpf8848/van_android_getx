import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:van_android_getx/api/api_client.dart';
import 'package:van_android_getx/api/van_api.dart';
import 'package:van_android_getx/utils/logger_utils.dart';
import 'package:van_android_getx/utils/toast_utils.dart';
import 'package:van_android_getx/model/account_info.dart';
import 'package:van_android_getx/model/account_login.dart';
import 'package:van_android_getx/model/account_register.dart';
import 'package:van_android_getx/model/base_response.dart';

class AccountVM extends GetxController {
  var apiClient = Get.find<ApiClient>();
  // 用户信息
  var accountInfo = Rx<AccountInfo?>(null);
  // 登录
  var loginUserNameController = TextEditingController();
  var loginPasswordController = TextEditingController();
  // 注册
  var registerUserNameController = TextEditingController();
  var registerPasswordController = TextEditingController();
  var registerReUserNameController = TextEditingController();

  // 登录
  Future login() async {
    final username = loginUserNameController.text;
    final password = loginPasswordController.text;
    if (username.isNotEmpty && password.isNotEmpty) {
      var result = await VanApi.login(AccountLoginReq(username, password));
      parseAccountInfo(result);
    } else {
      showToast(msg: "用户名或密码不能为空");
    }
  }

  // 注册
  Future register() async {
    final username = registerUserNameController.text;
    final password = registerPasswordController.text;
    final rePassword = registerReUserNameController.text;
    if (username.isNotEmpty && password.isNotEmpty && rePassword.isNotEmpty) {
      if (password == rePassword) {
        var result = await VanApi.register(
            AccountRegisterReq(username, password, rePassword));
        parseAccountInfo(result, isLogin: false);
      } else {
        showToast(msg: "两次输入的密码不一致");
      }
    } else {
      showToast(msg: "用户名或密码不能为空");
    }
  }

  // 退出登录
  void logout() {
    accountInfo.value = null;
    apiClient.updateCookies(null);
    showToast(msg: "退出登录成功");
  }

  // 解析用户信息的通用处理方法
  void parseAccountInfo(AccountInfo? result, {bool? isLogin = true}) {
    // 更新用户状态
    accountInfo.value = result;
    var cookies = result?['set-cookie'];
    if (null != cookies) {
      VanApi.updateCookies(cookies);
      Get.find<GetStorage>().write("Cookie", cookies);
    }
    if (isLogin == true) {
      loginUserNameController.text = "";
      loginPasswordController.text = "";
      showToast(msg: "【${result!.nickname}】登录成功");
      Get.back();
    } else {
      showToast(msg: "【${result!.nickname}】注册成功");
      // 注册成功登录页面也关闭
      Get.back(result: true);
    }
  }

  @override
  void onClose() {
    super.onClose();
    loginUserNameController.dispose();
    loginPasswordController.dispose();
    registerUserNameController.dispose();
    registerPasswordController.dispose();
    registerReUserNameController.dispose();
  }
}
