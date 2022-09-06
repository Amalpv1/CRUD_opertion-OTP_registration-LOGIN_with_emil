

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class updatePage extends StatefulWidget {
  updatePage({Key? key,required this.edittext}) : super(key: key);
QueryDocumentSnapshot edittext;
 CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  State<updatePage> createState() => _updatePageState();
}

class _updatePageState extends State<updatePage> {
  TextEditingController textcontroller=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textcontroller.text=widget.edittext["full_name"].toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textcontroller,
              decoration: InputDecoration(
                hintText: 'type'
              ),
      
            ),
             ElevatedButton(onPressed: (){
               updateUser();
             }, child: Text('edit'))
          ],
        ),
        
        
      ),
    );
  }
 

Future<void> updateUser() {
  return widget.users
    .doc(widget.edittext.id)
    .update({'full_name': textcontroller.text})
    .then((value) {
      print("User Updated");
      Navigator.pop(context);
    })
    .catchError((dynamic error) => print("Failed to update user: $error"));
}

}