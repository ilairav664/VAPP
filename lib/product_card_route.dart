import 'package:flutter/material.dart';
import 'package:vapp/loader.dart';
import 'package:vapp/models/account.dart';
import 'package:vapp/models/shop.dart';
import 'globals.dart' as globals;
import 'network.dart' as service;
class ProductCardRoute extends StatefulWidget {


  static const routeName = '/productCard';
  const ProductCardRoute({super.key});
  @override
  State<ProductCardRoute> createState() => _ProductCardRouteState();

}

class _ProductCardRouteState extends State<ProductCardRoute> {
  late Future<List<Account>> futureAccounts;
  late int dropDownValue;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureAccounts = service.fetchAccounts();
    dropDownValue = 0;
  }

  @override
  Widget build(BuildContext context) {


    final product = ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Товары'),
        backgroundColor: globals.mainColor,
      ),
      body: ListView(
        shrinkWrap: true,
        reverse: false,
        padding: EdgeInsets.all(10),
        children: [

          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child:  ListTile(
              title:Text('Наименование товара: ${product.name}', style: globals.basicStyle,) ,
            ),
          ),

          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child:   ListTile(
              title: Text('Описание: ', style: globals.basicStyle,),
            ),
          ),


          SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Row(
                  children: <Widget>[
                    Expanded(
                        child:Text(product.description, style: globals.basicStyle)),
                    Expanded(
                        child: Image.network(product.imageUrl,
                            fit:BoxFit.fill))
                  ])
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child:  ListTile(
              title:Text('Цена: ${product.cost}', style: globals.bigStyle) ,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child:
                FutureBuilder<List<Account>>(
                future: futureAccounts,
                builder: (context, snapshot) {
                if (snapshot.hasData) {

                  return Row(children: [
                    Text("Выберите счет оплаты:", style: globals.basicStyle),
                    Spacer(),
                    DropdownButton<int>(
                    value: dropDownValue,
                    icon: Icon(Icons.arrow_downward, color: globals.mainColor,),
                    elevation: 16,
                    style:  TextStyle(color: globals.mainColor),
                    underline: Container(
                      height: 2,
                      color: globals.mainColor,
                    ),
                    onChanged: (int? value) {
                      setState(() {
                        dropDownValue = value!;
                      });
                    },
                    items: snapshot.data!.map<DropdownMenuItem<int>>((account) {
                      return DropdownMenuItem<int>(
                        value: account.accountId,
                        child: Center(child: Text(account.accountName)),
                      );
                    }).toList(),
                  )
                  ]);

                 } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                }
                 return const CircularProgressIndicator();
                }

          ),
      ),
          SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child:  ListTile(
                title:
                ElevatedButton(
                  style: globals.buttonStyle,
                  onPressed: () {
                    Navigator.pushNamed(
                        context,
                        '/loader',
                        arguments: LoadArguments(accountId: dropDownValue, mode:3, productId: product.productId
                        ));
                  },
                  child: const Text('ОПЛАТИТЬ'),
                ),)
          )
    ]
      ));
  }

}




