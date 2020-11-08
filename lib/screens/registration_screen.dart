import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:spot_hot/components/rounded_button.dart';
import 'package:spot_hot/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = "registration_screen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  String email;
  String password;
  String firstName;
  String lastName;
  String userName;
  final _auth = FirebaseAuth.instance;
  final firstNameField = TextEditingController();
  final lastNameField = TextEditingController();
  final userNameField = TextEditingController();
  final emailField = TextEditingController();
  final passwordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    Future<void> addUser(String userId) {
      return users
          .doc(userId)
          .set({
            'bio': '',
            'email': email,
            'first_name': firstName,
            'followers': [],
            'following': [],
            'last_name': lastName,
            'username': userName,
            'uuid': userId
          })
          .then((value) => print("User registered"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: "lightning",
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'Spot Hot',
                  style: TextStyle(
                      fontSize: 65,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'BarlowCondensed',
                      color: Colors.white
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              TextField(
                controller: firstNameField,
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                cursorColor: Color(0xFFFFBE8F),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  firstName = value;
                  //Do something with the user input.
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: "First name"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: lastNameField,
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                cursorColor: Color(0xFFFFBE8F),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  lastName = value;
                  //Do something with the user input.
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: "Last name"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: userNameField,
                textAlign: TextAlign.center,
                cursorColor: Color(0xFFFFBE8F),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  userName = value;
                  //Do something with the user input.
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: "User name"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: emailField,
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                cursorColor: Color(0xFFFFBE8F),
                style: TextStyle(color: Colors.white),
                onChanged: (value) {
                  email = value;
                  //Do something with the user input.
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: "Enter your email"),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  controller: passwordField,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  cursorColor: Color(0xFFFFBE8F),
                  style: TextStyle(color: Colors.white),
                  onChanged: (value) {
                    password = value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your password")),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                title: "Register",
                color: Color(0xFFFFBE8F),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    addUser(newUser.user.uid);

                    if (newUser != null) {
                      //clear all the text fields
                      firstNameField.clear();
                      lastNameField.clear();
                      userNameField.clear();
                      emailField.clear();
                      passwordField.clear();

                      //display flushbar notification
                      Flushbar(
                        title: "Success!",
                        message: "User is registered",
                        duration: Duration(seconds: 5),
                      )..show(context);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
