import 'package:flutter/material.dart';
import 'package:new_clean/utils/AppTheme.dart';
import 'package:new_clean/utils/SizeConfig.dart';

class EmailNameTextField extends StatefulWidget {

  final String text;
  final TextEditingController controller;
  final TextInputType type;
  final Icon icon;

  EmailNameTextField({required this.text,required this.controller,required this.type,required this.icon});
  @override
  _EmailNameTextFieldState createState() => _EmailNameTextFieldState();
}

class _EmailNameTextFieldState extends State<EmailNameTextField> {

  late ThemeData themeData;
  @override
  Widget build(BuildContext context) {
    themeData=Theme.of(context);
    return Container(
                    color: Colors.white.withOpacity(0),
                          margin: EdgeInsets.only(top: MySize.size24),
                          child: TextFormField(
                            controller: widget.controller,
                            style: AppTheme.getTextStyle(
                                themeData.textTheme.bodyText1!,
                                letterSpacing: 0.1,
                                height: 1,
                                fontSize: 14,
                                color: themeData.colorScheme.onBackground,
                                fontWeight: 500),
                            decoration: InputDecoration(
                              hintText: widget.text,
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
                              prefixIcon: widget.icon,
                              isDense: true,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            keyboardType: widget.type,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        );
  }
}