
import 'package:vapp/add_route.dart';
import 'package:vapp/change_product_route.dart';
import 'package:vapp/haldey_screen.dart';
import 'package:vapp/report_screen.dart';
import 'package:vapp/cash_screen.dart';
import 'package:vapp/loader.dart';
import 'package:vapp/me_screen.dart';
import 'package:vapp/measure_route.dart';
import 'package:vapp/product_card_route.dart';
import 'package:vapp/product_list_route.dart';
import 'package:vapp/shop.dart';
import 'package:vapp/vampire_screen.dart';
import 'globals.dart' as globals;
import 'transfer_route.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: _title,
      color:Color(0xFFB70000),
      theme: ThemeData(
        primaryColor:Color(0xFFB70000),
        fontFamily: GoogleFonts.pressStart2p().fontFamily
      ),
      home: const MyStatefulWidget(),
      routes: {
        AddRoute.routeName: (context) =>
        const AddRoute(),
        TransferRoute.routeName: (context) =>
        const TransferRoute(),
        Loader.routeName: (context) =>
        const Loader(),
        MeasureRoute.routeName: (context) =>
        const MeasureRoute(),
        ProductListRoute.routeName: (context) =>
        const ProductListRoute(),
        ProductCardRoute.routeName: (context) =>
        const ProductCardRoute(),
        VampireScreen.routeName: (context) =>
        const VampireScreen(),
        ReportScreen.routeName: (context) =>
        const ReportScreen(),
        HaldeyScreen.routeName: (context) =>
        const HaldeyScreen(),
        ChangeProductRoute.routeName: (context) =>
        const ChangeProductRoute(),
      },

    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final Widget _cashScreen = const CashScreen();
  final Widget _meScreen = MeScreen();
  final Widget _shopScreen = ShopScreen();
  final Widget _vampireScreen = VampireScreen();
  final Widget _haldeyScreen = HaldeyScreen();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  Widget getBody()  {
    if(_selectedIndex == 0) {
      return _cashScreen;
    } else if(_selectedIndex==1) {
      return _meScreen;
    } else if(_selectedIndex==2){
      return _shopScreen;
    } else if (_selectedIndex == 3) {
      return _vampireScreen;
    } else if (_selectedIndex == 4) {
      return _haldeyScreen;
    } else {
      return _cashScreen;
    }
  }
  String getTitle() {
    switch(_selectedIndex){
      case 0:
        return "СЧЕТ";
      case 1:
        return "\"Я\"";
      default:
        return "VAPP";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(getTitle(), style: GoogleFonts.pressStart2p()),
        centerTitle: true,
        backgroundColor: globals.mainColor,
      ),
      body: getBody(),
      bottomNavigationBar: GestureDetector(
          onDoubleTap: ()=> {
            showAlertDialog(context)
          },
          child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Счет',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: '"Я"',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop_2_outlined),
            label: 'Магазин',
          ),
        ],
        currentIndex: getIndex(_selectedIndex),
        selectedItemColor: globals.mainColor,
        onTap: _onItemTapped,
      )),
    );
  }

  getIndex(index) {
    if (index>=3) return 1;
    return index;
  }
  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget vampireButton = TextButton(
      child: Text("Вампир"),
      onPressed:  () {
        Navigator.pop(context);
        _onItemTapped(3);
      },
    );
    Widget haldeyButton = TextButton(
      child: Text("Халдей"),
      onPressed:  () {
        Navigator.pop(context);
        _onItemTapped(4);
      },
    );

    Widget userButton = TextButton(
      child: Text("Юзверь"),
      onPressed:  () {
        Navigator.of(context).pop();
        _onItemTapped(0);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Тип пользователя"),
      content: Text("Какой вы покемон?"),
      actions: [
        vampireButton,
        haldeyButton,
        userButton
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}





