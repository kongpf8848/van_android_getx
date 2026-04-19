import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:van_android_getx/api/van_api.dart';
import 'package:van_android_getx/utils/toast_utils.dart';
import 'package:van_android_getx/model/home_article_info.dart';

class WxArticleListVM extends GetxController {
  final int wxId; // 微信公众号ID
  WxArticleListVM(this.wxId);

  // 文章列表
  var articleInfoItems = List<ArticleInfo>.empty(growable: true).obs;
  var currentPage = 0; // 当前页数

  // 拉取文章
  Future<void> fetchArticleList({bool? isRefresh = false}) async {
    if (isRefresh == true) {
      currentPage = 0;
      articleInfoItems.clear();
    } else {
      currentPage++;
    }
    var result = await VanApi.wxArticleList(wxId, currentPage);
    articleInfoItems.addAll((result?.datas ?? []));
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchArticleList();
    });
  }
}
