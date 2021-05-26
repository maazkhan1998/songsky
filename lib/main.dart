import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:new_clean/provider/authentication_service.dart';
import 'package:new_clean/home_page.dart';
import 'package:new_clean/sign_in_page.dart';
import 'package:new_clean/utils/SizeConfig.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<void> main() async{
  InAppPurchaseConnection.enablePendingPurchases();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
          builder:()=> MultiProvider(
        providers: [
         ChangeNotifierProvider(
           create: (_)=>AuthenticationService(),
         )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.grey,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: AuthenticationWrapper(),
        ),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthenticationService>(context).currentUser;
    if(user==null)return SignInPage();
    else return HomePage();
  }
}

