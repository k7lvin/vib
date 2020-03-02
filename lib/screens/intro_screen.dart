import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sociole/screens/login_screen.dart';

import 'package:sociole/screens/signup_screen.dart';

import 'package:sociole/services/auth_service.dart';
import 'package:sociole/animations/fade_animations.dart';
import 'package:sociole/utilities/custom_icons.dart';
import 'package:sociole/utilities/social_icons.dart';

class IntroScreen extends StatefulWidget {
  static final String id = 'intro_screen';
  @override
  _IntroScreenState createState() => new _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {

      
  @override
  void initState() {
    super.initState();
  }

  Widget homePage() {
    return FadeAnimation(
         1, new Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.black87,
         
        ),
        child: new Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 250.0),
              child: FadeAnimation(
                1,
                Center(
                  child: Icon(
                    Icons.headset_mic,
                    color: Colors.white,
                    size: 40.0,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Awesome",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    "App",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 150.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new OutlineButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.redAccent,
                      highlightedBorderColor: Colors.white,
                      onPressed: () => gotoSignup(),
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
            new Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
              alignment: Alignment.center,
              child: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new FlatButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.white,
                      onPressed: () => gotoLogin(),
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
                                "LOGIN",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
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
          ],
        ),
      ),
    );
  }

  


  gotoLogin() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  gotoSignup() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  PageController _controller =
      new PageController(initialPage: 1, viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: _controller,
            physics: new AlwaysScrollableScrollPhysics(),
            children: <Widget>[LoginScreen(), homePage(), SignupScreen()],
            scrollDirection: Axis.horizontal,
          )),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// import 'package:sociole/screens/signup_screen.dart';
// import 'package:sociole/screens/testloginscreen.dart';
// import 'package:sociole/services/auth_service.dart';
// import 'package:sociole/animations/fade_animations.dart';
// import 'package:sociole/utilities/custom_icons.dart';
// import 'package:sociole/utilities/social_icons.dart';

// class IntroScreen extends StatefulWidget {
//   static final String id = 'login_screen';

//   @override
//   _IntroScreenState createState() => _IntroScreenState();
// }

// class _IntroScreenState extends State<IntroScreen> {
  // final _formkey = GlobalKey<FormState>();
  // String _email, _password;
  // _submit() {
  //   if (_formkey.currentState.validate()) {
  //     _formkey.currentState.save();
  //     // login user w/ firebase
  //     AuthService.login(_email, _password);
  //   }
  // }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     return Scaffold(
