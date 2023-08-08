import 'package:blogapp_with_sir/Authentication%20Screen/utilits.dart';
import 'package:blogapp_with_sir/Componets/roundbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../PostScreen/PostScreen.dart';
import 'LoginScreen.dart';

class SigningScreen extends StatefulWidget {
  const SigningScreen({super.key});

  @override
  State<SigningScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SigningScreen> {
  String email = '', password = '';
  bool loading = false;

  final _formkey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  void signup() {
    if (_formkey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      _auth
          .createUserWithEmailAndPassword(
              email: emailcontroller.text.toString(),
              password: passwordcontroller.text.toString())
          .then((value) {
        setState(() {
          Utilies().fluttertoast('User Succesfully Signing');
          loading = false;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PostScreen()));
        });
      }).onError((error, stackTrace) {
        setState(() {
          loading = false;
        });

        Utilies().fluttertoast(error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sign In  Screen',
          ),
          backgroundColor: Colors.deepOrange,
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailcontroller,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        fillColor: Colors.white60,
                        hintText: 'enter email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      //hold the value of textfield
                      onChanged: (String value) {
                        email = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordcontroller,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'enter password',
                        prefixIcon: Icon(Icons.password),
                      ),
                      //hold the value of password textfield
                      onChanged: (String value) {
                        password = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password';
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
            title: 'Sign In',
            ontap: () {
              signup();
            },
            bgcolor: Colors.deepOrange,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already Have an account'),
              const SizedBox(
                width: 5.0,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ));
                  },
                  child: const Text('Log In')),
            ],
          ),
        ]),
      ),
    );
  }
}
