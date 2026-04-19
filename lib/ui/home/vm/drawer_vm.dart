import 'package:get/get.dart';
import 'package:van_android_getx/api/van_api.dart';
import 'package:van_android_getx/utils/toast_utils.dart';
import 'package:van_android_getx/ui/account/account_vm.dart';

class DrawerVm extends GetxController {
  // 查询积分
  Future<void> fetchCoin() async {
    final result = await VanApi.requestCoin();
    Get.find<AccountVM>().accountInfo.update((accountInfo) {
      accountInfo?.coinCount = result?.coinCount;
      showToast(msg: "积分刷新成功");
    });
  }
}