//     //     body: new Container(
//     //   height: MediaQuery.of(context).size.height,
//     //   decoration: BoxDecoration(
//     //     color: Colors.white,
//     //     image: DecorationImage(
//     //       colorFilter: new ColorFilter.mode(
//     //           Colors.black.withOpacity(0.05), BlendMode.dstATop),
//     //       image: AssetImage('assets/images/mountains.jpg'),
//     //       fit: BoxFit.cover,
//     //     ),
//     //   ),
//     //   child: new Column(
//     //     children: <Widget>[
//     //       Container(
//     //         padding: EdgeInsets.all(120.0),
//     //         child: Center(
//     //           child: Icon(
//     //             Icons.headset_mic,
//     //             color: Colors.redAccent,
//     //             size: 50.0,
//     //           ),
//     //         ),
//     //       ),
//     //       new Row(
//     //         children: <Widget>[
//     //           new Expanded(
//     //             child: new Padding(
//     //               padding: const EdgeInsets.only(left: 40.0),
//     //               child: new Text(
//     //                 "EMAIL",
//     //                 style: TextStyle(
//     //                   fontWeight: FontWeight.bold,
//     //                   color: Colors.redAccent,
//     //                   fontSize: 15.0,
//     //                 ),
//     //               ),
//     //             ),
//     //           ),
//     //         ],
//     //       ),
//     //       new Container(
//     //         width: MediaQuery.of(context).size.width,
//     //         margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
//     //         alignment: Alignment.center,
//     //         decoration: BoxDecoration(
//     //           border: Border(
//     //             bottom: BorderSide(
//     //                 color: Colors.redAccent,
//     //                 width: 0.5,
//     //                 style: BorderStyle.solid),
//     //           ),
//     //         ),
//     //         padding: const EdgeInsets.only(left: 0.0, right: 10.0),
//     //         child: new Row(
//     //           crossAxisAlignment: CrossAxisAlignment.center,
//     //           mainAxisAlignment: MainAxisAlignment.start,
//     //           children: <Widget>[
//     //             new Expanded(
//     //               child: TextField(
//     //                 obscureText: true,
//     //                 textAlign: TextAlign.left,
//     //                 decoration: InputDecoration(
//     //                   border: InputBorder.none,
//     //                   hintText: 'samarthagarwal@live.com',
//     //                   hintStyle: TextStyle(color: Colors.grey),
//     //                 ),
//     //               ),
//     //             ),
//     //           ],
//     //         ),
//     //       ),
//     //       Divider(
//     //         height: 24.0,
//     //       ),
//     //       new Row(
//     //         children: <Widget>[
//     //           new Expanded(
//     //             child: new Padding(
//     //               padding: const EdgeInsets.only(left: 40.0),
//     //               child: new Text(
//     //                 "PASSWORD",
//     //                 style: TextStyle(
//     //                   fontWeight: FontWeight.bold,
//     //                   color: Colors.redAccent,
//     //                   fontSize: 15.0,
//     //                 ),
//     //               ),
//     //             ),
//     //           ),
//     //         ],
//     //       ),
//     //       new Container(
//     //         width: MediaQuery.of(context).size.width,
//     //         margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
//     //         alignment: Alignment.center,
//     //         decoration: BoxDecoration(
//     //           border: Border(
//     //             bottom: BorderSide(
//     //                 color: Colors.redAccent,
//     //                 width: 0.5,
//     //                 style: BorderStyle.solid),
//     //           ),
//     //         ),
//     //         padding: const EdgeInsets.only(left: 0.0, right: 10.0),
//     //         child: new Row(
//     //           crossAxisAlignment: CrossAxisAlignment.center,
//     //           mainAxisAlignment: MainAxisAlignment.start,
//     //           children: <Widget>[
//     //             new Expanded(
//     //               child: TextField(
//     //                 obscureText: true,
//     //                 textAlign: TextAlign.left,
//     //                 decoration: InputDecoration(
//     //                   border: InputBorder.none,
//     //                   hintText: '*********',
//     //                   hintStyle: TextStyle(color: Colors.grey),
//     //                 ),
//     //               ),
//     //             ),
//     //           ],
//     //         ),
//     //       ),
//     //       Divider(
//     //         height: 24.0,
//     //       ),
//     //       new Row(
//     //         mainAxisAlignment: MainAxisAlignment.end,
//     //         children: <Widget>[
//     //           Padding(
//     //             padding: const EdgeInsets.only(right: 20.0),
//     //             child: new FlatButton(
//     //               child: new Text(
//     //                 "Forgot Password?",
//     //                 style: TextStyle(
//     //                   fontWeight: FontWeight.bold,
//     //                   color: Colors.redAccent,
//     //                   fontSize: 15.0,
//     //                 ),
//     //                 textAlign: TextAlign.end,
//     //               ),
//     //               onPressed: () => {},
//     //             ),
//     //           ),
//     //         ],
//     //       ),
//     //       new Container(
//     //         width: MediaQuery.of(context).size.width,
//     //         margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
//     //         alignment: Alignment.center,
//     //         child: new Row(
//     //           children: <Widget>[
//     //             new Expanded(
//     //               child: new FlatButton(
//     //                 shape: new RoundedRectangleBorder(
//     //                   borderRadius: new BorderRadius.circular(30.0),
//     //                 ),
//     //                 color: Colors.redAccent,
//     //                 onPressed: () => {},
//     //                 child: new Container(
//     //                   padding: const EdgeInsets.symmetric(
//     //                     vertical: 20.0,
//     //                     horizontal: 20.0,
//     //                   ),
//     //                   child: new Row(
//     //                     mainAxisAlignment: MainAxisAlignment.center,
//     //                     children: <Widget>[
//     //                       new Expanded(
//     //                         child: Text(
//     //                           "LOGIN",
//     //                           textAlign: TextAlign.center,
//     //                           style: TextStyle(
//     //                               color: Colors.white,
//     //                               fontWeight: FontWeight.bold),
//     //                         ),
//     //                       ),
//     //                     ],
//     //                   ),
//     //                 ),
//     //               ),
//     //             ),
//     //           ],
//     //         ),
//     //       ),
//     //       new Container(
//     //         width: MediaQuery.of(context).size.width,
//     //         margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
//     //         alignment: Alignment.center,
//     //         child: Row(
//     //           children: <Widget>[
//     //             new Expanded(
//     //               child: new Container(
//     //                 margin: EdgeInsets.all(8.0),
//     //                 decoration: BoxDecoration(border: Border.all(width: 0.25)),
//     //               ),
//     //             ),
//     //             Text(
//     //               "OR CONNECT WITH",
//     //               style: TextStyle(
//     //                 color: Colors.grey,
//     //                 fontWeight: FontWeight.bold,
//     //               ),
//     //             ),
//     //             new Expanded(
//     //               child: new Container(
//     //                 margin: EdgeInsets.all(8.0),
//     //                 decoration: BoxDecoration(border: Border.all(width: 0.25)),
//     //               ),
//     //             ),
//     //           ],
//     //         ),
//     //       ),
//     //       new Container(
//     //         width: MediaQuery.of(context).size.width,
//     //         margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
//     //         child: new Row(
//     //           children: <Widget>[
//     //             new Expanded(
//     //               child: new Container(
//     //                 margin: EdgeInsets.only(right: 8.0),
//     //                 alignment: Alignment.center,
//     //                 child: new Row(
//     //                   children: <Widget>[
//     //                     new Expanded(
//     //                       child: new FlatButton(
//     //                         shape: new RoundedRectangleBorder(
//     //                           borderRadius: new BorderRadius.circular(30.0),
//     //                         ),
//     //                         color: Color(0Xff3B5998),
//     //                         onPressed: () => {},
//     //                         child: new Container(
//     //                           child: new Row(
//     //                             mainAxisAlignment: MainAxisAlignment.center,
//     //                             children: <Widget>[
//     //                               new Expanded(
//     //                                 child: new FlatButton(
//     //                                   onPressed: ()=>{},
//     //                                   padding: EdgeInsets.only(
//     //                                     top: 20.0,
//     //                                     bottom: 20.0,
//     //                                   ),
//     //                                   child: new Row(
//     //                                     mainAxisAlignment:
//     //                                         MainAxisAlignment.spaceEvenly,
//     //                                     children: <Widget>[
//     //                                       Icon(
//     //                                         const IconData(0xea90,
//     //                                             fontFamily: 'icomoon'),
//     //                                         color: Colors.white,
//     //                                         size: 15.0,
//     //                                       ),
//     //                                       Text(
//     //                                         "FACEBOOK",
//     //                                         textAlign: TextAlign.center,
//     //                                         style: TextStyle(
//     //                                             color: Colors.white,
//     //                                             fontWeight: FontWeight.bold),
//     //                                       ),
//     //                                     ],
//     //                                   ),
//     //                                 ),
//     //                               ),
//     //                             ],
//     //                           ),
//     //                         ),
//     //                       ),
//     //                     ),
//     //                   ],
//     //                 ),
//     //               ),
//     //             ),
//     //             new Expanded(
//     //               child: new Container(
//     //                 margin: EdgeInsets.only(left: 8.0),
//     //                 alignment: Alignment.center,
//     //                 child: new Row(
//     //                   children: <Widget>[
//     //                     new Expanded(
//     //                       child: new FlatButton(
//     //                         shape: new RoundedRectangleBorder(
//     //                           borderRadius: new BorderRadius.circular(30.0),
//     //                         ),
//     //                         color: Color(0Xffdb3236),
//     //                         onPressed: () => {},
//     //                         child: new Container(
//     //                           child: new Row(
//     //                             mainAxisAlignment: MainAxisAlignment.center,
//     //                             children: <Widget>[
//     //                               new Expanded(
//     //                                 child: new FlatButton(
//     //                                   onPressed: ()=>{},
//     //                                   padding: EdgeInsets.only(
//     //                                     top: 20.0,
//     //                                     bottom: 20.0,
//     //                                   ),
//     //                                   child: new Row(
//     //                                     mainAxisAlignment:
//     //                                         MainAxisAlignment.spaceEvenly,
//     //                                     children: <Widget>[
//     //                                       Icon(
//     //                                         const IconData(0xea88,
//     //                                             fontFamily: 'icomoon'),
//     //                                         color: Colors.white,
//     //                                         size: 15.0,
//     //                                       ),
//     //                                       Text(
//     //                                         "GOOGLE",
//     //                                         textAlign: TextAlign.center,
//     //                                         style: TextStyle(
//     //                                             color: Colors.white,
//     //                                             fontWeight: FontWeight.bold),
//     //                                       ),
//     //                                     ],
//     //                                   ),
//     //                                 ),
//     //                               ),
//     //                             ],
//     //                           ),
//     //                         ),
//     //                       ),
//     //                     ),
//     //                   ],
//     //                 ),
//     //               ),
//     //             ),
//     //           ],
//     //         ),
//     //       )
//     //     ],
//     //   ),
//     // )
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
//                         "Login",
//                         style: TextStyle(color: Colors.white, fontSize: 40),
//                       )),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   FadeAnimation(
//                       1.3,
//                       Text(
//                         "Welcome Back",
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
//                               height: 10,
//                             ),
//                             FadeAnimation(
//                               1.4,
//                               Container(
//                                 decoration: BoxDecoration(
//                                     border: Border.all(color: Colors.grey[400]),
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(30),
//                                     boxShadow: [
//                                       BoxShadow(
//                                           color:
//                                               Color.fromRGBO(225, 95, 27, .5),
//                                           blurRadius: 10.0,
//                                           offset: Offset(0, 20))
//                                     ]),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     children: <Widget>[
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
                                          // validator: (input) => input.length < 6
                                          //     ? 'Must be at least 6 characters'
                                          //     : null,
                                          // onSaved: (input) => _password = input,
