// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class MyTransaction{
BuildContext? context;
  MyTransaction({this.context});

 Future<bool> push(Widget route)async{
 var value= await  Navigator.push(
      context!,
      MaterialPageRoute(builder: (context) {
        return route;
      }),
    );
 return true;
  }
}