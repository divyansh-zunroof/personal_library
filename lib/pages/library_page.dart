import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_library/services/internet_services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:personal_library/pages/add_book.dart';


class LibraryPage extends StatefulWidget {
  Map userData;
  LibraryPage({Key key, this.userData}) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState(userData: this.userData);
}

class _LibraryPageState extends State<LibraryPage> {
  Map userData;
  String userHash, userEmail;
  bool isloading = false;
  bool hasData = false;
  List books = [{"title": "Divyansh"}, {"title": "Srivastava"}];

  _LibraryPageState({this.userData});

  void getBooks() async{
    setState(() {
      this.isloading = true;
    });
    this.books = await LibraryService(
      userEmail: userEmail,
      userHash: userHash,
    ).loadBooks();
    setState(() {
      this.isloading = false;
      this.hasData = true;
    });
  }

  void deleteBook(Map book){
    setState(() {
      books.remove(book);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context).settings.arguments != null)
      this.userData = ModalRoute.of(context).settings.arguments;
    this.userHash = userData['hash'];
    this.userEmail = userData['email'];
    if(!hasData)
      getBooks();
    return Scaffold(
      appBar: AppBar(
        title: Text("Library"),
        centerTitle: true,
      ),

      body: isloading? Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/image.jpg"),
                  fit: BoxFit.cover)
          ),
          child: loading()
      ): Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/image.jpg"),
                fit: BoxFit.cover)
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
          child: new ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            children: books.map((book) => BookCard(
              bookTitle: book['title'],
              bookAuthor: book['author'],
              bookPages: book['pages'],
              bookUrl: book['url'],
              book: book,
              onDelete: deleteBook
            )).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AddBook(
            UserData: {'email': this.userEmail, 'hash': this.userHash},
          )
          )
          );
        },
        child: Icon(
          Icons.add
        ),
      ),
    );
  }
}

class BookCard extends StatefulWidget {
  String bookTitle ,bookAuthor, bookPages, bookUrl;
  Map book;
  Function onDelete;
  BookCard({Key key, this.bookTitle, this.bookUrl, this.bookPages, this.bookAuthor, this.book, this.onDelete}) : super(key: key);

  @override
  _BookCardState createState() => _BookCardState(
      bookTitle: this.bookTitle,
    bookAuthor: this.bookAuthor,
    bookPages: this.bookPages,
    bookUrl: this.bookUrl,
    book: book,
    onDelete: this.onDelete
  );
}

class _BookCardState extends State<BookCard> {
  String bookTitle, bookAuthor, bookPages, bookUrl;
  Map book;
  Function onDelete;
  _BookCardState({this.bookTitle, this.bookAuthor, this.bookPages, this.bookUrl, this.book, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                      "Title: ",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                    ),
                  ),
                  Text(
                      this.bookTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Author: ",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0
                    ),
                  ),
                  Text(
                    this.bookAuthor,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Pages: ",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0
                    ),
                  ),
                  Text(
                    this.bookPages,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Book Url: ",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0
                    ),
                  ),
                  SizedBox(
                    width: 200.0,
                    height: 20.0,
                    child: Text(
                      this.bookUrl,
                    ),
                  )
                ],
              ),
              // IconButton(
              //   color: Colors.red,
              //     icon: Icon(Icons.delete),
              //     onPressed: this.onDelete(this.book)
              //     )
            ]
        ),
      ),
    );
  }
}

class loading extends StatelessWidget {
  const loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitRing(
        color: Colors.blue,
        size: 100.0,
      ),
    );
  }
}

