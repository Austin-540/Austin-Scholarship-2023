import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'globals.dart';
import 'main.dart';
import 'package:restart_app/restart_app.dart';
import 'home_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Login - $version")),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  onSaved: (value) {
                    _email = value!.toLowerCase(); //pb doesn't automatically allow caps emails
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                SizedBox(height: 20),

                Semantics(
                  label: "Login Button",
                  child: ElevatedButton(
                    
                    onPressed: () {
                      _formKey.currentState!.save();
                      if (_email != "" && _password != "") {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConfirmLoginPage(
                                    email: _email, password: _password)));
                      }
                    },
                    child: Text('Login'),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class ConfirmLoginPage extends StatelessWidget { //checks email and password are correct before moving to home page
  const ConfirmLoginPage(
      {super.key, required this.email, required this.password});
  final String email;
  final String password;

  Future logIn(email, password) async {
    try {

      final authData = await pb.collection('users').authWithPassword(
            email,
            password,
          ); //if wrong password, try block will fail, and snapshot.data will be "Fail"

      final storage = new FlutterSecureStorage();
      await storage.write(key: "email", value: email); //only writes to FSS if correct password
      await storage.write(key: "password", value: password);
      return authData;
    } catch (e) {
      return "Fail";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: logIn(email, password),
      initialData: null,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data != "Fail") {
          return MyHomePage(title: "Home");
          } else {
            return FailedLoginPage();
          }
        } else {
          return Scaffold(
            appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text("Loading"), automaticallyImplyLeading: false,),
            body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }
}



class FailedLoginPage extends StatelessWidget { //if your email/password is wrong, or PB crashed
  const FailedLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, automaticallyImplyLeading: false, leading: null,
    ),
    body: Center(
      child: Column(children: [
        SizedBox(height: 10,),
        Text("Something went wrong"),
        Text("Make sure your email and password are correct."),
        SizedBox(height: 20,),
        ElevatedButton(onPressed: () {Navigator.pop(context);}, child: Text("Try Again"))
      ]),
    ),
    
    );
  }
}