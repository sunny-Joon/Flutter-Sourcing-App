



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommonAction{
  showAlertDialog(BuildContext context,String title,String message,String button) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Text(button),
                  ],
                ),
                onPressed: () {
                  // Navigator.of(context).pop();
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }


  /*Widget okButton = FlatButton(
      child: Text(button),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );*/


  messageAlertSuccess(BuildContext context,String msg, String ttl) {
   // Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text(ttl),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Text('Okay'),
                  ],
                ),
                onPressed: () {

                  Navigator.pop(context);
                  Navigator.of(context).pop();
                 // SystemNavigator.pop();
                },
              ),
            ],
          );
        });
  }

  messageAlertError(BuildContext context,String msg, String ttl) {
    // Navigator.pop(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(ttl),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Text('Okay'),
                  ],
                ),
                onPressed: () {

                  Navigator.pop(context);
                 // Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

   Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CupertinoActivityIndicator(),
                        SizedBox(height: 10,),
                        Text("Loading...",style: TextStyle(color: Colors.black,fontFamily: 'Montserrat',fontWeight: FontWeight.bold),)
                      ]),
                    )
                  ]));
              });
     }



  void showToast(BuildContext context,String message) {
    final scaffold = ScaffoldMessenger.of(context);
    // ignore: deprecated_member_use

    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(message,style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.bold)),
         // duration: Duration(seconds: 3)
      ),
    );
  }


  String dateFormate(BuildContext context,DateTime date){
    String formateDate;
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    formateDate= formatter.format(date);
    return formateDate;
  }

  String dateFormate24to12hour(BuildContext context,String date){
    String formateDate;
    var st=date.split(":");
    formateDate=TimeOfDay(hour:int.parse(st[0]),minute:int.parse(st[1])).format(context);
    return formateDate;
  }

  String dateFormateMM(BuildContext context,DateTime date){
    String formateDate;
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    formateDate= formatter.format(date);
    return formateDate;
  }

  String dateFormateServer(BuildContext context,DateTime date){
    String formateDate;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    formateDate= formatter.format(date);
    return formateDate;
  }

  String dateFormateSQLServer(BuildContext context,DateTime date){
    String formateDate;
    final DateFormat formatter = DateFormat('dd-MMM-yyyy');
    formateDate= formatter.format(date);
    return formateDate;
  }

  String dateFormateStringServer(BuildContext context,String date){
   // DateTime.parse(date);
    String formateDate;
    var inputFormat = DateFormat('dd-MM-yyyy');
    var inputDate = inputFormat.parse(date);

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    formateDate = formatter.format(inputDate);
    return formateDate;
  }

  String dateFormateDash(BuildContext context,String date){
    // DateTime.parse(date);
    String formateDate;
    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDate = inputFormat.parse(date);

    final DateFormat formatter = DateFormat('MM-dd-yyyy');
    formateDate = formatter.format(inputDate);
    return formateDate;
  }

  String dateFormateyyytoMM(BuildContext context,String date){
    // DateTime.parse(date);
    String formateDate;
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);

    final DateFormat formatter = DateFormat('MM-dd-yyyy');
    formateDate = formatter.format(inputDate);
    return formateDate;
  }

  String dateFormateMMtoM(BuildContext context,String date){
    // DateTime.parse(date);
    String formateDate;
    var inputFormat = DateFormat('dd MMM yyyy');
    var inputDate = inputFormat.parse(date);

    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    formateDate = formatter.format(inputDate);
    return formateDate;
  }

  String dateFormateServertoMobile(BuildContext context,String date){
    // DateTime.parse(date);
    String formateDate;
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(date);

    final DateFormat formatter = DateFormat('dd-MMM-yyyy');
    formateDate = formatter.format(inputDate);
    return formateDate;
  }







  /*void launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }*/

}