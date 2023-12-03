import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Authentication Screen/LoginScreen.dart';
import '../Authentication Screen/utilits.dart';
import 'add_blogs_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final dbRef = FirebaseDatabase.instance.ref('Posts');
  TextEditingController searchcontroller = TextEditingController();
  String search = "";

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepOrange,
          actions: [
            IconButton(
                onPressed: () {
                  auth.signOut().then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }).onError((error, stackTrace) {
                    Utilies().fluttertoast(error.toString());
                  });
                },
                icon: const Icon(Icons.logout_outlined)),
            const SizedBox(
              width: 10.0,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              TextFormField(
                controller: searchcontroller,
                decoration: const InputDecoration(
                  hintText: 'Search By Title',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
              Expanded(
                  child: FirebaseAnimatedList(
                shrinkWrap: true,
                query: dbRef.child('Post List'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  final temptitle = snapshot.child('PTitle').value.toString();
                  if (searchcontroller.text.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey.shade100,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: FadeInImage.assetNetwork(
                                  height:
                                      MediaQuery.of(context).size.height * .25,
                                  width: MediaQuery.of(context).size.width * 1,
                                  placeholder: 'images/1.gif',
                                  fit: BoxFit.cover,
                                  image: snapshot
                                      .child('Pimage')
                                      .value
                                      .toString()),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: Text(
                                snapshot.child('PTitle').value.toString(),
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: Text(
                                  snapshot
                                      .child('PDescription')
                                      .value
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (temptitle.toLowerCase().contains(
                      searchcontroller.text.toLowerCase().toString())) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey.shade100,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: FadeInImage.assetNetwork(
                                  height:
                                      MediaQuery.of(context).size.height * .25,
                                  width: MediaQuery.of(context).size.width * 1,
                                  placeholder: 'images/1.gif',
                                  fit: BoxFit.cover,
                                  image: snapshot
                                      .child('Pimage')
                                      .value
                                      .toString()),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: Text(
                                snapshot.child('PTitle').value.toString(),
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              child: Text(
                                  snapshot
                                      .child('PDescription')
                                      .value
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          backgroundColor: Colors.deepOrange,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddBlogScreen(),
                ));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
