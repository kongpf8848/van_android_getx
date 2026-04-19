import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:van_android_getx/core/services/api/van_api.dart';
import 'package:van_android_getx/core/utils/toast_utils.dart';
import 'package:van_android_getx/data/model/study_system_info.dart';

class StudySystemVM extends GetxController {
  var studySystemItems = List<StudySystemInfo>.empty(growable: true).obs;

  // 拉取导航数据
  Future<void> fetchStudySystem() async {
    var result = await VanApi.studySystem();
    studySystemItems.addAll(result ?? []);
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchStudySystem();
    });
  }
}
