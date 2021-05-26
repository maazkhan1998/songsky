import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_clean/provider/authentication_service.dart';
import 'package:new_clean/utils/AppTheme.dart';
import 'package:new_clean/utils/SizeConfig.dart';
import 'package:new_clean/widgets/circularProfileImage.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController passwordController2 = TextEditingController();

  final TextEditingController nameController=TextEditingController();

  File? _image=null;

  late ThemeData themeData;

  bool _passwordVisible=false;

  selectImage()async{
    final PickedFile? pickedImage=await ImagePicker().getImage(source: ImageSource.gallery);
    if(pickedImage==null){

    }
    else{
      setState(()=>_image=File(pickedImage.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData=Theme.of(context);
    return Scaffold(
        backgroundColor: const Color(0xFF606060),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal:20),
                  child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Welcome",
                  style: TextStyle(color: Colors.white, fontSize: 45)),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: selectImage,
                child: CircularProfileImage(_image)),
              Container(
                      color: Colors.white.withOpacity(0),
                            margin: EdgeInsets.only(top: MySize.size24),
                            child: TextFormField(
                              controller: nameController,
                              style: AppTheme.getTextStyle(
                                  themeData.textTheme.bodyText1!,
                                  letterSpacing: 0.1,
                                  height: 1,
                                  fontSize: 14,
                                  color: themeData.colorScheme.onBackground,
                                  fontWeight: 500),
                              decoration: InputDecoration(
                                hintText: "Name",
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
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
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
                            margin: EdgeInsets.only(top: MySize.size16),
                            child: TextFormField(
                              controller: passwordController2,
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
                                hintText: "Repeat Password",
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
                            onPressed:null,
                            child: Text(
                              "Sign Up",
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
            ],
          ),
        ));
  }
}
