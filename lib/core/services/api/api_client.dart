import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get_storage/get_storage.dart';
import 'package:van_android_getx/core/services/api/exceptions.dart';
import 'package:van_android_getx/core/utils/logger_utils.dart';
import 'package:van_android_getx/generated/json/base/json_convert_content.dart';

typedef ProgressCallback = void Function(int received, int total);

class ApiClient extends GetConnect {
  String? cookies;

  bool get isLogin => null != cookies && cookies!.isNotEmpty;

  @override
  void onInit() async {
    baseUrl = "https://wanandroid.com/";
    timeout = const Duration(seconds: 30);
    findProxy = (url) {
      return "PROXY 192.168.124.87:9000";
    };
    maxAuthRetries = 3;
    allowAutoSignedCert = true;
    // 读取本地存储的Cookie
    cookies = Get.find<GetStorage>().read("Cookie");
    // 添加请求拦截器,设置Cookie
    httpClient.addRequestModifier<void>((request) {
      if (cookies != null) {
        request.headers['Cookie'] = cookies!;
      } else {
        if (request.headers.containsKey("Cookie")) {
          request.headers.remove("Cookie");
        }
      }
      return request;
    });
    // 添加拦截器打印日志
    httpClient.addResponseModifier<dynamic>((request, response) {
      request.bodyBytes.bytesToString().then((value) => {
            LogUtil.d("Request headers: ${request.headers}"),
            LogUtil.d("Request Url: ${request.url}"),
            LogUtil.d("Request Body: $value"),
            LogUtil.d("Response headers: ${response.headers}"),
            LogUtil.d("Response Body: ${response.body}")
          });
      return response;
    });
    super.onInit();
  }

  void updateCookies(String? cookies) {
    this.cookies = cookies;
    Get.find<GetStorage>().write("Cookie", cookies);
  }

  Future<R> getX<R>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
  }) {
    return _performRequestX(
      () => get(url, contentType: contentType, headers: headers, query: query),
    );
  }

  Future<R> postX<R>(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Progress? uploadProgress,
  }) {
    return _performRequestX(
      () => post(
        url,
        body,
        contentType: contentType,
        headers: headers,
        query: query,
        uploadProgress: uploadProgress,
      ),
    );
  }

  Future<Response> upload(File file) async {
    final form = FormData({
      'file': MultipartFile(file.readAsBytesSync(), filename: 'avatar.jpg'),
      'description': '用户头像文件',
    });

    return _performRequestX(
      () => post(
        'upload',
        form,
        uploadProgress: (progress) {
          print('上传进度: ${progress * 100}%');
        },
      ),
    );
  }

  Future<bool> download(
    String url,
    String path, {
    ProgressCallback? downloadProgress,
  }) async {
    RandomAccessFile? randomAccessFile;
    try {
      final file = File(path);
      final directory = file.parent;
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }
      final request = await HttpClient().getUrl(Uri.parse(url));
      final response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var received = 0;
        var total = response.contentLength;
        randomAccessFile = await file.open(mode: FileMode.write);
        await for (var chunk in response) {
          await randomAccessFile.writeFrom(chunk);
          received += chunk.length;
          if (downloadProgress != null && total > 0) {
            downloadProgress(received, total);
          }
        }
        return true;
      } else {
        print('下载失败：HTTP ${response.statusCode}');
        return false;
      }
    } on SocketException catch (e) {
      print('网络错误：$e');
      return false;
    } on FileSystemException catch (e) {
      print('文件系统错误：$e');
      return false;
    } catch (e) {
      print('下载异常：$e');
      return false;
    } finally {
      await randomAccessFile?.close();
    }
  }

  // 请求响应的通用处理封装
  Future<R> _performRequestX<R>(Future<Response> Function() requestCall) async {
    try {
      // 加载对话框
      showLoadingDialog();
      // 执行对应的网络请求
      Response response = await requestCall();
      // 获取响应内容
      var responseObject = response.body;
      if (response.statusCode == 200 && responseObject != null) {
        print("+++++++++++++++++responseData:${responseObject['data']}");
        switch (responseObject['errorCode']) {
          case 0:
            if (responseObject['data'] == null) {
              return null as R;
            }
            final parsed = JsonConvert.fromJsonAsT<R>(responseObject['data']);
            if (parsed == null) {
              return null as R;
            }
            return parsed;
          default:
            throw ApiException(
              responseObject['errorCode'],
              responseObject['errorMsg'],
            );
        }
      } else {
        throw ApiException(-1, "错误响应格式");
      }
    } catch (e) {
      throw ApiException.from(e);
    } finally {
      // 判断有对话框打开才关闭
      if (Get.isDialogOpen == true) Get.back();
    }
  }

  void showLoadingDialog({bool canPop = true}) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => canPop, // 根据canPop参数决定是否允许关闭对话框
        child: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: Card(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // 指定一个固定不变的颜色
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Get.theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
