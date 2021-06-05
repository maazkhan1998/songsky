import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_clean/model/songModel.dart';
import 'package:new_clean/screens/Songspage.dart';
import 'package:new_clean/widgets/emailNameTextField.dart';
import '../screens/marketScreen.dart';

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

tokenDialog(BuildContext context,SongModel song){
  TextEditingController controller=TextEditingController();
  return showDialog(context: context,
   builder: (_)=>SimpleDialog(
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(10)
     ),
     contentPadding: EdgeInsets.all(20),
     children: [
       EmailNameTextField(
       text: 'Enter number of tokens',controller: controller,type: TextInputType.number,icon: Icon(FontAwesomeIcons.coins)),
       SizedBox(height: 20,),
       Row(
         mainAxisAlignment: MainAxisAlignment.end,
         children: [
           TextButton(onPressed: ()=>Navigator.of(context).pop(), child: Text('Cancel')),
           SizedBox(width: 20,),
           TextButton(onPressed: ()async{
             if(!isNumeric(controller.text)) {
               Fluttertoast.showToast(msg: 'Invalid input');
               return;
             }
             if(int.parse(controller.text)<=0){
               Fluttertoast.showToast(msg: 'Token quantity should be greater than zero');
               return;
             }
             progressIndicator(context);
            await onDonateToken(context, song, int.parse(controller.text));
             Navigator.of(context,rootNavigator: true).pop();
             Navigator.of(context).pop();
           },
            child: Text('Send'))
         ],
       )
     ], 
     )
   );
}