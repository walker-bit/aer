import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Detailscreen extends StatefulWidget {
  @override
  _DetailscreenState createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  // final _formkey = GlobalKey<FormState>();
  final _nameController =TextEditingController();

  _userName() async {
    
    FirebaseAuth _auth = FirebaseAuth.instance;
    String uid =_auth.currentUser.uid.toString();
    users.add({
      'displayName': _nameController.text,
      'uid': uid,
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: Text("profile"),
     ),
     body: ListView(
       children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top:26.0),
                  child: Center(
                    child: Text("username"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Container(
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                  ),
                ),
                // FlatButton(
                //   onPressed: ()async{
                //     _userName();
                //   }, 
                //   child: child
                // ),
                GestureDetector(
                  // onTap: _userName(),
                  child: Container(
                    height: 55.0,
                    width: 360.0,
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text("proceed",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                    ),
                  ),
                ),
              ],
            ),
          ),
       ],
     ),
    );
  }
}