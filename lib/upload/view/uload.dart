import 'package:firebase_storage/firebase_storage.dart'as storge;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' as io;

class uploadPage extends StatefulWidget {
  const uploadPage({Key? key}) : super(key: key);

  @override
  State<uploadPage> createState() => _uploadPageState();
}

class _uploadPageState extends State<uploadPage> {
storge.FirebaseStorage imgstorage =storge.FirebaseStorage.instance;
final ImagePicker imgpicker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: InkWell(
          onTap: () {
            uploadImage();
          },
          child: Container(
            height: 300,
            width: 300,
            child: Icon(Icons.add),
            decoration:BoxDecoration(
              border: Border.all()
            ) ,
          ),
        ),
      ) ,
    );
  }
Future<void>uploadImage()async{
final selectedimg= await imgpicker.pickImage(source: ImageSource.gallery);
final uuid = Uuid();
final ref =imgstorage.ref().child('images').child('${uuid.v4()}${selectedimg!.name}');
final imgdata = storge.SettableMetadata(contentType: selectedimg.mimeType,customMetadata: {'Picked-file-path':selectedimg.path});
await ref.putFile(io.File(selectedimg.path),imgdata);
final downlodUrl= await ref.getDownloadURL();
print(downlodUrl);
}

}