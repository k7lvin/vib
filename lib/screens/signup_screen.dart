import 'package:flutter/material.dart';
import 'package:sociole/animations/fade_animations.dart';
import 'package:sociole/screens/intro_screen.dart';
import 'package:sociole/screens/login_screen.dart';
import 'package:sociole/services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  static final String id = 'signup_screen';
  SignupScreen({Key key}) : super(key: key);

  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formkey = GlobalKey<FormState>();
  String _name, _email, _password, _confirmpass;
  _submit() {
    if (_password == _confirmpass && _formkey.currentState.validate()) {
      _formkey.currentState.save();
      // login user w/ firebase
      AuthService.signature(context, _name, _email, _password);
    }
  }

  Widget signUp() {
    return FadeAnimation(
      1,
      new Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.05), BlendMode.dstATop),
            image: AssetImage('assets/images/user_placeholder.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formkey,
          child: new Column(
            children: <Widget>[
              Expanded(
                              child: Container(
                  padding: EdgeInsets.all(100.0),
                  child: Center(
                    child: Icon(
                      Icons.headset_mic,
                      color: Colors.redAccent,
                      size: 50.0,
                    ),
                  ),
                ),
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "NAME",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: .0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        validator: (input) => input.trim().isEmpty
                            ? 'Please enter a valid name'
                            : null,
                        onSaved: (input) => _name = input,
                        obscureText: false,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'samarthagarwal',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "EMAIL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        validator: (input) => !input.contains('@')
                            ? 'Please enter a valid email'
                            : null,
                        onSaved: (input) => _email = input,
                        obscureText: false,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'samarthagarwal@live.com',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "PASSWORD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        validator: (input) => input.length < 6
                            ? 'Must be at least 6 characters'
                            : null,
                        onSaved: (input) => _password = input,
                        obscureText: true,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '*********',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                children: <Widget>[
                  new Expanded(
                    child: new Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: new Text(
                        "CONFIRM PASSWORD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              new Container(
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: Colors.redAccent,
                        width: 0.5,
                        style: BorderStyle.solid),
                  ),
                ),
                padding: const EdgeInsets.only(left: 0.0, right: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: TextFormField(
                        validator: (input) => input.length < 6
                            ? 'Must be at least 6 characters'
                            : null,
                        onSaved: (input) => _confirmpass = input,
                        obscureText: true,
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '*********',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 24.0,
              ),
              new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FlatButton(
                          onPressed: () => goback(),
                          child: Text(
                            '<',
                            style: TextStyle(
                                fontFamily: 'neon',
                                fontWeight: FontWeight.bold,
                                fontSize: 50.0,
                                color: Colors.redAccent),
                          )),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 0.0),
                        child: new FlatButton(
                            child: new Text(
                              "Already have an account?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                                fontSize: 15.0,
                              ),
                              textAlign: TextAlign.end,
                            ),
                            onPressed: () => gotoLogin()),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                              child: Container(
                                
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 30.0, right: 30.0, top: 25.0),
                  alignment: Alignment.center,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new FlatButton(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          color: Colors.redAccent,
                          onPressed: _submit,
                          child: new Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 20.0,
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(
                                  child: Text(
                                    "SIGN UP",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 1500),
      curve: Curves.bounceOut,
    );
  }

  goback() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      1,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  PageController _controller =
      new PageController(initialPage: 3, viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: _controller,
            physics: new AlwaysScrollableScrollPhysics(),
            children: <Widget>[LoginScreen(), IntroScreen(), signUp()],
            scrollDirection: Axis.horizontal,
          )),
    );
  }
}

////////
///
// import 'package:flutter/material.dart';
// import 'package:sociole/animations/fade_animations.dart';
// import 'package:sociole/services/auth_service.dart';
// import 'package:sociole/utilities/custom_icons.dart';
// import 'package:sociole/utilities/social_icons.dart';

// import 'intro_screen.dart';

// class SignupScreen extends StatefulWidget {
//   static final String id = 'signup_screen';

//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final _formkey = GlobalKey<FormState>();
//   String _name, _email, _password;
//   _submit() {
//     if (_formkey.currentState.validate()) {
//       _formkey.currentState.save();
//       // login user w/ firebase
//       AuthService.signature(context, _name, _email, _password);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Scaffold(

