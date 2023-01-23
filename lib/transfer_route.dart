import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:vapp/loader.dart';
import 'package:vapp/models/account.dart';
import 'globals.dart' as globals;
class TransferRoute extends StatefulWidget {


  static const routeName = '/transferMoney';
  const TransferRoute({super.key});
  @override
  State<TransferRoute> createState() => _TransferRouteState();

}

class _TransferRouteState extends State<TransferRoute> {
  final amountController = TextEditingController();
  final cardNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
        title: const Text('Перевод'),
        backgroundColor: globals.mainColor,
      ),
      body: Form (
    key: _formKey,
    child:
          ListView(
        shrinkWrap: true,
        reverse: false,
        padding: EdgeInsets.all(10),
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
                Text('Введите номер карты, на которую вы хотите совершить перевод: ', style: globals.basicStyle),
              )
          ),

          SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child:  ListTile(
                  title:
                  TextFormField(inputFormatters: [cardFormatter],
                  validator: (value) {
                  if (value == null || value.isEmpty || value.length!=19) {
                  return 'Введите корректный номер карты';
                  }
                    return null;
                    },
    style: globals.basicStyle, decoration:  InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: globals.mainColor, width: 1),
                    ),
                    hintText: 'XXXX-XXXX-XXXX-XXXX',
                  ), controller: cardNumberController,))
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child:  ListTile(
                title:
                Text('Введите сумму для перевода: ', style: globals.basicStyle),
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
                    if (account.balance < int.parse(amountController.text)) {
                       showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Ошибка'),
                            content: const Text('На счете недостаточно средств для осуществления перевода'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Закрыть'),
                              ),
                            ],
                          ));
                    } else {
    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(
                          context,
                          '/loader',
                          arguments: LoadArguments(accountId: account.accountId,
                              amount: int.parse(amountController.text),
                              cardNumber: cardNumberController.text,
                              mode: 1
                          )).then((value) => Navigator.pop(context));
                    }}
                  },
                  child: const Text('ПЕРЕВЕСТИ'),
                ),)
          )


        ],
      ),
    ));
  }

}