import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CRMWebController extends GetxController {
  late final WebViewController webController;

  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();

    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => isLoading.value = true,
           onPageFinished: (_) {
      isLoading.value = false;

      // FORCE overlay again
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      );
    },
        ),
      )
      ..loadRequest(Uri.parse("https://crm.bihtech.com"));
  }

  Future<bool> handleBack() async {
    if (await webController.canGoBack()) {
      webController.goBack();
      return false;
    }
    return true;
  }

  Future<void> refreshPage() async {
    await webController.reload();
  }
}