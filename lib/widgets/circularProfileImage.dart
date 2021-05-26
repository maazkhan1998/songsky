import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';

class CircularProfileImage extends StatefulWidget {
  final File? image;

  CircularProfileImage(this.image);
  @override
  _CircularProfileImageState createState() => _CircularProfileImageState();
}

class _CircularProfileImageState extends State<CircularProfileImage> {

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        height: ScreenUtil().setHeight(130),
        width: ScreenUtil().setHeight(130),
        decoration: BoxDecoration(shape: BoxShape.circle),
      ),
      Container(
        height: ScreenUtil().setHeight(100),
        width: ScreenUtil().setHeight(100),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 5),
          boxShadow: [
            BoxShadow(
                blurRadius: 10, color: Colors.grey[200]!, offset: Offset(0, 2)),
            BoxShadow(
                blurRadius: 10, color: Colors.grey[200]!, offset: Offset(2, 0)),
            BoxShadow(
                blurRadius: 10, color: Colors.grey[200]!, offset: Offset(-2, 0)),
            BoxShadow(
                blurRadius: 10, color: Colors.grey[200]!, offset: Offset(0, -2))
          ],
        ),
        child: CircleAvatar(
          radius: ScreenUtil().setHeight(50),
          backgroundImage: widget.image==null?AssetImage('assets/images/web_hi_res_512.png') as ImageProvider:FileImage(widget.image!)
        ),
      ),
        Positioned(
          top: ScreenUtil().setHeight(90),
          left: ScreenUtil().setWidth(100),
          child: CircleAvatar(
            backgroundColor: Colors.blue[900],
            child: FaIcon(FontAwesomeIcons.camera,
                color: Colors.white, size: 18),
          ),
        )
    ]);
  }
}
