import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:van_android_getx/api/van_api.dart';
import 'package:van_android_getx/utils/toast_utils.dart';
import 'package:van_android_getx/model/wx_account_info.dart';

class WxVM extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  var wxAccounts = List<WxAccountInfo>.empty(growable: true).obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchWXAccounts();
    });
  }

  // 拉取公众号列表
  Future<void> fetchWXAccounts({bool? isRefresh = false}) async {
    var result = await VanApi.wxAccounts();
    wxAccounts.addAll(result ?? []);
    tabController = TabController(length: wxAccounts.length, vsync: this);
    tabController?.addListener(() {
      if (!tabController!.indexIsChanging) {}
    });
  }

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }
}
