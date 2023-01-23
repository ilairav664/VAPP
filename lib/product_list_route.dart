import 'package:flutter/material.dart';
import 'package:vapp/models/shop.dart';
import 'globals.dart' as globals;
class ProductListRoute extends StatefulWidget {


  static const routeName = '/productList';
  const ProductListRoute({super.key});
  @override
  State<ProductListRoute> createState() => _ProductListRouteState();

}

class _ProductListRouteState extends State<ProductListRoute> {

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {


    final productList = ModalRoute.of(context)!.settings.arguments as List<Product>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Товары'),
        backgroundColor: globals.mainColor,
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: productList.length,
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

              child: InkWell(
              onTap:() {
            Navigator.pushNamed(
                context,
                '/productCard',
                arguments: productList[index]
                    );
                  },
                  child: Card(
                // shadowColor: Colors.amber[800],
                  child:ListTile(
                      title: Row(
                          children: <Widget>[
                            Expanded(
                                child: Image.network(productList[index].imageUrl,
                                    width: 10,
                                    height: 80,
                                    fit:BoxFit.fill)),
                            Expanded(
                                child:SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: ListTile(title: Text(productList[index].name, style: globals.basicStyle)),
                                )),
                            Expanded(
                                child:SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: ListTile(title: Text('${productList[index].cost} \$', style: globals.basicStyle,)),
                                ))
                          ])))));
        }
    )
    );
  }

}


