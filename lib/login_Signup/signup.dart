import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon/assets/colors.dart';
import 'package:hackathon/assets/global.dart';
import 'package:hackathon/login_Signup/login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // contollers start ----------------------------------------
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  // contollers End ----------------------------------------

  createUserFunc() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      String? uid = userCredential.user?.uid; // Use null safe operators
      if (uid != null) {
        addUsertoDB(uid);

        emailController.clear();
        nameController.clear();
        passwordController.clear();
        locationController.clear();
        numberController.clear();
        bloodGroupController.clear();

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }));
      } else {
        // Handle the case where uid is null
        print('User UID is null');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  // -------------adding user in db ------------------------
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> addUsertoDB(String uid) {
    // Call the user's CollectionReference to add a new user
    return users
        .doc(uid)
        .set({
          'name': nameController.text,
          'email': emailController.text,
          "role": selectedRole,
          "location": locationController.text,
          "number": numberController.text,
          "bloodgroup": bloodGroupController.text,
          "id": uid,
        })
        .then((value) => print("User Signed UP Added"))
        .catchError((error) => print("Failed to add todo: $error"));
  }

  // ----------------disposing cintrokllers --------------
  @override
  void dispose() {
    // Dispose of the TextEditingController when it's no longer needed.
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.red100,
      ),
      body: Stack(
        children: [
          Container(
            color: MyColors.red100,
            height: 300,
            width: double.infinity,
            child: Center(
              child: Column(
                children: [
                  Image(
                    image: AssetImage("images/water.png"),
                    width: 83,
                    height: 83,
                  ),
                  Text(
                    "Zindagi",
                    style: GoogleFonts.quando(
                        color: MyColors.white100,
                        fontSize: 23,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          // Upper container with image and title ed--------------------
          Center(
            child: Card(
              elevation: 30,
              child: SingleChildScrollView(
                child: Container(
                  width: 300,
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(labelText: "Name"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(labelText: "Email"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: passwordController,
                              decoration:
                                  InputDecoration(labelText: "Password")),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: locationController,
                              decoration:
                                  InputDecoration(labelText: "Location")),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: numberController,
                              decoration:
                                  InputDecoration(labelText: "Phone Number")),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                              controller: bloodGroupController,
                              decoration: InputDecoration(
                                  labelText: "Blood Group",
                                  hintText: "E.G O+")),
                          const SizedBox(
                            height: 10,
                          ),
                          //  Dropdown for selecting role------------------------
                          DropdownButton<String>(
                            value: selectedRole,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedRole = newValue;
                              });
                            },
                            items: roleOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          //  -----------Dropdown for selecting role------------------------
                          const SizedBox(
                            height: 50,
                          ),
                          Container(
                            width: 254,
                            height: 48,
                            child: ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(MyColors.red100),
                                ),
                                onPressed: () {
                                  createUserFunc();
                                },
                                child: Text("SignUp")),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LoginScreen();
                                }));
                              },
                              child: const Text("Go to Sign In screen"))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
