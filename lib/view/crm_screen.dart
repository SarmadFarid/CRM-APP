import 'package:crm_app/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {
  const WebViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CRMWebController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        bool canExit = await controller.handleBack();

        if (canExit) {
          final result = await showExitDialog(); 

          if (result == true) {
            SystemNavigator.pop();  // close app
          }
        }
      },

      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          top: true, 
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.refreshPage,
                child: WebViewWidget(controller: controller.webController),
              ),
              Obx(() {
                return controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }


  Future<bool?> showExitDialog() {
  return Get.dialog<bool>(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.red,
                size: 32,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "Exit App",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Are you sure you want to exit the application?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(result: false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(result: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Exit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
}
