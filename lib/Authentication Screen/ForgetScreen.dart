import 'package:blogapp_with_sir/Authentication%20Screen/utilits.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Componets/roundbutton.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontroller.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .sendPasswordResetEmail(email: emailcontroller.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
      Utilies().fluttertoast('Check Your Mail Box Rest Link is Sent ');
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utilies().fluttertoast(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: const Text(
              'Forget Password',
            ),
            backgroundColor: Colors.deepOrange,
          ),
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailcontroller,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          fillColor: Colors.white60,
                          hintText: 'enter email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Email';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            Button(
              title: 'Forget Email',
              ontap: () {
                if (_formkey.currentState!.validate()) {
                  login();
                }
              },
              bgcolor: Colors.deepOrange,
            ),
          ]),
        ),
      ),
    );
  }
}
