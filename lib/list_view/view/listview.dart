import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sampleproject/update/view/update_page.dart';

class listViews extends StatefulWidget {
  listViews({Key? key}) : super(key: key);
  CollectionReference firestore=FirebaseFirestore.instance.collection('users');

  @override
  State<listViews> createState() => _listViewsState();
}

class _listViewsState extends State<listViews> {
  @override
  // void initState() {
  //   // TODO: implement initState
  //   final userdata=widget.firestore.get();
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:StreamBuilder(builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasData){
            return ListView(
              children: 
                snapshot.data!.docs.map((QueryDocumentSnapshot<Object?>e){
                  return Card(
                    child: ListTile(
                      title: Text(e["full_name"].toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute<void>(builder: (context){
                            return updatePage(edittext:e ,);
                          }));
                        }, icon: Icon(Icons.edit)),
                        IconButton(onPressed: (){
                                     deleteUser(e.id);                
                        }, icon: Icon(Icons.delete)),
                      ],
                    ),
                    ),


                  );
                } ).toList()
              
            );
              
            
          }else{
            return CircularProgressIndicator();
          }
          
        },
        stream:widget.firestore.snapshots(),
        ) ,
      ),
      
    );
    
  }


Future<void> deleteUser(String id) {
  return widget.firestore
    .doc(id)
    .delete()
    .then((value) => print("User Deleted"))
    .catchError((dynamic error) => print("Failed to delete user: $error"));
}

}