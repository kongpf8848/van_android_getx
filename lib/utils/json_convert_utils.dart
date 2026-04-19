import 'package:van_android_getx/model/account_info.dart';
import 'package:van_android_getx/model/account_login.dart';
import 'package:van_android_getx/model/account_register.dart';
import 'package:van_android_getx/model/base_response.dart';
import 'package:van_android_getx/model/home_article_info.dart';
import 'package:van_android_getx/model/home_banner_info.dart';
import 'package:van_android_getx/model/integral.dart';
import 'package:van_android_getx/model/navi_info.dart';
import 'package:van_android_getx/model/study_system_info.dart';
import 'package:van_android_getx/model/wx_account_info.dart';
import 'package:van_android_getx/model/wx_article_list.dart';

final JsonConvert jsonConvert = JsonConvert();

typedef JsonConvertFunction<T> = T Function(Map<String, dynamic> json);
typedef JsonConvertListFunction = List<dynamic> Function(
    List<Map<String, dynamic>> data);
typedef ConvertExceptionHandler = void Function(
    Object error, StackTrace stackTrace);

class JsonConvert {
  static ConvertExceptionHandler? onError;
  JsonConvertHelper convertHelper = JsonConvertHelper();

  /// 将json转化为对应的类型
  static T? fromJsonAsT<T>(dynamic json) {
    if (json == null) {
      return null;
    }
    if (json is T) {
      return json;
    }
    try {
      if (json is List) {
        return jsonConvert._convertList<T>(
            json.map((dynamic e) => e as Map<String, dynamic>).toList());
      } else {
        return jsonConvert._convert<T>(json);
      }
    } catch (e, stackTrace) {
      return jsonConvert._onConvertError<T?>(e, stackTrace, null);
    }
  }

  T? _convert<T>(dynamic value) {
    final String type = T.toString();
    final String normalizedType =
        type.endsWith('?') ? type.substring(0, type.length - 1) : type;
    final String valueS = value.toString();
    if (normalizedType == "String") {
      return valueS as T;
    } else if (normalizedType == "int") {
      final int? intValue = int.tryParse(valueS);
      if (intValue == null) {
        return double.tryParse(valueS)?.toInt() as T?;
      } else {
        return intValue as T;
      }
    } else if (normalizedType == "double") {
      return double.parse(valueS) as T;
    } else if (normalizedType == "DateTime") {
      return DateTime.parse(valueS) as T;
    } else if (normalizedType == "bool") {
      if (valueS == '0' || valueS == '1') {
        return (valueS == '1') as T;
      }
      return (valueS == 'true') as T;
    } else if (normalizedType == "Map" || normalizedType.startsWith("Map<")) {
      return value as T;
    } else {
      final covertFunc = convertHelper.convertFuncMap[normalizedType];
      if (covertFunc == null) {
        throw UnimplementedError(
            '$type unimplemented,you can try running the app again');
      }
      final mapValue = value is Map<String, dynamic>
          ? value
          : Map<String, dynamic>.from(value as Map);
      return covertFunc(mapValue) as T;
    }
  }

  T? _convertList<T>(List<Map<String, dynamic>> data) {
    final String type = T.toString();
    final String normalizedType =
        type.endsWith('?') ? type.substring(0, type.length - 1) : type;
    final listConvertFunc = convertHelper.listConvertFuncMap[normalizedType];
    if (listConvertFunc == null) {
      throw UnimplementedError(
          '$type unimplemented,you can try running the app again');
    }
    return listConvertFunc(data) as T?;
  }

  T _onConvertError<T>(Object error, StackTrace stackTrace, T fallback) {
    if (onError != null) {
      onError!(error, stackTrace);
    }
    return fallback;
  }
}

