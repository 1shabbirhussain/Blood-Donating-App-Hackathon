import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hackathon/assets/colors.dart';
import 'package:hackathon/screens/addDonarPage.dart';
import 'package:hackathon/screens/donarDetailedPage.dart';

class DonarsView extends StatefulWidget {
  const DonarsView({super.key});

  @override
  State<DonarsView> createState() => _DonarsViewState();
}

class _DonarsViewState extends State<DonarsView> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Donars"),
        elevation: 0,
        backgroundColor: MyColors.red100,
      ),
      body: Container(
          child: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(
                  color: MyColors.red100,
                ),
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              // --------------------------return custom container to view data-----------------
              return InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: MyColors.red100, width: 3),
                  ),
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: 135,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data['name'],
                            style: GoogleFonts.roboto(
                                fontSize: 12, fontWeight: FontWeight.w400),
                          ),
                          Container(
                            height: 20,
                            width: 34,
                            color: MyColors.red100,
                            child: Center(child: Text(data['bloodgroup'])),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text(data['location']),
                      SizedBox(
                        height: 3,
                      ),
                      Text(data['number']),
                      SizedBox(
                        height: 3,
                      ),
                      Text(data['email']),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return DonarDetailedPage(donorData: data);
                    },
                  ));
                },
              );
            }).toList(),
          );
        },
      )),
    ));
  }
}
