import 'package:books/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  bool _isLogin=false;


  facebookLogin()async{
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['public_profile', 'email', 'pages_show_list', 'pages_messaging', 'pages_manage_metadata'],

    ); // by default we request the email and the public profile
// or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken!;
      setState(() {
        _isLogin=true;
      });
     // Navigator.push(context, MaterialPageRoute(builder: (context)=> App()));

      print(accessToken.userId);
    }

  }

  /*

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
   */

  _signOut()async{
 await FacebookAuth.instance.logOut();

    setState(() {
      _isLogin=false;
    });

// or FacebookAuth.i.logOut();

  }

  _checkLogin()async{
    final AccessToken accessToken = await FacebookAuth.instance.accessToken;
// or FacebookAuth.i.accessToken
    if (accessToken != null) {
      // user is logged
      setState(() {
        _isLogin=true;
      });
    }
  }

 @override
  void initState() {
    // TODO: implement initState

  _checkLogin();
   super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> App()));
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text("Authentication"),
        ),
        body: Container(
          child : Center(
            child:
            _isLogin
                ?
                Center(
                 child: TextButton(
                   child: Text("Signout"),
                   onPressed: (){
                     _signOut();
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
                     // signInWithGoogle();
                  },
                  child: Text("Login with google")
              ),
              TextButton(
                  onPressed: (){
                    facebookLogin();
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


