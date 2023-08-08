import 'package:blogapp_with_sir/Authentication%20Screen/utilits.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../Componets/roundbutton.dart';
import '../PostScreen/PostScreen.dart';
import 'ForgetScreen.dart';
import 'SigningScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailcontroller.text,
            password: passwordcontroller.text.toString())
        .then((value) {
      Utilies().fluttertoast('Login SuccessFully');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PostScreen()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      Utilies().fluttertoast(error.toString());
      setState(() {
        loading = false;
      });
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
            automaticallyImplyLeading: false,
            title: const Text(
              'Login Screen',
            ),
            backgroundColor: Colors.deepOrange,
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                title: 'Login',
                ontap: () {
                  if (_formkey.currentState!.validate()) {
                    //function of login
                    login();
                  }
                },
                bgcolor: Colors.deepOrange,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have any account"),
                  const SizedBox(
                    width: 5.0,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SigningScreen(),
                            ));
                      },
                      child: const Text('Sign In')),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgetPasswordScreen(),
                            ));
                      },
                      child: const Text(
                        'Forget Password',
                        style: TextStyle(decoration: TextDecoration.underline),
                      ))
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
