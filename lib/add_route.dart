
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vapp/loader.dart';

import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:vapp/models/account.dart';
class AddRoute extends StatefulWidget {


  static const routeName = '/addMoney';
  const AddRoute({super.key});
  @override
  State<AddRoute> createState() => _AddRouteState();

}

class _AddRouteState extends State<AddRoute> {
  final amountController = TextEditingController();
  final cardNumberController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    amountController.dispose();
    cardNumberController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {


    final account = ModalRoute.of(context)!.settings.arguments as Account;
    var cardFormatter = MaskTextInputFormatter(
        mask: '#### #### #### ####',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
    );
    var summFormatter = MaskTextInputFormatter(
        mask: '#######',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пополнение'),
        backgroundColor: globals.mainColor,
      ),
      body: ListView(
        shrinkWrap: true,
        reverse: false,
        padding: const EdgeInsets.all(10),
        children: [

          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child:  ListTile(
              title:Text('Наименование счета: ${account.accountName}', style: globals.basicStyle,) ,
            ),
          ),

          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child:   ListTile(
              title: Text('Текущий баланс: ${account.balance}', style: globals.basicStyle,),
            ),
          ),


          SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child:  ListTile(
                title:
                Text('Введите номер карты, с которой хотите пополнить счет: ', style: globals.basicStyle),
              )
          ),

          SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child:  ListTile(
                  title:
                  TextField(inputFormatters: [cardFormatter], style: globals.basicStyle, decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: globals.mainColor, width: 1),
                    ),
                    hintText: 'XXXX-XXXX-XXXX-XXXX',
                  ),controller: cardNumberController,))
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child:  ListTile(
                title:
                Text('Введите сумму для пополнения: ', style: globals.basicStyle),
              )
          ),

          SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child:  ListTile(
                  title:
                  TextField(inputFormatters: [summFormatter], style: globals.basicStyle, decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: globals.mainColor, width: 1),
                    ),
                    hintText: '1000\$',
                  ), controller: amountController,))
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
                        arguments: LoadArguments(accountId: account.accountId, amount: int.parse(amountController.text), cardNumber: cardNumberController.text, mode:0
                        )).then((value) => Navigator.pop(context));
                  },
                  child: const Text('ПОПОЛНИТЬ'),
                ),)
          )


        ],
      ),
    );
  }

}