class JsonConvertHelper {
  final Map<String, JsonConvertListFunction> listConvertFuncMap = {
    (List<AccountInfo>).toString(): (List<Map<String, dynamic>> data) => data
        .map<AccountInfo>((Map<String, dynamic> e) => AccountInfo.fromJson(e))
        .toList(),
    (List<AccountLoginReq>).toString(): (List<Map<String, dynamic>> data) =>
        data
            .map<AccountLoginReq>(
                (Map<String, dynamic> e) => AccountLoginReq.fromJson(e))
            .toList(),
    (List<AccountRegisterReq>).toString(): (List<Map<String, dynamic>> data) =>
        data
            .map<AccountRegisterReq>(
                (Map<String, dynamic> e) => AccountRegisterReq.fromJson(e))
            .toList(),
    (List<Article>).toString(): (List<Map<String, dynamic>> data) => data
        .map<Article>((Map<String, dynamic> e) => Article.fromJson(e))
        .toList(),
    (List<ArticleInfo>).toString(): (List<Map<String, dynamic>> data) => data
        .map<ArticleInfo>((Map<String, dynamic> e) => ArticleInfo.fromJson(e))
        .toList(),
    (List<BaseResponse>).toString(): (List<Map<String, dynamic>> data) => data
        .map<BaseResponse>((Map<String, dynamic> e) =>
            BaseResponse<dynamic>.fromJson(e, (dynamic json) => json))
        .toList(),
    (List<HomeArticleInfo>).toString(): (List<Map<String, dynamic>> data) =>
        data
            .map<HomeArticleInfo>(
                (Map<String, dynamic> e) => HomeArticleInfo.fromJson(e))
            .toList(),
    (List<HomeBannerInfo>).toString(): (List<Map<String, dynamic>> data) => data
        .map<HomeBannerInfo>(
            (Map<String, dynamic> e) => HomeBannerInfo.fromJson(e))
        .toList(),
    (List<Integral>).toString(): (List<Map<String, dynamic>> data) => data
        .map<Integral>((Map<String, dynamic> e) => Integral.fromJson(e))
        .toList(),
    (List<NaviInfo>).toString(): (List<Map<String, dynamic>> data) => data
        .map<NaviInfo>((Map<String, dynamic> e) => NaviInfo.fromJson(e))
        .toList(),
    (List<StudySystemInfo>).toString(): (List<Map<String, dynamic>> data) =>
        data
            .map<StudySystemInfo>(
                (Map<String, dynamic> e) => StudySystemInfo.fromJson(e))
            .toList(),
    (List<Tag>).toString(): (List<Map<String, dynamic>> data) =>
        data.map<Tag>((Map<String, dynamic> e) => Tag.fromJson(e)).toList(),
    (List<WxAccountInfo>).toString(): (List<Map<String, dynamic>> data) => data
        .map<WxAccountInfo>(
            (Map<String, dynamic> e) => WxAccountInfo.fromJson(e))
        .toList(),
    (List<WxArticleList>).toString(): (List<Map<String, dynamic>> data) => data
        .map<WxArticleList>(
            (Map<String, dynamic> e) => WxArticleList.fromJson(e))
        .toList(),
  };

  final Map<String, JsonConvertFunction> convertFuncMap = {
    (AccountInfo).toString(): AccountInfo.fromJson,
    (AccountLoginReq).toString(): AccountLoginReq.fromJson,
    (AccountRegisterReq).toString(): AccountRegisterReq.fromJson,
    (Article).toString(): Article.fromJson,
    (ArticleInfo).toString(): ArticleInfo.fromJson,
    (HomeArticleInfo).toString(): HomeArticleInfo.fromJson,
    (HomeBannerInfo).toString(): HomeBannerInfo.fromJson,
    (Integral).toString(): Integral.fromJson,
    (NaviInfo).toString(): NaviInfo.fromJson,
    (StudySystemInfo).toString(): StudySystemInfo.fromJson,
    (Tag).toString(): Tag.fromJson,
    (WxAccountInfo).toString(): WxAccountInfo.fromJson,
    (WxArticleList).toString(): WxArticleList.fromJson,
  };

  bool containsKey(String type) {
    return convertFuncMap.containsKey(type);
  }

  JsonConvertFunction? operator [](String key) {
    return convertFuncMap[key];
  }
}
