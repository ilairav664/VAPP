import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:vapp/models/account.dart';
import 'package:vapp/models/form.dart';
import 'package:vapp/models/question.dart';
import 'package:vapp/models/shop.dart';
import 'package:vapp/models/user.dart';
Future<List<Account>> fetchAccounts() async {
  final response = await http
      .get(Uri.parse('http://192.168.0.138:8080/account?userId=0'));
  if (response.statusCode == 200) {

    List<Account> accounts;
    accounts=(json.decode(response.body)).map<Account>((i) =>
        Account.fromJson(i)).toList();
    return accounts;
  } else {
    throw Exception('Failed to load accounts');
  }
}

Future<List<User>> fetchUsers() async {
  final response = await http
      .get(Uri.parse('http://192.168.0.138:8080/reports/users'));
  if (response.statusCode == 200) {

    List<User> users;
    users=(json.decode(response.body)).map<User>((i) =>
        User.fromJson(i)).toList();
    return users;
  } else {
    throw Exception('Failed to load accounts');
  }
}

Future<int> fetchReport(userId, start, end) async {
  int result;
  final response = await http
      .get(Uri.parse('http://192.168.0.138:8080/reports/user/report?userId=${userId}&start=${start}&end=${end}'));
  if (response.statusCode == 200) {

    result = int.parse(response.body);
  } else {
    throw Exception('Failed to load accounts');
  }
  return result;
}

Future<List<Question>> fetchQuestions() async {
  final response = await http
      .get(Uri.parse('http://192.168.0.138:8080/state/questions'));
  if (response.statusCode == 200) {

    List<Question> questions;
    questions=(json.decode(response.body)).map<Question>((i) =>
        Question.fromJson(i)).toList();
    return questions;
  } else {
    throw Exception('Failed to load questions');
  }
}

Future<int> addMoney(int accountId, int amount, String cardNumber) async {
  final response = await http
      .post(Uri.parse('http://192.168.0.138:8080/account/addMoney?accountId=$accountId&amount=$amount&cardNumber=$cardNumber'));
  if (response.statusCode == 200) {
    return 0;
  } else {
    return 1;
  }
}

Future<int> transferMoney(int accountId, int amount, String cardNumber) async {
  final response = await http
      .post(Uri.parse('http://192.168.0.138:8080/account/transferMoney?accountId=$accountId&amount=$amount&cardNumber=$cardNumber'));
  if (response.statusCode == 200) {
    return 0;
  } else {
    return 1;
  }
}

Future<int> sendAnswers(int userId, HashMap answers) async {
  List<Answer> ans = [];
  answers.forEach((key, value) {
    ans.add(Answer(questionId: key, value: value));
  });
  Form form = Form(userId: userId, answers: ans);


  final response = await http
      .post(
    Uri.parse('http://192.168.0.138:8080/state/answers'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(form),);
  if (response.statusCode == 200) {
    return 0;
  } else {
    return 1;
  }
}

Future<List<Shop>> fetchShops() async {
  final response = await http
      .get(Uri.parse('http://192.168.0.138:8080/shop/shops'));
  if (response.statusCode == 200) {

    List<Shop> shops;
    shops=(json.decode(response.body)).map<Shop>((i) =>
        Shop.fromJson(i)).toList();
    return shops;
  } else {
    throw Exception('Failed to load shops');
  }
}

Future<int> createOrder(int accountId, int productId) async {

  final response = await http
      .post(Uri.parse('http://192.168.0.138:8080/shop?accountId=$accountId&productId=$productId'));
  if (response.statusCode == 200) {
    return 0;
  } else {
    return 1;
  }
}

Future<int> saveProduct(int productId, int bablos) async {

  final response = await http
      .post(Uri.parse('http://192.168.0.138:8080/shop/update/product?productId=$productId&&bablos=$bablos'));
  if (response.statusCode == 200) {
    return 0;
  } else {
    return 1;
  }
}