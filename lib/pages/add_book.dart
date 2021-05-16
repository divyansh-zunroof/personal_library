import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_library/services/internet_services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:personal_library/pages/library_page.dart';

class AddBook extends StatefulWidget {
  Map UserData;
  AddBook({Key key, this.UserData}) : super(key: key);

  @override
  _AddBookState createState() => _AddBookState(UserData: this.UserData);
}

class _AddBookState extends State<AddBook> {
  Map UserData;
  _AddBookState({this.UserData});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Book"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(40.0),
          child: addBookForm(UserData: this.UserData,)
      )
    );
  }
}

class addBookForm extends StatefulWidget {
  Map UserData;
  addBookForm({Key key, this.UserData}) : super(key: key);

  @override
  _addBookFormState createState() => _addBookFormState(UserData: this.UserData);
}

class _addBookFormState extends State<addBookForm> {
  Map UserData;
  bool isloading = false;
  _addBookFormState({this.UserData});

  Future<void> addBook() async {
    setState(() {
      isloading = true;
    });
    String status = await LibraryService(userEmail: this.UserData['email'], userHash: this.UserData['hash']).addBooktoLib(
        titleController.text, authorController.text, pageController.text, urlController.text);
    if(status == "successfull"){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => LibraryPage(
            userData: {'email': this.UserData['email'], 'hash': this.UserData['hash']},
          )
          )
      );
    }
  }

  TextEditingController titleController = new TextEditingController();
  TextEditingController authorController = new TextEditingController();
  TextEditingController pageController = new TextEditingController();
  TextEditingController urlController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Book Title",
          ),
        ),
        SizedBox(height: 10.0,),
        TextField(
          controller: authorController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Book Author",
          ),
        ),
        SizedBox(height: 10.0,),
        TextField(
          controller: pageController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Book Pages",
          ),
        ),
        SizedBox(height: 10.0,),
        TextField(
          controller: urlController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Book Url",
          ),
        ),
        SizedBox(height: 10.0,),
        ElevatedButton(
            onPressed: () {
              addBook();
            },
            child: isloading? Loading(): Text("Add book")
        ),
        SizedBox(height: 10.0,),
        ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => LibraryPage(
                    userData: {'email': this.UserData['email'], 'hash': this.UserData['hash']},
                  )
                  )
              );
            },
            child: Text("Back to Library")
        )
      ],
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitRing(
        color: Colors.white,
        size: 30.0,
      ),
    );
  }
}
