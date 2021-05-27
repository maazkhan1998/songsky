import 'package:flutter/material.dart';
import 'package:new_clean/utils/AppTheme.dart';
import 'package:new_clean/utils/SizeConfig.dart';

class OnSubmitButton extends StatefulWidget {

  final Function func;
  final String text;

  OnSubmitButton({required this.func,required this.text});
  @override
  _OnSubmitButtonState createState() => _OnSubmitButtonState();
}

class _OnSubmitButtonState extends State<OnSubmitButton> {

  late ThemeData themeData;
  @override
  Widget build(BuildContext context) {
    themeData=Theme.of(context);
    return Container(
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
                              onPressed:()=>widget.func(),
                              child: Text(
                                widget.text,
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
    );
  }
}