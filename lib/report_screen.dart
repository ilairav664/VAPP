
import 'package:flutter/material.dart';
import 'package:vapp/models/user.dart';
import 'package:vapp/network.dart' as service;
import 'globals.dart' as globals;
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  static const routeName = '/report';
  const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => _ReportScreen();
}

class _ReportScreen extends State<ReportScreen> {
  TextEditingController dateStartInput = TextEditingController();
  TextEditingController dateEndInput = TextEditingController();
  late Future<int> futureResult;
  final DateFormat formatter = DateFormat('dd.MM.yyyy');
  var startDate = DateFormat('dd.MM.yyyy').format(DateTime.now().subtract(new Duration(days: 30)));
  var endDate = DateFormat('dd.MM.yyyy').format(DateTime.now());
  var user;
  @override
  void initState() {
    dateStartInput.text = "";
    dateEndInput.text = "";
    super.initState();


  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {;

    user = ModalRoute.of(context)!.settings.arguments as User;
    futureResult = service.fetchReport(user.userId, startDate, endDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Отчет по пользователю'),
        backgroundColor: globals.mainColor,
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          reverse: false,
          padding: const EdgeInsets.all(10),
          children: [
            FutureBuilder<int>(
              future: futureResult,
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  return
                      Container(child: Column(children: [
                        Text("Отчетный период: "),
                        Padding(padding: EdgeInsets.all(10)),
                        Text("$startDate - $endDate"),
                        Padding(padding: EdgeInsets.all(20)),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                                  child:  Image.network(user.image,
                                          fit:BoxFit.fill)
                        ),
                        Padding(padding: EdgeInsets.all(20)),
                        Text("Баблос за период: ${snapshot.data}"),
                          Row(children: [
                            Align(alignment: Alignment.centerLeft, child: Container(width: 160, child:
                            TextField(
                              controller: dateStartInput,
                              style: globals.basicStyle,
                              //editing controller of this TextField
                              decoration: InputDecoration(
                                icon: Icon(Icons.calendar_today), //icon of text field
                                labelText: "Начало периода", //label text of field
                              ),
                              readOnly: true,
                              //set it true, so that user will not able to edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2100));

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                  DateFormat('dd.MM.yyyy').format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  setState(() {
                                    dateStartInput.text =
                                        formattedDate; //set output date to TextField value.
                                  });
                                } else {}
                              },
                            ))),
                            Align(alignment: Alignment.centerLeft, child: Container(width: 160, child:
                            TextField(
                              controller: dateEndInput,
                              style: globals.basicStyle,
                              //editing controller of this TextField
                              decoration: InputDecoration(
                                icon: Icon(Icons.calendar_today), //icon of text field
                                labelText: "Конец периода", //label text of field
                              ),
                              readOnly: true,
                              //set it true, so that user will not able to edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateFormat('dd.MM.yyyy').parse(dateStartInput.text),
                                    //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2100));

                                if (pickedDate != null) {
                                  print(
                                      pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                  String formattedDate =
                                  DateFormat('dd.MM.yyyy').format(pickedDate);
                                  print(
                                      formattedDate); //formatted date output using intl package =>  2021-03-16
                                  setState(() {
                                    dateEndInput.text =
                                        formattedDate; //set output date to TextField value.
                                  });
                                } else {}
                              },
                            ))),

                          ],),
                        Padding(padding: EdgeInsets.all(20)),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 1.5,
                            child:  Align(child:ListTile(
                              title:
                              ElevatedButton(
                                style: globals.buttonStyle,
                                onPressed: () {
                                  setState(() {
                                    futureResult = service.fetchReport(user.userId, dateStartInput.text, dateEndInput.text);
                                    startDate = dateStartInput.text;
                                    endDate = dateEndInput.text;

                                  });

                                },
                                child: const Text('ЗАПРОСИТЬ ОТЧЕТ'),
                              ),), alignment: Alignment.center ,)
                        )



                      ],));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            )
          ],
        ),
      ),
    );
  }
}
