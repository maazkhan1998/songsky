import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_clean/utils/AppTheme.dart';
import 'package:new_clean/utils/SizeConfig.dart';

class PasswordTextField extends StatefulWidget {

  final String text;
  final TextEditingController controller;

  PasswordTextField({required this.text,required this.controller});
  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {

  late ThemeData themeData;

  bool _passwordVisible=true;
  @override
  Widget build(BuildContext context) {
    themeData=Theme.of(context);
    return Container(
                          margin: EdgeInsets.only(top: MySize.size16),
                          child: TextFormField(
                            controller: widget.controller,
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
                              hintText: widget.text,
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
                        );
  }
}