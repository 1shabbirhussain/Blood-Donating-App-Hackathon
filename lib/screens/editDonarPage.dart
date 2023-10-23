import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon/assets/colors.dart';
import 'package:hackathon/assets/global.dart';
import 'package:hackathon/screens/allDonarsViewPage.dart';

class EditDonarPage extends StatefulWidget {
  final Map<String, dynamic> donorData;
  const EditDonarPage({super.key, required this.donorData});

  @override
  State<EditDonarPage> createState() => _EditDonarPageState();
}

String selectedBloodGroup = '';

class _EditDonarPageState extends State<EditDonarPage> {
  TextEditingController? nameController;
  TextEditingController? locationController;
  TextEditingController? numberController;
  TextEditingController? emailController;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with values from donorData
    nameController = TextEditingController(text: widget.donorData['name']);
    locationController =
        TextEditingController(text: widget.donorData['location']);
    numberController = TextEditingController(text: widget.donorData['number']);
    emailController = TextEditingController(text: widget.donorData['email']);
    // Set the selected blood group from donorData
    selectedBloodGroup = widget.donorData['bloodgroup'];
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed
    nameController?.dispose();
    locationController?.dispose();
    numberController?.dispose();
    emailController?.dispose();
    super.dispose();
  }

  // contollers End ----------------------------------------
  // ----------------------- edit user data in DB---------------
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> updateUser() {
    return users
        .doc(widget.donorData['id'])
        .update({
          'name': nameController?.text,
          'email': emailController?.text,
          "location": locationController?.text,
          "number": numberController?.text,
          "bloodgroup": selectedBloodGroup,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Edit Donar"),
        elevation: 0,
        backgroundColor: MyColors.red100,
      ),
      body: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: "Location"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: numberController,
                    decoration: InputDecoration(labelText: "Phone")),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "email")),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Select Blood Group",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6, // The number of columns in the grid
                      crossAxisSpacing: 10.0, // Spacing between columns
                      mainAxisSpacing: 10.0, // Spacing between rows
                    ),
                    itemCount: bloodGroups.length - 1,
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
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    updateUser();
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return DonarsView();
                      },
                    ));
                  },
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      width: 250,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MyColors.red100,
                      ),
                      child: const Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: MyColors.white100,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
