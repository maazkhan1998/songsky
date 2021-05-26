import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_clean/provider/authentication_service.dart';
import 'package:new_clean/utils/AppTheme.dart';
import 'package:new_clean/utils/SizeConfig.dart';
import 'package:new_clean/utils/validators.dart';
import 'package:new_clean/widgets/dialogs.dart';
import 'package:provider/provider.dart';
import 'package:new_clean/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  late ThemeData themeData;

  bool _passwordVisible=false;

  onLogin()async{
    try{
      if(!validateEmail(emailController.text))return  Fluttertoast.showToast(msg: 'Invalid email');
      if(!validatePass(passwordController.text))return Fluttertoast.showToast(msg: 'Password length must be 6');
      progressIndicator(context);
      await context.read<AuthenticationService>().signIn(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
      Navigator.of(context,rootNavigator: true).pop();
    }
    catch(e){
      Navigator.of(context,rootNavigator: true).pop();
      customErrorDialog(context, 'Something went wrong', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData=Theme.of(context);
    MySize().init(context);
    return Scaffold(
          backgroundColor: Color(0xff252525),
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/web_hi_res_512.png'),
                fit: BoxFit.fill
              )
            ),
                      child: Center(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal:20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.white.withOpacity(0),
                          margin: EdgeInsets.only(top: MySize.size24),
                          child: TextFormField(
                            controller: emailController,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText1!,
                                letterSpacing: 0.1,
                                height: 1,
                                fontSize: 14,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 500),
                            decoration: InputDecoration(
                              hintText: "Email address",
                              hintStyle: AppTheme.getTextStyle(
                                  themeData.textTheme.subtitle2!,
                                  height: 1,
                                  fontSize: 14,
                                  letterSpacing: 0.1,
                                  color: themeData.colorScheme.onBackground,
                                  fontWeight: 500),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: themeData.colorScheme.background,
                              prefixIcon: Icon(
                                MdiIcons.emailOutline,
                                size: MySize.size22,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: MySize.size16),
                          child: TextFormField(
                            controller: passwordController,
                            autofocus: false,
                            obscureText: _passwordVisible,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText1!,
                                height: 1,
                                fontSize: 14,
                                letterSpacing: 0.1,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 500),
                            decoration: InputDecoration(
                              hintStyle: AppTheme.getTextStyle(
                                  themeData.textTheme.subtitle2!,
                                  height: 1,
                                  fontSize: 14,
                                  letterSpacing: 0.1,
                                  color: themeData.colorScheme.onBackground,
                                  fontWeight: 500),
                              hintText: "Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  borderSide: BorderSide.none),
                              filled: true,
                              fillColor: themeData.colorScheme.background,
                              prefixIcon: Icon(
                                MdiIcons.lockOutline,
                                size: MySize.size22,
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                                child: Icon(
                                  _passwordVisible
                                      ? MdiIcons.eyeOutline
                                      : MdiIcons.eyeOffOutline,
                                  size: MySize.size22,
                                ),
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(MySize.size28)),
                            boxShadow: [
                              BoxShadow(
                                color: themeData.primaryColor.withAlpha(24),
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          margin: EdgeInsets.only(top: MySize.size24),
                          child: ElevatedButton(

                            style: ButtonStyle(
                                padding: MaterialStateProperty.all(Spacing.xy(16, 0))
                            ),
                            onPressed:onLogin,
                            child: Text(
                              "Sign in",
                              style: AppTheme.getTextStyle(
                                      themeData.textTheme.bodyText2!,
                                      height: 1,
                                      fontSize: 14,
                                      color: Colors.white,

                                      fontWeight: 600)
                                  .merge(TextStyle(
                                      color: themeData.colorScheme.onPrimary)),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: MySize.size16),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SignUpPage()));
                              },
                              child: Text(
                                "I haven't an account",
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText2!,
                                    height: 1,
                                    color: Colors.blue,
                                    fontSize: 12,
                                    fontWeight: 400,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
                      ),
          ),
    );
  }
}
