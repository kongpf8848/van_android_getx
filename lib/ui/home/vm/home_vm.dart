import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:van_android_getx/api/van_api.dart';
import 'package:van_android_getx/utils/toast_utils.dart';
import 'package:van_android_getx/model/home_article_info.dart';
import 'package:van_android_getx/model/home_banner_info.dart';

class HomeVM extends GetxController {
  // Banner
  var bannerItems = List<HomeBannerInfo>.empty(growable: true).obs;

  // 文章
  var homeArticleInfoItems = List<ArticleInfo>.empty(growable: true).obs;
  var currentPage = 0; // 当前页数

  // 拉取Banner
  Future fetchHomeBanner() async {
    var result = await VanApi.homeBanner();
    bannerItems.value = result ?? [];
  }

  // 拉取文章
  Future<void> fetchArticleList({bool? isRefresh = false}) async {
    if (isRefresh == true) {
      currentPage = 0;
      homeArticleInfoItems.clear();
    } else {
      currentPage++;
    }
    var result = await VanApi.homeArticleList(currentPage);
    homeArticleInfoItems.addAll((result?.datas ?? []));
  }

  @override
  void onInit() {
    super.onInit();
    // 页面初始化的时候拉下数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHomeBanner();
      fetchArticleList(isRefresh: true);
    });
  }
}
