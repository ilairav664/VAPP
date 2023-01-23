import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vapp/models/shop.dart';
import 'network.dart' as service;
import 'globals.dart' as globals;
class ShopScreen extends StatelessWidget{
  static const routeName = '/shopScreen';
  const ShopScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const ShopList();
  }
}

class ShopList extends StatefulWidget {
  const ShopList({super.key});

  @override
  _ShopList createState() => _ShopList();
}

class _ShopList extends State<ShopList>{
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
          Card(child: Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 20)),
              GestureDetector(
                child: Container(
                    padding: const EdgeInsets.all(10),
                    child:const Text(
                      'МАГАЗИНЫ',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),),
                ),
                onTap:(){
                  setState(() {
                    currentState = 0;
                  });
                },
              ),
              Padding(padding: EdgeInsets.only(left: 90)),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  child:const Text(
                    'ЛЕНТА',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),),
                ),
                onTap:(){
                  setState(() {
                    currentState = 1;
                  });
                },
              ),
            ],
          ),),
          FutureBuilder<List<Shop>>(
            future: futureShops,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (currentState == 0) {
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
                                child: InkWell(
                                    onTap:() {
                                      Navigator.pushNamed(
                                          context,
                                          '/productList',
                                          arguments: snapshot.data![index].products
                                      );
                                    },child:ListTile(
                                    title: Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width / 3,
                                                child: ListTile(title: Text('${snapshot.data![index].name}', style: globals.basicStyle)),
                                              )),
                                          Expanded(
                                              child:SizedBox(
                                                width: MediaQuery.of(context).size.width /3,
                                                child: ListTile(title: Text('${snapshot.data![index].address} ', style: globals.basicStyle,)),
                                              )),
                                        ])))));
                      }
                  );
                } else {
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
                            height: 300,
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
                                      Navigator.pushNamed(
                                          context,
                                          '/productCard',
                                          arguments: mappedProducts[index]
                                      );
                                    },child:ListTile(

                                    title:Column(children:[
                                      Row(

                                          children: <Widget>[
                                            Expanded(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context).size.width / 3,
                                                  child: ListTile(title: Text('${mappedProducts[index].name}', overflow: TextOverflow.ellipsis, style: globals.basicStyle)),
                                                )),
                                          ]),
                                      Row(
                                          children: <Widget>[

                                            Expanded(
                                                child:Text(mappedProducts[index].description, style: globals.basicStyle.copyWith(fontSize: 8))),
                                            Expanded(
                                                child: Image.network(mappedProducts[index].imageUrl,
                                                    fit:BoxFit.fill))
                                          ]),
                                      Row(
                                          children: <Widget>[
                                            Expanded(
                                                child:Text("Цена: " + mappedProducts[index].cost.toString(), style: globals.basicStyle.copyWith(fontSize: 12))),
                                          ]),



                                    ] )))));
                      }
                  ));

                }

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
