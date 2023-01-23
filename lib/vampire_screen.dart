
import 'dart:ffi';

import 'package:vapp/cash_screen.dart';
import 'package:vapp/me_screen.dart';
import 'package:vapp/models/account.dart';
import 'package:vapp/models/user.dart';
import 'package:vapp/shop.dart';
import 'package:vapp/vampire_screen.dart';
import 'globals.dart' as globals;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'network.dart' as service;


class VampireScreen extends StatefulWidget {
  static const routeName = '/vampire';
  const VampireScreen({super.key});

  @override
  State<VampireScreen> createState() => _VampireScreenState();
}

class _VampireScreenState extends State<VampireScreen> {
  late Future<List<User>> futureUsers;
  void initState() {
    super.initState();
    futureUsers = service.fetchUsers() as Future<List<User>>;
  }
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {

                  return Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: (globals.mainColor).withOpacity(.1),
                              blurRadius: 5, // soften the shadow
                              spreadRadius: 1.0, //extend the shadow
                              offset: const Offset(
                                5.0, // Move to right 10  horizontally
                                0, // Move to bottom 10 Vertically
                              ),

                            )]),

                      child: Card(
                        // shadowColor: Colors.amber[800],
                          child:ListTile(
                              title: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child:SizedBox(
                                          width: MediaQuery.of(context).size.width / 2,
                                          child: ListTile(title: Text('${snapshot.data![index].name}', style: globals.basicStyle)),
                                        )),
                                    Expanded(
                                        child:SizedBox(
                                          width: MediaQuery.of(context).size.width / 2,
                                          child: ListTile(title: Text('${snapshot.data![index].email} \$', style: globals.basicStyle,)),
                                        )),

                                    Expanded(
                                        child: SizedBox(
                                          width: MediaQuery.of(context).size.width / 2,
                                          child: ToggleButtons(
                                            color: Colors.black.withOpacity(0.60),
                                            selectedColor: globals.mainColor,
                                            selectedBorderColor: globals.mainColor,
                                            fillColor: globals.mainColor.withOpacity(0.08),
                                            splashColor: globals.mainColor.withOpacity(0.12),
                                            hoverColor: globals.mainColor.withOpacity(0.04),
                                            borderRadius: BorderRadius.circular(30.0),
                                            isSelected: const <bool>[false],
                                            onPressed: (buttonIndex) {
                                                Navigator.pushNamed(
                                                    context,
                                                    '/report',
                                                    arguments: snapshot.data![index]
                                                ).then((value) {
                                                  setState(() {
                                                    futureUsers = service.fetchUsers() as Future<List<User>>;
                                                  });
                                                });
                                            },

                                            children: const [
                                              Icon(Icons.article),

                                            ],
                                          ),
                                        )),
                                  ]))));
                }
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}





