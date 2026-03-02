import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crm_app/view/crm_screen.dart' ;

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
      home: WebViewScreen() ,
    );
  }
}
  