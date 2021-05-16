import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flip_card/flip_card.dart';
import 'package:personal_library/pages/add_book.dart';
import 'package:personal_library/services/internet_services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:personal_library/pages/library_page.dart';


void main() {
  runApp(MaterialApp(
    initialRoute: '/login',
      routes: {
        '/login': (context) => Home(),
        '/library': (context) => LibraryPage(),
        '/add_book': (context) => AddBook(),
      },
  ));
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool loadingLogin = false;
  bool loadingSignUp = false;
  String userhash;

  // Text editing controllers for login page
  TextEditingController emailLogin = new TextEditingController();
  TextEditingController passwordLogin = new TextEditingController();

  //Text editing controllers for signUp page
  TextEditingController fnameSignUp = new TextEditingController();
  TextEditingController lnameSignUp = new TextEditingController();
  TextEditingController emailSignUp = new TextEditingController();
  TextEditingController phoneSignUp = new TextEditingController();
  TextEditingController passwordSignUp = new TextEditingController();
  TextEditingController confPasswordSignUp = new TextEditingController();
  TextEditingController countrySignUp = new TextEditingController();


  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  Future<void> loginStarter(String email, String password) async {
    setState(() {
      loadingLogin = true;
    });
    String response_hash = await LoginService(email: email, password: password).loginUser();
    this.userhash = response_hash;
    Navigator.pushReplacementNamed(context, '/library', arguments: {'email': email, 'hash': this.userhash});
  }

  Future<void> signUpStarter(String fname, String lname, String email, String phone, String country, String password) async {
    setState(() {
      loadingSignUp = true;
    });
    String response = await SignUpService(
        fname: fname,
        lname: lname,
        email: email,
        phone: phone,
        country: country,
        password: password
    ).createUser();
    if(response == "successfull"){
      cardKey.currentState.toggleCard();
    }
  }

  @override
  Widget build(BuildContext context) {


    TextStyle defaultStyle = TextStyle(color: Colors.grey);
    TextStyle linkStyle = TextStyle(color: Colors.blue[600]);
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Personal Library"),
        centerTitle: true,
      ),

      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/image.jpg"),
                fit: BoxFit.cover)
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
                child: Container(
                color: Colors.transparent,
            )
            ),
            Expanded(
              flex: 15,
                child: Card(
                  color: Colors.transparent,
                  child: FlipCard(
                    front: new ListView(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      children: [
                        Card(
                          elevation: 20.0,
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Welcome to your Personal Library!",
                              style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 23.0,
                              // fontFamily: 'Headings',
                              fontStyle:  FontStyle.italic,
                            ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Card(
                          elevation: 20.0,
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Image(
                                image: AssetImage('assets/images/library.jpg'),
                                  fit: BoxFit.cover
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0,),
                        Card(
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28.0,
                                      fontFamily: 'Headings',
                                      fontStyle:  FontStyle.italic,
                                    ),
                                  ),
                                  SizedBox(height: 10.0,),
                                  TextField(
                                    controller: emailLogin,
                                    keyboardType: TextInputType.emailAddress,
                                    onEditingComplete: () {},
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Email",
                                    ),
                                  ),
                                  SizedBox(height: 10.0,),
                                  TextField(
                                    controller: passwordLogin,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Password",
                                    ),
                                  ),
                                  SizedBox(height: 10.0,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Forgot Password?"
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0,),
                                  loadingLogin? loading() : ElevatedButton(
                                      onPressed: () {
                                        loginStarter(emailLogin.text, passwordLogin.text);
                                      },
                                      child: Text("Login")
                                  ),
                                  SizedBox(height: 20.0,),
                                  Text(
                                    "Not yet signed up for your personal library?"
                                  ),
                                  SizedBox(height: 5.0,),
                                  RichText(
                                    text: TextSpan(
                                      style: defaultStyle,
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Click to create your account!',
                                            style: linkStyle,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                              // Navigator.pushReplacementNamed(context, '/signUp');
                                                cardKey.currentState.toggleCard();
                                                // print('Create your account!');
                                              }),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          elevation: 20.0,
                        ),
                      ],
                    ),
                    back: Card(
                      elevation: 10.0,
                      margin: EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 60.0),
                      child: new ListView(
                        scrollDirection: Axis.vertical,
                        physics: AlwaysScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                            child: Text(
                              "SignUp for your personal library",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),child: Container(
                            height: 1.0,
                            color: Colors.blue,
                          )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 5.0),
                                    child: TextField(
                                      controller: fnameSignUp,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: "First Name",
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: lnameSignUp,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Last Name",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
                              child: TextField(
                                controller: emailSignUp,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Email",
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
                              child: TextField(
                                controller: phoneSignUp,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Phone Number",
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
                              child: TextField(
                                controller: countrySignUp,
                                keyboardType: TextInputType.text,
                                autofillHints: [
                                  "India",
                                  "United States of America",
                                  "Sri Lanka",
                                  "Australia"
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Country",
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
                              child: TextField(
                                controller: passwordSignUp,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Create Password",
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 10.0),
                              child: TextField(
                                controller: confPasswordSignUp,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Confirm Password",
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(25.0),
                            child: loadingSignUp? loading() : ElevatedButton(
                                onPressed: () {
                                  signUpStarter(fnameSignUp.text,
                                      lnameSignUp.text,
                                      emailSignUp.text,
                                      phoneSignUp.text,
                                      countrySignUp.text,
                                      passwordSignUp.text);
                                },
                                child: Text("SignUp")
                            ),
                          ),

                          Padding(padding: EdgeInsets.all(25.0),
                              child: RichText(
                                text: TextSpan(
                                  style: defaultStyle,
                                  children: <TextSpan>[
                                    TextSpan(text: "Already having an account? "),
                                    TextSpan(
                                        text: 'Proceed to login!',
                                        style: linkStyle,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            cardKey.currentState.toggleCard();
                                            // Navigator.pushReplacementNamed(context, '/login');
                                            // print('Create your account!');
                                          }),
                                  ],
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                    key: cardKey,
                    flipOnTouch: false,
                  ),
                  elevation: 0.0,
                )
            ),
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.transparent,
                )
            ),
          ],
        ),
      )
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
          size: 50.0,
        ),
    );
  }
}



