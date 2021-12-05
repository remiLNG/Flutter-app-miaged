import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_miaged/widgets/custom_action_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_miaged/services/firebase_services.dart';

// ignore: must_be_immutable
class ProfilTab extends StatelessWidget {
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final CollectionReference _userInfoRef =
      FirebaseFirestore.instance.collection("UserInformation");

  FirebaseServices _firebaseServices = FirebaseServices();

  final SnackBar _snackBarUpdate = SnackBar(
    content: Text("Profil modifié !"),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        FutureBuilder<QuerySnapshot>(
          future: _userInfoRef.get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text("Error: ${snapshot.error}"),
                ),
              );
            }
            // Collection Data ready to display
            if (snapshot.connectionState == ConnectionState.done) {
              // Display the data inside a list view
              return ListView(
                children: snapshot.data.docs.map((document) {
                  return Container(
                    padding: EdgeInsets.only(
                      top: 66.0,
                      left: 24.0,
                      right: 24.0,
                      bottom: 42.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                            showCursor: false,
                            readOnly: true,
                            controller: loginController
                              ..text = "${document.data()['Login']}",
                            decoration: InputDecoration(
                              labelText: "Login",
                            )),
                        TextField(
                            obscureText: true,
                            controller: passwordController
                              ..text = "${document.data()['Password']}",
                            decoration: InputDecoration(
                              labelText: "Password",
                            )),
                        TextField(
                            controller: usernameController
                              ..text = "${document.data()['Username']}",
                            decoration: InputDecoration(
                              labelText: "Username",
                            )),
                        TextField(
                            controller: birthDateController
                              ..text = "${document.data()['Birthday']}",
                            decoration: InputDecoration(
                              labelText: "Birthday",
                            )),
                        TextField(
                            controller: countryController
                              ..text = "${document.data()['Country']}",
                            decoration: InputDecoration(
                              labelText: "Country",
                            )),
                        TextField(
                            controller: cityController
                              ..text = "${document.data()['City']}",
                            decoration: InputDecoration(
                              labelText: "City",
                            )),
                        TextField(
                            controller: addressController
                              ..text = "${document.data()['Address']}",
                            decoration: InputDecoration(
                              labelText: "Address",
                            )),
                        TextField(
                            controller: zipCodeController
                              ..text = "${document.data()['ZipCode']}",
                            decoration: InputDecoration(
                              labelText: "ZipCode",
                            )),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 30.0, bottom: 12.0),
                              child: ElevatedButton(
                                child: Text('Modifier'),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.cyan, // background
                                    onPrimary: Colors.white, // foreground
                                    minimumSize: Size(150, 48)),
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(_snackBarUpdate);
                                  _firebaseServices.setUserInformation(
                                      adresse: addressController.text.trim(),
                                      username: usernameController.text.trim(),
                                      password: passwordController.text.trim(),
                                      anniversaire:
                                          birthDateController.text.trim(),
                                      ville: cityController.text.trim(),
                                      pays: countryController.text.trim(),
                                      zipcode: zipCodeController.text.trim());
                                },
                              ),
                            )),
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              child: ElevatedButton(
                                child: Text('Deconnexion'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red, // background
                                  onPrimary: Colors.white, // foreground
                                  minimumSize: Size(150, 48),
                                ),
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                },
                              ),
                            )),
                      ],
                    ),
                  );
                }).toList(),
              );
            }
            // Loading State
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        CustomActionBar(
          title: "Profil",
          hasBackArrrow: false,
        ),
      ],
    ));
  }
}
