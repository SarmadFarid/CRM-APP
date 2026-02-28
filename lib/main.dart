import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized() ; 

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,  
      statusBarIconBrightness: Brightness.light,  
      statusBarBrightness: Brightness.dark,  
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: CRMWebView() ,
    );
  }
}
 

class CRMWebView extends StatefulWidget {
  const CRMWebView({super.key});

  @override
  State<CRMWebView> createState() => _CRMWebViewState();
}

class _CRMWebViewState extends State<CRMWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..addJavaScriptChannel(
        "FlutterChannel",
        onMessageReceived: (JavaScriptMessage message) {
          _showMessageFromWeb(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse("https://crm.bihtech.com"));
  }

  // ===== 1️⃣ EXIT CONFIRM DIALOG =====
  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit App"),
        content: const Text("Are you sure you want to exit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    );

    return shouldExit ?? false;
  }

  // ===== 2️⃣ MESSAGE FROM WEBSITE =====
  void _showMessageFromWeb(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
      ),
    );
  }
 
  Future<void> _refreshPage() async {
    await _controller.reload();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
           body: Stack(
            children: [
              RefreshIndicator(
                onRefresh: _refreshPage,
                child: WebViewWidget(controller: _controller),
              ),
              if (_isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
 