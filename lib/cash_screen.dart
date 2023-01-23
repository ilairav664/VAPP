import 'dart:async';
import 'package:flutter/material.dart';
import 'models/account.dart';
import 'network.dart' as service;
import 'globals.dart' as globals;
class CashScreen extends StatelessWidget{
  static const routeName = '/cashScreen';
  const CashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const CashList();
  }
}

class CashList extends StatefulWidget {
  const CashList({super.key});

  @override
  _CashList createState() => _CashList();
}

class _CashList extends State<CashList>{
  late Future<List<Account>> futureAccounts;
  @override
  void initState() {
    super.initState();
    futureAccounts = service.fetchAccounts() as Future<List<Account>>;
  }


  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: FutureBuilder<List<Account>>(
        future: futureAccounts,
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
                                          child: ListTile(title: Text('${snapshot.data![index].accountName}', style: globals.basicStyle)),
                                        )),
                                    Expanded(
                                        child:SizedBox(
                                          width: MediaQuery.of(context).size.width / 2,
                                          child: ListTile(title: Text('${snapshot.data![index].balance} \$', style: globals.basicStyle,)),
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
                                            isSelected: const <bool>[false, false],
                                            onPressed: (buttonIndex) {
                                              if (buttonIndex == 0) {
                                                Navigator.pushNamed(
                                                    context,
                                                    '/addMoney',
                                                    arguments: snapshot.data![index]
                                                ).then((value) {
                                                  setState(() {
                                                    futureAccounts = service.fetchAccounts() as Future<List<Account>>;
                                                  });
                                                });
                                              } else {
                                                Navigator.pushNamed(
                                                    context,
                                                    '/transferMoney',
                                                    arguments: snapshot.data![index]
                                                ).then((value) {
                                                  setState(() {
                                                    futureAccounts = service.fetchAccounts() as Future<List<Account>>;
                                                  });
                                                });

                                              }
                                            },

                                            children: const [
                                              Icon(Icons.add_box),
                                              Icon(Icons.arrow_forward_outlined),

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
