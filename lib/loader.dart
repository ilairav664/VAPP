import 'dart:async';
import 'dart:collection';
import 'package:vapp/models/form.dart';
import 'package:vapp/network.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
class Loader extends StatefulWidget {
  static const routeName = '/loader';
  const Loader({super.key});
  @override
  State<Loader> createState() => _LoaderState();


}
class _LoaderState extends State<Loader> {
  Future<int>? _status;
  @override



  @override
  Widget build(BuildContext context) {
    int amount = (ModalRoute.of(context)!.settings.arguments as LoadArguments).amount??0;
    int accountId = (ModalRoute.of(context)!.settings.arguments as LoadArguments).accountId??0;
    String cardNumber = (ModalRoute.of(context)!.settings.arguments as LoadArguments).cardNumber??"";
    int mode = (ModalRoute.of(context)!.settings.arguments as LoadArguments).mode??0;
    int userId = (ModalRoute.of(context)!.settings.arguments as LoadArguments).userId??0;
    HashMap answers = (ModalRoute.of(context)!.settings.arguments as LoadArguments).answers??HashMap();
    int productId = (ModalRoute.of(context)!.settings.arguments as LoadArguments).productId??0;
    int bablos = (ModalRoute.of(context)!.settings.arguments as LoadArguments).bablos??0;
    switch(mode) {
      case 0:
        _status = addMoney(accountId, amount, cardNumber);
        break;
      case 1:
        _status = transferMoney(accountId, amount, cardNumber);
        break;
      case 2:
        _status = sendAnswers(userId, answers);
        break;
      case 3:
        _status = createOrder(accountId, productId);
        break;
      case 4:
        _status = saveProduct(productId, bablos);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(''),
          backgroundColor: globals.mainColor,
          automaticallyImplyLeading: false,
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_status == null) ? CircularProgressIndicator() : buildFutureBuilder(),
        ));

  }

  FutureBuilder<int> buildFutureBuilder() {
    return FutureBuilder<int>(
      future: _status,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Center(child: ListView(
              shrinkWrap: true,
              reverse: false,
              padding: EdgeInsets.all(10),
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child:  ListTile(
                        title:Center(child:Text(snapshot.data == 0?"Успех":"Ошибка", style: globals.bigStyle)))),

                ElevatedButton(
                  style: globals.buttonStyle,
                  child: const Text('Вернуться'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )]));

        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
class LoadArguments {
  int? amount;
  int? accountId;
  String? cardNumber;
  int? mode;
  int? userId;
  HashMap? answers;
  int? productId;
  int? bablos;
  LoadArguments({
    this.userId,
    this.accountId,
    this.amount,
    this.cardNumber,
    this.mode,
    this.answers,
    this.productId,
    this.bablos
  });
}