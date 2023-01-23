import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vapp/models/shop.dart';
import 'network.dart' as service;
import 'globals.dart' as globals;


class HaldeyScreen extends StatefulWidget {
  static const routeName = '/haldey';
  const HaldeyScreen({super.key});


  @override
  _HaldeyScreen createState() => _HaldeyScreen();
}

class _HaldeyScreen extends State<HaldeyScreen>{
  late Future<List<Shop>> futureShops;
  late int currentState = 0;
  @override
  void initState() {
    super.initState();
    futureShops = service.fetchShops();
  }


  Widget build(BuildContext context) {
    return Container(
      child:
      ListView(
        children: [
          FutureBuilder<List<Shop>>(
            future: futureShops,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                  List<Product> mappedProducts = List.empty(growable: true);
                  snapshot.data?.forEach((element) {
                    mappedProducts.addAll(element.products);
                  });

                  return Container(
                      height: 567,
                      child:ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: mappedProducts.length,
                      itemBuilder: (BuildContext context, int index) {

                        return Container(
                            width: 300,
                            height: 80,
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
                                child: InkWell(
                                    onTap:() {
                                    },child:ListTile(

                                    title:Column(children:[
                                      Row(

                                          children: <Widget>[
                                            Expanded(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context).size.width / 3,
                                                  child: ListTile(title: Text('${mappedProducts[index].name}', overflow: TextOverflow.ellipsis, style: globals.basicStyle)),
                                                )),
                                         Text('Баблос: ${mappedProducts[index].bablos}', overflow: TextOverflow.ellipsis, style: globals.basicStyle),
                                            Padding(padding: EdgeInsets.all(10)),
                                            ElevatedButton(
                                              style: globals.buttonStyle,
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context,
                                                    '/changeProduct',
                                                  arguments: mappedProducts[index]
                                                ).then((value) => {
                                                setState(() {
                                                futureShops = service.fetchShops() as Future<List<Shop>>;
                                                })

                                                });
                                              },
                                              child: const Text('Изменить'),
                                            )

                                          ]),


                                    ] )))));
                      }
                  ));

              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),

        ],
      )


    );
  }
}
