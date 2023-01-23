import 'dart:collection';

import 'package:flutter_blue/flutter_blue.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'package:flutter/material.dart';
import 'package:vapp/loader.dart';
import 'package:vapp/models/question.dart';
import 'package:vapp/network.dart' as service;
import 'globals.dart' as globals;

class MeasureRoute extends StatefulWidget {
  static const routeName = '/measureRoute';
  const MeasureRoute({super.key});
  @override
  State<MeasureRoute> createState() => _MeasureRoute();
}

class _MeasureRoute extends State<MeasureRoute> with TickerProviderStateMixin {
  late AnimationController animationController;
  late Future<List<Question>> futureQuestion;
  late HashMap valuesMap;
  late Future<bool> blueIsOn;
  double sfValue = 5;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    animationController.repeat(reverse: true);
    futureQuestion = service.fetchQuestions();
    valuesMap = HashMap();
    futureQuestion.then((value) => value.forEach((element) {
          valuesMap[element.questionId] = 5.0;
        }));
    blueIsOn = FlutterBlue.instance.isOn;
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    // Clean up the controller when the widget is disposed.

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Измерение \nсостояния'),
        backgroundColor: globals.mainColor,
      ),
      body: Container(
        child: ListView(
          shrinkWrap: true,
          reverse: false,
          padding: const EdgeInsets.all(10),
          children: [
            FutureBuilder<List<Question>>(
              future: futureQuestion,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Question> physicalQuestions =
                      snapshot.data!.where((f) => f.type == true).toList();
                  List<Question> emotionalQuestions =
                      snapshot.data!.where((f) => f.type == false).toList();
                  // for (var element in snapshot.data!) {valuesMap[element.questionId] = 5;}

                  return ListView(physics: const ClampingScrollPhysics(),shrinkWrap: true, reverse: false, children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: ListTile(
                        title: Text('Физическое состояние:'),
                      ),
                    ),
                    FutureBuilder<bool>(
                        future: blueIsOn,
                        builder: (context, snapshot) {
                          return SizedBox(
                              child: ListTile(
                            title: buildPhysic(
                                physicalQuestions, snapshot.data ?? false),
                          ));
                        }),
                    SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: const ListTile(
                            title: Text('Эмоциональное состояние:'))),
                    ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.all(8),
                        itemCount: emotionalQuestions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: (globals.mainColor).withOpacity(.1),
                                  blurRadius: 5, // soften the shadow
                                  spreadRadius: 1.0, //extend the shadow
                                  offset: const Offset(
                                    5.0, // Move to right 10  horizontally
                                    0, // Move to bottom 10 Vertically
                                  ),
                                )
                              ]),
                              child: Card(
                                  // shadowColor: Colors.amber[800],
                                  child: ListTile(
                                      title: Column(children: <Widget>[
                                ListTile(
                                    title: Text(emotionalQuestions[index].text,
                                        style: globals.basicStyle)),
                                SfSlider(
                                  min: 0.0,
                                  max: 10.0,
                                  value: valuesMap[
                                      emotionalQuestions[index].questionId],
                                  interval: 1.0,
                                  stepSize: 1,

                                  minorTicksPerInterval: 1,
                                  activeColor: globals.mainColor,
                                  inactiveColor: globals.mainColor,
                                  onChanged: (dynamic value) {
                                    setState(() {
                                      valuesMap[emotionalQuestions[index]
                                          .questionId] = value;
                                    });
                                  },
                                ),
                              ]))));
                        }),
                    ElevatedButton(
                      style: globals.buttonStyle,
                      onPressed: () {
                        Navigator.pushNamed(
                            context,
                            '/loader',
                            arguments: LoadArguments(
                                mode: 2,
                                answers: valuesMap,
                                userId: 0
                            )).then((value) => Navigator.pop(context));
                      },
                      child: const Text('СОХРАНИТЬ'),
                    )


                  ]);
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

  Widget buildPhysic(List<Question> physicsQuestions, bool isOn) {
    if (!isOn) {
      return ListView.builder(
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: physicsQuestions.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: (globals.mainColor).withOpacity(.1),
                    blurRadius: 5, // soften the shadow
                    spreadRadius: 1.0, //extend the shadow
                    offset: const Offset(
                      5.0, // Move to right 10  horizontally
                      0, // Move to bottom 10 Vertically
                    ),
                  )
                ]),
                child: Card(
                    // shadowColor: Colors.amber[800],
                    child: ListTile(
                        title: Column(children: <Widget>[
                  ListTile(
                      title: Text(physicsQuestions[index].text,
                          style: globals.basicStyle)),
                  SfSlider(
                    min: 0.0,
                    max: 10.0,
                    value: valuesMap[physicsQuestions[index].questionId],
                    interval: 1.0,
                    stepSize: 1,
                    minorTicksPerInterval: 1,
                    activeColor: globals.mainColor,
                    inactiveColor: globals.mainColor,
                    onChanged: (dynamic value) {
                      setState(() {
                        valuesMap[physicsQuestions[index].questionId] = value;
                      });
                    },
                  ),
                ]))));
          });
    } else {
      return Column(children: [
        SizedBox(
          child: ListTile(
            title: Text('Измеряем с помощью устройства'),
          ),
        ),
        LinearProgressIndicator(
            value: animationController.value,
            semanticsLabel: 'Измерение физического состояния',
            color: globals.mainColor)
      ]);
    }
  }
}