//                                           obscureText: true,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               height: 30.0,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: <Widget>[
//                                 FadeAnimation(
//                                   1.5,
//                                   FlatButton(
//                                       onPressed: () => Navigator.pushNamed(
//                                           context, SignupScreen.id),
//                                       color: Colors.transparent,
//                                       padding: EdgeInsets.all(10.0),
//                                       child: Text(
//                                         'Forgot Password?',
//                                         style: TextStyle(
//                                             color: Colors.red, fontSize: 15.0),
//                                       )),
//                                 ),

//                                 FadeAnimation(
//                                   1.5,
//                                   FlatButton(
//                                       onPressed: () => Navigator.pushNamed(
//                                           context, SignupScreen.id),
//                                       color: Colors.transparent,
//                                       padding: EdgeInsets.all(10.0),
//                                       child: Text(
//                                         'Go to Signup',
//                                         style: TextStyle(
//                                             color: Colors.black,
//                                             fontSize: 15.0),
//                                       )),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             FadeAnimation(
//                                 1.6,
//                                 InkWell(
//                                   child: Container(
//                                     height: 50,
//                                     margin:
//                                         EdgeInsets.symmetric(horizontal: 100),
//                                     decoration: BoxDecoration(
//                                         gradient: LinearGradient(colors: [
//                                           Colors.orangeAccent,
//                                           Colors.deepOrangeAccent
//                                         ]),
//                                         borderRadius:
//                                             BorderRadius.circular(20.0),
//                                         boxShadow: [
//                                           BoxShadow(
//                                               color: Color(0xFF6078ea)
//                                                   .withOpacity(.3),
//                                               offset: Offset(0.0, 8.0),
//                                               blurRadius: 8.0)
//                                         ]),
//                                     child: Material(
//                                       color: Colors.transparent,
//                                       child: InkWell(
//                                         onTap: _submit,
//                                         child: Center(
//                                           child: Text("LOGIN",
//                                               style: TextStyle(
//                                                   fontFamily: 'PoppinBold',
//                                                   color: Colors.white,
//                                                   fontSize: 18,
//                                                   letterSpacing: 1.0)),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 )
//                                 /*Container(
//                                   height: 50,
//                                   margin: EdgeInsets.symmetric(horizontal: 50),
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(50),
//                                       color: Colors.orange[900]),
//                                   child: Center(
//                                     child: FlatButton(
//                                         onPressed: _submit,
//                                         color: Colors.transparent,
//                                         padding: EdgeInsets.all(10.0),
//                                         child: Text(
//                                           'Login',
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: 18.0),
//                                         )),
//                                   ),
//                                 )*/
//                                 ),
//                             SizedBox(
//                               height: 20,
//                             ),
//                             FadeAnimation(
//                                 1.7,
//                                 Text(
//                                   "Or Continue with social media",
//                                   style: TextStyle(color: Colors.black),
//                                 )),
//                             SizedBox(
//                               height: 20,
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

