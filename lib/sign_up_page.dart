import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_clean/utils/SizeConfig.dart';
import 'package:new_clean/widgets/circularProfileImage.dart';
import 'package:new_clean/widgets/emailNameTextField.dart';
import 'package:new_clean/widgets/passwordTextField.dart';
import 'package:provider/provider.dart';

import 'provider/authentication_service.dart';
import 'utils/validators.dart';
import 'widgets/dialogs.dart';
import 'widgets/onSubmitButton.dart';


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

  onPress()async{
    try{
      if(nameController.text.isEmpty) return Fluttertoast.showToast(msg: 'Enter name');
      if(!validateEmail(emailController.text)) return Fluttertoast.showToast(msg:'Invalid email');
      if(!validatePass(passwordController.text)) return Fluttertoast.showToast(msg:'Password must be 6 character length');
      if(passwordController.text!=passwordController2.text) return Fluttertoast.showToast(msg: 'Password does not match');
      progressIndicator(context);
      await Provider.of<AuthenticationService>(context,listen:false).
      signUp(email: emailController.text, password: passwordController.text,name: nameController.text,image: _image);
      Navigator.of(context,rootNavigator: true).pop();
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'Check email for verification');
    }catch(e){
      Navigator.of(context,rootNavigator: true).pop();
      customErrorDialog(context,'Error',e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    themeData=Theme.of(context);
    return Scaffold(
        backgroundColor: const Color(0xFF606060),
        body: Center(
          child: SingleChildScrollView(
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
                EmailNameTextField(text: 'Name', controller: nameController, type: TextInputType.name,
                icon: Icon(
                                Icons.person,
                                size: MySize.size22,
                              ),),
                EmailNameTextField(text: 'Email', controller: emailController, type: TextInputType.emailAddress,
                icon: Icon(
                                MdiIcons.emailOutline,
                                size: MySize.size22,
                              ),),
                PasswordTextField(text: 'Password', controller: passwordController),
                PasswordTextField(text: 'Repeat Password', controller: passwordController2),
                            OnSubmitButton(
                              text: 'Sign Up',
                              func: onPress,
                            )
              ],
            ),
          ),
        ));
  }
}