//       body: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//             gradient: LinearGradient(begin: Alignment.topCenter, colors: [
//           Colors.orange[900],
//           Colors.orange[800],
//           Colors.orange[400]
//         ])),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             SizedBox(
//               height: 80,
//             ),
//             Padding(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   FadeAnimation(
//                       1,
//                       Text(
//                         "Sign Up",
//                         style: TextStyle(color: Colors.white, fontSize: 40),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   FadeAnimation(
//                       1.3,
//                       Text(
//                         "Hello There",
//                         style: TextStyle(color: Colors.white, fontSize: 18),
//                       )),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(60),
//                         topRight: Radius.circular(60))),
//                 child: Padding(
//                   padding: EdgeInsets.all(20),
//                   child: SingleChildScrollView(
//                     child: Form(
//                       key: _formkey,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           children: <Widget>[
//                             SizedBox(
//                               height: 5,
//                             ),
//                             FadeAnimation(
//                                 1.4,
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       border:
//                                           Border.all(color: Colors.grey[400]),
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(30),
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color:
//                                                 Color.fromRGBO(225, 95, 27, .6),
//                                             blurRadius: 10,
//                                             offset: Offset(0, 15))
//                                       ]),
//                                   child: Column(
//                                     children: <Widget>[
//                                       Container(
//                                         padding: EdgeInsets.all(10),
//                                         child: TextFormField(
//                                           decoration: InputDecoration(
//                                             icon: Icon(Icons.account_circle),
//                                             labelText: 'Name',
//                                           ),
// validator: (input) =>
//     input.trim().isEmpty
//         ? 'Please enter a valid name'
//         : null,
// onSaved: (input) => _name = input,
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: EdgeInsets.all(10),
//                                         child: TextFormField(
//                                           decoration: InputDecoration(
//                                               icon: Icon(Icons.email),
//                                               labelText: 'Email'),
//                                           validator: (input) =>
//                                               !input.contains('@')
//                                                   ? 'Please enter a valid email'
//                                                   : null,
//                                           onSaved: (input) => _email = input,
//                                         ),
//                                       ),
//                                       Container(
//                                         padding: EdgeInsets.all(10),
//                                         child: TextFormField(
//                                           decoration: InputDecoration(
//                                               icon: Icon(Icons.lock),
//                                               labelText: 'Password'),
//                                           validator: (input) => input.length < 6
//                                               ? 'Must be at least 6 characters'
//                                               : null,
//                                           onSaved: (input) => _password = input,
//                                           obscureText: true,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 )),
//                             SizedBox(
//                               height: 30.0,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: <Widget>[
//                                 FadeAnimation(
//                                     1.6,
//                                     InkWell(
//                                       child: Container(
//                                         height: 40,
//                                         width: 140,
//                                         margin: EdgeInsets.all(10.0),
//                                         decoration: BoxDecoration(
//                                             gradient: LinearGradient(colors: [
//                                               Colors.orangeAccent,
//                                               Colors.deepOrangeAccent
//                                             ]),
//                                             borderRadius:
//                                                 BorderRadius.circular(20.0),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                   color: Color(0xFF6078ea)
//                                                       .withOpacity(.3),
//                                                   offset: Offset(0.0, 8.0),
//                                                   blurRadius: 8.0)
//                                             ]),
//                                         child: Material(
//                                           color: Colors.transparent,
//                                           child: InkWell(
//                                             onTap: _submit,
//                                             child: Center(
//                                               child: Text("Sign-Up",
//                                                   style: TextStyle(
//                                                       fontFamily: 'PoppinBold',
//                                                       color: Colors.white,
//                                                       fontSize: 18,
//                                                       letterSpacing: 1.0)),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     )),
//                                 FadeAnimation(
//                                     1.6,
//                                     InkWell(
//                                       child: Container(
//                                         height: 45,
//                                         width: 80,
//                                         margin: EdgeInsets.all(10.0),
//                                         decoration: BoxDecoration(
//                                             gradient: LinearGradient(colors: [
//                                               Colors.orangeAccent,
//                                               Colors.deepOrangeAccent
//                                             ]),
//                                             borderRadius:
//                                                 BorderRadius.circular(20.0),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                   color: Color(0xFF6078ea)
//                                                       .withOpacity(.3),
//                                                   offset: Offset(0.0, 8.0),
//                                                   blurRadius: 8.0)
//                                             ]),
//                                         child: Material(
//                                           color: Colors.transparent,
//                                           child: InkWell(
//                                             onTap: () => Navigator.pop(context),
//                                             child: Center(
//                                               child: Text("Back",
//                                                   style: TextStyle(
//                                                       fontFamily: 'PoppinBold',
//                                                       color: Colors.white,
//                                                       fontSize: 18,
//                                                       letterSpacing: 1.0)),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     )),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 20.0,
//                             ),
//                             FadeAnimation(
//                                 1.7,
//                                 Text(
//                                   "Or Continue with social media",
//                                   style: TextStyle(color: Colors.black),
//                                 )),
//                             SizedBox(
//                               height: 25.0,
//                             ),
//                             FadeAnimation(
//                               1.9,
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: <Widget>[
//                                   SocialIcon(
//                                     colors: [
//                                       Color(0xFF102397),
//                                       Color(0xFF187adf),
//                                       Color(0xFF00eaf8),
//                                     ],
//                                     iconData: CustomIcons.facebook,
//                                     onPressed: () {},
//                                   ),
//                                   SocialIcon(
//                                     colors: [
//                                       Color(0xFFff4f38),
//                                       Color(0xFFff355d),
//                                     ],
//                                     iconData: CustomIcons.googlePlus,
//                                     onPressed: () {},
//                                   ),
//                                   SocialIcon(
//                                     colors: [
//                                       Color(0xFF17ead9),
//                                       Color(0xFF6078ea),
//                                     ],
//                                     iconData: CustomIcons.twitter,
//                                     onPressed: () {},
//                                   ),
//                                   SocialIcon(
//                                     colors: [
//                                       Color(0xFF00c6fb),
//                                       Color(0xFF005bea),
//                                     ],
//                                     iconData: CustomIcons.linkedin,
//                                     onPressed: () {},
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