// /* FadeAnimation(
//                               1.4,
//                               Container(
//                                 decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(10),
//                                     boxShadow: [
//                                       BoxShadow(
//                                           color:
//                                               Color.fromRGBO(225, 95, 27, .3),
//                                           spreadRadius: 10,
//                                           blurRadius: 20,
//                                           offset: Offset(0, 10))
//                                     ]),
//                                 child: Column(
//                                   children: <Widget>[
//                                     Container(
//                                       padding: EdgeInsets.all(10),
//                                       decoration: BoxDecoration(
//                                           border: Border(
//                                               bottom: BorderSide(
//                                                   color: Colors.grey[200]))),
//                                       child: TextFormField(
//                                         decoration:
//                                             InputDecoration(labelText: 'Email'),
//                                         validator: (input) =>
//                                             !input.contains('@')
//                                                 ? 'Please enter a valid email'
//                                                 : null,
//                                         onSaved: (input) => _email = input,
//                                       ),
//                                     ),
//                                     Container(
//                                       padding: EdgeInsets.all(10),
//                                       decoration: BoxDecoration(
//                                           border: Border(
//                                               bottom: BorderSide(
//                                                   color: Colors.grey[200]))),
//                                       child: TextFormField(
//                                         decoration: InputDecoration(
//                                             labelText: 'Password'),
//                                         validator: (input) => input.length < 6
//                                             ? 'Must be at least 6 characters'
//                                             : null,
//                                         onSaved: (input) => _password = input,
//                                         obscureText: true,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )),*/

