import 'package:http/http.dart';
import 'dart:convert';

class Auth {
  bool auth;

  Auth.fromJson(Map json) {
    this.auth = json['auth'];
  }
}

class Company {
  String company;
  int totalEmployees;

  Company.fromJson(Map json) {
    this.company = json['company'];
    this.totalEmployees = json['totalEmployee'];
  }
}

class Employees {
  int totalEmployee;

  Employees.fromJson(Map json) {
    this.totalEmployee = json['totalEmployee'];
  }
}

class TodoCat {
  List<dynamic> cat;

  TodoCat.fromJson(Map json) {
    this.cat = json['collections'];
  }
}

class TaskToday {
  int total;

  TaskToday.fromJson(Map json) {
    this.total = json['taskToday'];
  }
}

Future getAuth(String email) async {
  print('getAuth : $email');
  var data = await get(
      'https://us-central1-btec-e4bef.cloudfunctions.net/getAuth',
      headers: {'email': email});
  var user = new Auth.fromJson(json.decode(data.body));
  print('getAuth : ${user.auth}');
  return user.auth;
}

Future getCompany(String email, String uid) async {
  print('getCompany : $email $uid');
  var data = await post(
      'https://us-central1-btec-e4bef.cloudfunctions.net/getCompany',
      body: {'email': email, 'uid': uid});
  var user = new Company.fromJson(json.decode(data.body));
  print(
      'getCompany : ${user.company}\ntotalEmployees : ${user.totalEmployees}');
  return user;
}

Future sendSms(String uid) {
  print('sendSms');
  return post('https://us-central1-btec-e4bef.cloudfunctions.net/sendSms',
      body: {'uid': uid}).catchError((onError) => print('error!!! : $onError'));
}

Future addDetailsEvent(Map<String, String> container) {
  print('addDetailsEvent : ${container.length}');
  return post('https://us-central1-btec-e4bef.cloudfunctions.net/addDetailsEvent',
          body: container)
      .catchError((onError) => print('error!!! : $onError'));
}

Future getTotalEmployee(String uid) async {
  print('getTotalEmployee : $uid');
  var data = await get(
      'https://us-central1-btec-e4bef.cloudfunctions.net/getTotalEmployee/$uid');
  if (data.body == "") {
    int responseData = 0;
    print('getTotalEmployee : $responseData');
    return responseData;
  } else {
    var employee = new Employees.fromJson(json.decode(data.body));
    print('getTotalEmployee : ${employee.totalEmployee}');
    print(employee.totalEmployee);
    return employee.totalEmployee;
  }
}

Future addEmployee(Map<String, String> container) {
  print('addEmployee : ${container.length}');
  return post('https://us-central1-btec-e4bef.cloudfunctions.net/addEmployee',
          body: container)
      .catchError((onError) => print('error!!! : $onError'));
}

Future editEmployee(Map<String, String> container) {
  print('editEmployee : ${container.length}');
  return post('https://us-central1-btec-e4bef.cloudfunctions.net/editEmployee',
          body: container)
      .catchError((onError) => print('error!!! : $onError'));
}

Future deleteEmployee(Map<String, String> container) {
  print('deleteEmployee : ${container.length}');
  return post(
          'https://us-central1-btec-e4bef.cloudfunctions.net/deleteEmployee',
          body: container)
      .catchError((onError) => print('error!!! : $onError'));
}

Future ratingEmployee(Map<String, String> container) {
  print('ratingEmployee : ${container.length}');
  return post(
          'https://us-central1-btec-e4bef.cloudfunctions.net/ratingEmployee',
          body: container)
      .catchError((onError) => print('error!!! : $onError'));
}

// Future getTodoCat(String uid) async {
//   print('getTodoCat : $uid');
//   var data = await get(
//       'https://us-central1-btec-e4bef.cloudfunctions.net/getTodoCat/$uid');
//   var todoCat = new TodoCat.fromJson(json.decode(data.body));
//   print('getTodoCat : ${todoCat.cat}');
//   print(todoCat.cat.length);
//   return todoCat.cat;
// }

Future deleteCat(Map<String, String> container) {
  print('deleteCat : ${container.length}');
  return post('https://us-central1-btec-e4bef.cloudfunctions.net/deleteCat',
          body: container)
      .catchError((onError) => print('error!!! : $onError'));
}

Future getTaskToday(Map<String, String> container) async {
  print('getTaskToday : ${container.length}');
  var data = await get(
      'https://us-central1-btec-e4bef.cloudfunctions.net/getTaskToday',
      headers: container);
  var taskToday = new TaskToday.fromJson(json.decode(data.body));
  print('getTaskToday : ${taskToday.total}');
  print(taskToday.total);
  return taskToday.total;
}

Future addTask(Map<String, String> container) {
  print('addTask : ${container.length}');
  return post('https://us-central1-btec-e4bef.cloudfunctions.net/addTask',
          body: container)
      .catchError((onError) => print('error!!! : $onError'));
}

Future editTask(Map<String, String> container) {
  print('editTask : ${container.length}');
  return post('https://us-central1-btec-e4bef.cloudfunctions.net/editTask',
          body: container)
      .catchError((onError) => print('error!!! : $onError'));
}

Future doneTask(Map<String, String> container) {
  print('doneTask : ${container.length}');
  return post('https://us-central1-btec-e4bef.cloudfunctions.net/doneTask',
          body: container)
      .catchError((onError) => print('error!!! : $onError'));
}

Future addBranch(Map<String, String> container) {
  print('addBranch : ${container.length}');
  return post('https://us-central1-btec-e4bef.cloudfunctions.net/addBranch',
          body: container)
      .catchError((onError) => print('error!!! : $onError'));
}

Future addCat(Map<String, String> container) {
  print('addCat : ${container.length}');
  return post('https://us-central1-btec-e4bef.cloudfunctions.net/addCat',
          body: container)
      .catchError((onError) => print('error!!! : $onError'));
}
