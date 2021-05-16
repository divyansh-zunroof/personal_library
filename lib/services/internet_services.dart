import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LoginService{
  String email;
  String password;
  LoginService({this.email, this.password});

  Future<String> loginUser() async {
    Map request_body = {
      "email": this.email,
      "password": this.password
    };
    var url = Uri.https('2a56a82b3ca6.ngrok.io', '/library/login');
    Map data;
    var response = await http.post(
      url,
    headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    },
    body: convert.jsonEncode(request_body),
    );

    if (response.statusCode == 200) {
      data = convert.jsonDecode(response.body) as Map;
      String loginDetail = data['login'];
      String hash = data['hash'];
      print('Login for this user is $loginDetail.');
      return hash;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return response.statusCode.toString();
    }
  }
}

class SignUpService{
  String fname, lname, email, phone, country, password;

  SignUpService({this.fname, this.lname, this.email, this.phone, this.country, this.password});

  Future<String> createUser() async {
    Map request_body = {
      "fname": this.fname,
      "lname": this.lname,
      "email": this.email,
      "phone": this.phone,
      "country": this.country,
      "password": this.password
    };
    var url = Uri.https('2a56a82b3ca6.ngrok.io', '/library/create');
    Map data;
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(request_body),
    );

    if (response.statusCode == 200) {
      data = convert.jsonDecode(response.body) as Map;
      Map loginDetail = data;
      print('Response for this Signup is: $loginDetail.');
      return data['status'];
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return "Unsuccessfull";
    }
  }
}

class LibraryService{
  String userEmail;
  String userHash;
  LibraryService({this.userEmail, this.userHash});

  Future<List> loadBooks() async {
    Map request_body = {
      "email": this.userEmail,
      "hash": this.userHash
    };

    var url = Uri.https('2a56a82b3ca6.ngrok.io', '/library/get_books');

    var response =  await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(request_body),
    );
    Map data = convert.jsonDecode(response.body) as Map;
    List books = [];
    books = data['book_list'];
    return books;
  }

  Future<String> addBooktoLib(String title, String author, String pages, String book_url) async {
    Map request_body = {
      "email": this.userEmail,
      "hash": this.userHash,
      "title": title,
      "author": author,
      "pages": pages,
      "url": book_url
    };
    var url = Uri.https('2a56a82b3ca6.ngrok.io', '/library/add_books');
    var response =  await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(request_body),
    );
    Map data = convert.jsonDecode(response.body) as Map;
    return data['status'];
  }
}