// /*Scaffold(
//         body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             'Instagram',
//             style: TextStyle(fontSize: 50.0, fontFamily: 'Billabong'),
//           ),
//           Form(
//               key: _formkey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 30.0,
//                       vertical: 10.0,
//                     ),
//                     child: TextFormField(
//                       decoration: InputDecoration(labelText: 'Email'),
//                       validator: (input) => !input.contains('@')
//                           ? 'Please enter a valid email'
//                           : null,
//                       onSaved: (input) => _email = input,
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 30.0,
//                       vertical: 10.0,
//                     ),
//                     child: TextFormField(
//                       decoration: InputDecoration(labelText: 'Password'),
//                       validator: (input) => input.length < 6
//                           ? 'Must be at least 6 characters'
//                           : null,
//                       onSaved: (input) => _password = input,
//                       obscureText: true,
//                     ),
//                   ),
//                   SizedBox(
//                     height: 20.0,
//                   ),
//                   Container(
//                     width: 250.0,
//                     child: FlatButton(
//                         onPressed: _submit,
//                         color: Colors.blue,
//                         padding: EdgeInsets.all(10.0),
//                         child: Text(
//                           'Login',
//                           style: TextStyle(color: Colors.white, fontSize: 18.0),
//                         )),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Container(
//                     width: 250.0,
//                     child: FlatButton(
//                         onPressed: () =>
//                             Navigator.pushNamed(context, SignupScreen.id),
//                         color: Colors.blue,
//                         padding: EdgeInsets.all(10.0),
//                         child: Text(
//                           'Go to Signup',
//                           style: TextStyle(color: Colors.white, fontSize: 18.0),
//                         )),
//                   )
//                 ],
//               ))
//         ],
//       ),
//     ));*/
