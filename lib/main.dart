import 'dart:async';
import 'dart:convert';

import 'package:books/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/services.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';




void main()async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/':(context)=>App()
      },
    )
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  FirebaseFirestore firestore=FirebaseFirestore.instance;



  @override
  void initState() {
    // TODO: implement initState

    Timer(Duration(seconds: 2),(){
      print(isLogin);
    });
  _getCurrentUser();
    super.initState();
  }
  _getCurrentUser(){
    var cUser=FirebaseAuth.instance.currentUser;
    if(cUser != null){
      setState(() {
        user=cUser.email;
        isLogin=true;
      });
    }
  }
  bool isLogin=false;

  String user="";

  _doLike(id){
    if(isLogin){
      var db=firestore.collection("Authors").doc(id);

      db.get().then((v){
        var oldData=v.data()['likes'];
        bool isLike=oldData.contains(user);
        if(isLike){
          db.update({
            "likes" :FieldValue.arrayRemove([user])
          });
        }else{
          db.update({
            "likes" :FieldValue.arrayUnion([user])
          });
        }
      });
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Auth()));

    }

  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Favorite system."),
            actions: [
              IconButton(
                  onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Auth()));
              },
                  icon: Icon(Icons.login)
              )
            ],
          ),
          body: Container(
            child: StreamBuilder(
              stream: firestore.collection("Authors").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> s){

                if(s.connectionState== ConnectionState.waiting){
                  return Text("Waiting");
                }
                else if(s.hasData){
                  var d=s.data!.docs;
                  return ListView(
                    children: d.map((i){
                      bool _isLike=i.data()['likes'].contains(user);
                      //print(i.data()['likes']);
                      return Card(
                        child: ListTile(
                          title: Text(i['name']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: (){
                                      _doLike(i.id);
                                  },
                                  icon: _isLike ? Icon(Icons.favorite, color: Colors.pink,) : Icon(Icons.favorite_border)
                              ),
                              Text(i.data()['likes'].length.toString())
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }else{
                  return CircularProgressIndicator();
                }
              },
            )
          ),
        ),
    );

  }
}

