import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vapp/loader.dart';
import 'package:vapp/models/account.dart';
import 'package:vapp/models/shop.dart';
import 'globals.dart' as globals;
import 'network.dart' as service;
class ChangeProductRoute extends StatefulWidget {


  static const routeName = '/changeProduct';
  const ChangeProductRoute({super.key});
  @override
  State<ChangeProductRoute> createState() => _ChangeProductRouteState();

}

class _ChangeProductRouteState extends State<ChangeProductRoute> {
  final bablosController = TextEditingController();
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
    var summFormatter = MaskTextInputFormatter(
        mask: '#######',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
    );

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
              title:Text('Баблос: ${product.bablos}', style: globals.bigStyle) ,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Text("Введите количество баблоса:")
      ),
          Padding(padding: EdgeInsets.all(10)),
          SizedBox(
              width: MediaQuery.of(context).size.width / 10,
              child:  ListTile(
                  title:
                  TextField(inputFormatters: [summFormatter], style: globals.basicStyle, decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: globals.mainColor, width: 1),
                    ),
                    hintText: '10',
                  ), controller: bablosController,))
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width / 10,
              child:  ListTile(
                title:
                ElevatedButton(
                  style: globals.buttonStyle,
                  onPressed: () {
                    Navigator.pushNamed(
                        context,
                        '/loader',
                        arguments: LoadArguments(accountId: dropDownValue, mode:4, productId: product.productId, bablos: int.parse(bablosController.text)
                        ));
                  },
                  child: const Text('СОХРАНИТЬ'),
                ),)
          )
    ]
      ));
  }

}




