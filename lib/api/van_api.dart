import 'package:get/get.dart';
import 'package:van_android_getx/model/account_login.dart';
import 'package:van_android_getx/model/account_register.dart';
import 'package:van_android_getx/model/account_info.dart';
import 'package:van_android_getx/model/home_article_info.dart';
import 'package:van_android_getx/model/home_banner_info.dart';
import 'package:van_android_getx/model/integral.dart';
import 'package:van_android_getx/model/navi_info.dart';
import 'package:van_android_getx/model/study_system_info.dart';
import 'package:van_android_getx/model/wx_account_info.dart';
import 'package:van_android_getx/model/wx_article_list.dart';

import 'api_client.dart';

class VanApi {
  // 是否处于登录状态
  static bool isLogin() => Get.find<ApiClient>().isLogin;

  // 更新Cookies
  static updateCookies(String cookies) =>
      Get.find<ApiClient>().updateCookies(cookies);

  // 请求登录
  static Future<AccountInfo?> login(AccountLoginReq req) =>
      Get.find<ApiClient>().postX("user/login", query: req.toJson());

  // 请求注册
  static Future<AccountInfo> register(AccountRegisterReq req) =>
      Get.find<ApiClient>().postX("user/register", query: req.toJson());

  // 查询积分
  static Future<Integral?> requestCoin() =>
      Get.find<ApiClient>().getX("lg/coin/userinfo/json");

  // 首页文章
  static Future<HomeArticleInfo?> homeArticleList(int currentPage) =>
      Get.find<ApiClient>().getX("article/list/$currentPage/json");

  // 首页Banner
  static Future<List<HomeBannerInfo>?> homeBanner() =>
      Get.find<ApiClient>().getX("banner/json");

  // 公众号列表
  static Future<List<WxAccountInfo>?> wxAccounts() =>
      Get.find<ApiClient>().getX("wxarticle/chapters/json");

  // 公众号文章列表
  static Future<WxArticleList?> wxArticleList(int wxId, int currentPage) =>
      Get.find<ApiClient>().getX("wxarticle/list/$wxId/$currentPage/json");

  // 导航数据
  static Future<List<NaviInfo>?> navi() =>
      Get.find<ApiClient>().getX("navi/json");

  // 学习体系
  static Future<List<StudySystemInfo>?> studySystem() =>
      Get.find<ApiClient>().getX("tree/json");
}
