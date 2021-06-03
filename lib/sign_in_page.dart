import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_clean/provider/authentication_service.dart';
import 'package:new_clean/utils/AppTheme.dart';
import 'package:new_clean/utils/SizeConfig.dart';
import 'package:new_clean/utils/validators.dart';
import 'package:new_clean/widgets/dialogs.dart';
import 'package:new_clean/widgets/emailNameTextField.dart';
import 'package:new_clean/widgets/onSubmitButton.dart';
import 'package:new_clean/widgets/passwordTextField.dart';
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
                  EmailNameTextField(
                    controller: emailController,
                    text: 'Email Address',
                    type: TextInputType.emailAddress,
                    icon: Icon(
                                MdiIcons.emailOutline,
                                size: MySize.size22,
                              ),
                  ),
                        PasswordTextField(text: 'Password', controller: passwordController),
                        OnSubmitButton(
                          text: 'Sign In',
                          func: onLogin,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: MySize.size16),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
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
