import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon/assets/colors.dart';
import 'package:hackathon/assets/global.dart';
import 'package:hackathon/screens/addDonarPage.dart';
import 'package:hackathon/screens/allDonarsViewPage.dart';
import 'package:hackathon/screens/logoutPage.dart';

class Home_View extends StatefulWidget {
  const Home_View({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<Home_View> {
  String selectedBloodGroup = '';
  String currentUserRole = "";
  bool roleFlag = false;

  gettingRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Current user is authenticated
      String uid = user.uid; // Get the UID of the current user

      // Reference to the Firestore collection where user data is stored
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      // Query the Firestore collection for the document with the same UID
      DocumentSnapshot userSnapshot = await users.doc(uid).get();

      // Check if the user document exists
      if (userSnapshot.exists) {
        // Get the "role" property from Firestore data
        String? role = userSnapshot.get('role');
        if (role != null) {
          // Role is not null, you can use it
          print('User Role: $role');
          setState(() {
            roleFlag = role == "Manager";
          });
          print(currentUserRole);
          print(roleFlag);
        } else {
          print('Role is null for the current user.');
        }
      } else {
        print('User document not found.');
      }
    } else {
      print('User is not authenticated.');
    }
  }

  @override
  void initState() {
    super.initState();
    print("this is init state");
    // gettingUserIdMethod();
    gettingRole();
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference users = FirebaseFirestore.instance.collection('users');
    // User? user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: MyColors.red100,
          title: Text(
            "Zindagi",
            style: GoogleFonts.quando(),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return LogoutPage();
                  },
                ));
              },
              icon: Icon(Icons.supervised_user_circle),
              iconSize: 32, // Set the desired size
            ),
          ],
        ),
        body: Column(
          children: [
            Image.asset("images/map.png"),
            Expanded(
              child: Container(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Blood Groups",
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              6, // The number of columns in the grid
                          crossAxisSpacing: 20.0, // Spacing between columns
                          mainAxisSpacing: 20.0, // Spacing between rows
                        ),
                        itemCount: bloodGroups.length,
                        itemBuilder: (context, index) {
                          final bloodGroup = bloodGroups[index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedBloodGroup = bloodGroup;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              height: 20,
                              width: 32,
                              child: Card(
                                color: bloodGroup == selectedBloodGroup
                                    ? MyColors.red100
                                    // Set the selected item's text color to white
                                    : MyColors.white100,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: MyColors.red100,
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.circular(3.0),
                                ),
                                child: Center(
                                  child: Text(
                                    bloodGroups[index],
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: bloodGroup == selectedBloodGroup
                                          ? Colors
                                              .white // Set the selected item's text color to white
                                          : MyColors.red100,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 50, // Set the desired height
                            width: 150, // Set the desired width
                            color: MyColors.red100,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          MyColors.red100),
                                ),
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return DonarsView();
                                    },
                                  ));
                                },
                                child: Text("Show All")),
                          ),
                          Container(
                            height: 50,
                            width: 150,
                            child: roleFlag
                                ? ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              MyColors.white100),
                                    ),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return addDonar();
                                        },
                                      ));
                                    },
                                    child: const Text(
                                      "Add New Donar",
                                      style: TextStyle(color: MyColors.red100),
                                    ),
                                  )
                                : const SizedBox(), // If roleFlag is false, an empty SizedBox is used
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
