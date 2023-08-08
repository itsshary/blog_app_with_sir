import 'dart:io';

import 'package:blogapp_with_sir/Authentication%20Screen/utilits.dart';
import 'package:blogapp_with_sir/Componets/roundbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddBlogScreen extends StatefulWidget {
  const AddBlogScreen({super.key});

  @override
  State<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  //auth reference
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool showspinner = false;
  //database reference
  final postref = FirebaseDatabase.instance.ref().child('Posts');
  //firebase storage refernce
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _image;
  final picker = ImagePicker();
  final _formkey = GlobalKey<FormState>();
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController desciptioncontroller = TextEditingController();

  //for Galler pick image function
  Future getimagefromGallery() async {
    final pickedimage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedimage != null) {
        _image = File(pickedimage.path);
      } else {
        Utilies().fluttertoast('No image selected');
      }
    });
  }

  //for camer pick image function
  Future getimagefromCamera() async {
    final pickedimage = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedimage != null) {
        _image = File(pickedimage.path);
      } else {
        Utilies().fluttertoast('No image selected');
      }
    });
  }

  //Dialog box code
  void dialong(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.deepOrange,
          clipBehavior: Clip.hardEdge,
          content: Container(
            height: 120,
            child: Column(
              children: [
                InkWell(
                  //camera picker function
                  onTap: () {
                    getimagefromCamera();
                    Navigator.pop(context);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.camera),
                    title: Text('Camera'),
                  ),
                ),
                InkWell(
                  //gallery picker function
                  onTap: () {
                    getimagefromGallery();
                    Navigator.pop(context);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showspinner,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Upload Blogs'),
            backgroundColor: Colors.deepOrange,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Column(
                children: [
                  Center(
                    //inkwell widget for dialong
                    child: InkWell(
                      onTap: () => dialong(context),
                      child: Container(
                          height: MediaQuery.of(context).size.height * .2,
                          width: MediaQuery.of(context).size.width * 1,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: _image != null
                              ? ClipRect(
                                  //image height adjustment
                                  child: Image.file(
                                    _image!.absolute,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                  ),
                                )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: titlecontroller,
                            keyboardType: TextInputType.text,
                            minLines: 1,
                            decoration: InputDecoration(
                              label: const Text('Title'),
                              hintText: 'Enter Title',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Title';
                              } else
                                null;
                            },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: desciptioncontroller,
                            keyboardType: TextInputType.text,
                            maxLines: 10,
                            minLines: 1,
                            decoration: InputDecoration(
                              label: const Text('Description'),
                              hintText: 'Enter Description',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Description';
                              } else
                                Null;
                            },
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Button(
                    title: 'Upload',
                    ontap: () async {
                      setState(() {
                        showspinner = true;
                      });
                      try {
                        //take a reference of date to store data in firebase
                        int data = DateTime.now().microsecondsSinceEpoch;
                        //firebase storage referance and add folder name on database
                        firebase_storage.Reference ref = firebase_storage
                            .FirebaseStorage.instance
                            .ref('/blogapp$data');
                        //uploded thhe tasks on firebase
                        UploadTask uploadTask = ref.putFile(_image!.absolute);
                        await Future.value(uploadTask);
                        //image url
                        var newurl = await ref.getDownloadURL();

                        final User? user = _auth.currentUser;
                        postref.child('Post List').child(data.toString()).set({
                          'PID': data.toString(),
                          'Pimage': newurl.toString(),
                          'Ptime': data.toString(),
                          'PTitle': titlecontroller.text.toString(),
                          'PDescription': desciptioncontroller.text.toString(),
                          'Uemail': user!.email.toString(),
                          'uid': user.uid.toString(),
                        }).then((value) {
                          setState(() {
                            showspinner = false;
                          });
                          Utilies().fluttertoast('Post Published');
                        }).onError((error, stackTrace) {
                          setState(() {
                            showspinner = false;
                          });
                          Utilies().fluttertoast(error.toString());
                        });
                      } catch (e) {
                        setState(() {
                          showspinner = false;
                        });
                        Utilies().fluttertoast(e.toString());
                      }
                    },
                    bgcolor: Colors.deepOrange,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
