import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:van_android_getx/ui/main/main_bindings.dart';
import 'package:van_android_getx/theme/theme_vm.dart';
import 'ui/main/main_page.dart';

void main() async {
  await GetStorage.init();
  final themeVM = Get.put(ThemeVM());
  runApp(
    Obx(
      () => GetMaterialApp(
        theme: themeVM.currentTheme.value,
        initialBinding: MainBindings(),
        home: const MainPage(),
      ),
    ),
  );
}
