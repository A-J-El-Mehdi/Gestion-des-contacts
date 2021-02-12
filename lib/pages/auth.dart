import 'package:contactmanagement/model/user.dart';
import 'package:contactmanagement/scoped_model/my_scoped_model.dart';
import 'package:contactmanagement/pages/contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  GlobalKey<FormState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Form(

          key: _key,
          child: ListView(
            children: <Widget>[
              Container(
                height: 300.0,
                child: Image.asset('images/logo.png'),
              ),
              SizedBox(
                height: 10,
              ),
              _emailInputWididget(),
              SizedBox(
                height: 8.0,
              ),
              _passwordInputWididget(),
              SizedBox(
                height: 10,
              ),
              _logInWidget(),
              _signUpWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailInputWididget() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: 'Enter your mail',
        contentPadding:
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: Color(0xFFC7EDE6), width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: Color(0xFFC7EDE6), width: 3.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is required!';
        }
      },
    ); // TextFormField
  }

  Widget _passwordInputWididget() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        hintText: 'Enter your password',
        contentPadding:
        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: Color(0xFFC7EDE6), width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
          BorderSide(color: Color(0xFFC7EDE6), width: 3.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required!';
        }
      },
    ); // TextFormField
  }

  Widget _signUpWidget() {
    return ScopedModelDescendant<MyScopedModel>(
      builder: (BuildContext context, Widget child, MyScopedModel model) {
        return model.isloading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  FlatButton(
                    child: Text('Signing Up'),
                    onPressed: () {},
                  ),
                ],
              )
            : Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Material(
            color: Color(0xFFC7EDE6),
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            elevation: 5.0,
            child: MaterialButton(
              onPressed: () {
                register(model);
              },
              minWidth: 200.0,
              height: 42.0,
              child: Text(
                'Sign Up',
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _logInWidget() {
    return ScopedModelDescendant<MyScopedModel>(
      builder: (BuildContext context, Widget child, MyScopedModel model) {
        return model.loginInProgress
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            FlatButton(
              child: Text('Signing In'),
              onPressed: () {},
            ),
          ],
        )
            : Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Material(
            color: Color(0xFFC7EDE6),
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            elevation: 5.0,
            child: MaterialButton(
              onPressed: () {
                logIn(model);
              },
              minWidth: 200.0,
              height: 42.0,
              child: Text(
                'Log In',
              ),
            ),
          ),
        );
      },
    );
  }

  void register(MyScopedModel model) {
    if (_key.currentState.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      UserModel user = UserModel();
      user.email = email;
      user.password = password;
      model.registerUser(user).then((Map<String, dynamic> response) {
        if (response['success']) {
          // redirect to home_screen
          _customDialog('Sign Up Successful', 'Welcome');
        } else {
          _customDialog('Sign In Failed', response['message']);
        }
      });
    }
  }

  void logIn(MyScopedModel model) {
    if (_key.currentState.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      UserModel user = UserModel();
      user.email = email;
      user.password = password;
      model.logInUser(user).then((Map<String, dynamic> response) {
        if (response['success']) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) {
              return Contacts();
            }),
          );
          // redirect to home_screen
//          _customDialog('Sign In Successful', 'Welcome');
        } else {
          _customDialog('Sign In Failed', response['message']);
        }
      });
    }
  }
  _customDialog(String title, String message){
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close"))
          ],
        ));
  }
}
