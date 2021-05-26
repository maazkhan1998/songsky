import 'package:flutter/material.dart';

progressIndicator(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              children: <Widget>[
                Center(
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromRGBO(10, 110, 226, 1)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
      barrierDismissible: false);
}

customErrorDialog(context,String title,String body){
  return showDialog(
    context: context,
    builder: (context)=>SimpleDialog(
      contentPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side:BorderSide(
          color: Colors.black,width: 5
        )
      ),
      children: [
        Center(
          child: Text('Error',style:TextStyle(
            color:Colors.red,fontSize:18,fontWeight:FontWeight.bold
          )),
        ),
        SizedBox(height:10),
        Text(body)
      ],
    )
  );
}