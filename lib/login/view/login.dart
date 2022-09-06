import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/home_page/view/home_page.dart';

class logiPage extends StatefulWidget {
  logiPage({Key? key}) : super(key: key);

  @override
  State<logiPage> createState() => _logiPageState();
  CollectionReference firestore = FirebaseFirestore.instance.collection('users');
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController pwdcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();
  TextEditingController adrscontroller = TextEditingController();
}

class _logiPageState extends State<logiPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('FLUTTER')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: widget.namecontroller,
            decoration: InputDecoration(
                label: Text('Name'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: widget.adrscontroller,
            decoration: InputDecoration(
                label: Text('Address'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: widget.pwdcontroller,
            decoration: InputDecoration(
                label: Text('password'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: widget.usernamecontroller,
            decoration: InputDecoration(
                label: Text('email id'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
          ),
          ElevatedButton(
              onPressed: () {
                // signin();
                createaccount();
                // Navigator.push<void>(context, MaterialPageRoute<dynamic>(builder: (cntxt){
                //   return homePage();
                // }));
              },
              child: Text('Login'))
        ],
      ),
    );
  }

  void createaccount() async {
    print(widget.usernamecontroller.text);
    print(widget.pwdcontroller.text);
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.usernamecontroller.text,
        password: widget.pwdcontroller.text,
      );
      addUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void signin() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: widget.usernamecontroller.text,
        password: widget.pwdcontroller.text,
      );
      print("haiii");
      Navigator.push<Void>(context, MaterialPageRoute(builder: (context) {
        return homePage();
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }
  Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return widget.firestore
          .add({
            'full_name': widget.namecontroller.text, // John Doe
            'Address': widget.adrscontroller.text, // Stokes and Sons
            
          })
          .then((value) => print("User Added"))
          .catchError((dynamic error) => print("Failed to add user: $error"));
    }

}
