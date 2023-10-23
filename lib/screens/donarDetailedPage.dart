import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon/assets/colors.dart';
import 'package:hackathon/screens/addDonarPage.dart';
import 'package:hackathon/screens/editDonarPage.dart';

class DonarDetailedPage extends StatefulWidget {
  final Map<String, dynamic> donorData;
  const DonarDetailedPage({super.key, required this.donorData});

  @override
  State<DonarDetailedPage> createState() => _DonarDetailedPageState();
}

class _DonarDetailedPageState extends State<DonarDetailedPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? role;
  @override
  void initState() {
    super.initState();
    getCurrentUserData();
  }

  Future<void> getCurrentUserData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (userSnapshot.exists) {
        setState(() {
          role = userSnapshot['role'];
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Donar Detail"),
        elevation: 0,
        backgroundColor: MyColors.red100,
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 2))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name",
                                style: GoogleFonts.roboto(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.donorData['name'],
                                style: GoogleFonts.roboto(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 2))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Location",
                                style: GoogleFonts.roboto(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.donorData['location'],
                                style: GoogleFonts.roboto(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 2))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Phone",
                                style: GoogleFonts.roboto(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.donorData['number'],
                                style: GoogleFonts.roboto(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 2))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Email",
                                style: GoogleFonts.roboto(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                widget.donorData['email'],
                                style: GoogleFonts.roboto(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 2))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Blood Group",
                                style: GoogleFonts.roboto(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              Container(
                                height: 30,
                                width: 34,
                                color: MyColors.red100,
                                child: Center(
                                  child: Text(
                                    widget.donorData['bloodgroup'],
                                    style: GoogleFonts.roboto(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return EditDonarPage(
                          donorData: widget.donorData,
                        );
                      },
                    ));
                  },
                  child: role == "Manager"
                      ? Container(
                          height: 48,
                          width: 254,
                          decoration: BoxDecoration(
                            color: MyColors.red100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Edit",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: MyColors.white100),
                            ),
                          ),
                        )
                      : SizedBox(),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
