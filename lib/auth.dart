import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {

 signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

     var currentUser= await FirebaseAuth.instance.currentUser;
     if(currentUser.uid !=null){
       setState(() {
         isLogin=true;
       });
       Navigator.pop(context);
     }
  }


  bool isLogin=false;

 @override
  void initState() {
    // TODO: implement initState
   var currentUser= FirebaseAuth.instance.currentUser;
    if(currentUser !=null){
      setState(() {
        isLogin=true;
      });
    }

   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text("Authentication"),
        ),
        body: Container(
          child : Center(
            child:
            isLogin
                ?
                Center(
                 child: TextButton(
                   child: Text("Signout"),
                   onPressed: (){
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                   },
                 ),

                )
            :
            Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: (){
                      signInWithGoogle();
                  },
                  child: Text("Login with google")
              ),
              TextButton(
                  onPressed: (){

                  },
                  child: Text("Login with facebook")
              )
            ],
          ),
        ),
      ),
      )
    );
  }
}


