import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'globals.dart';
import 'home_page.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text("Login - $version")),
      body: Column(
        children: [
          Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  children: [
                    TextFormField(
                      autofillHints: const [AutofillHints.username],
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      onSaved: (value) {
                        _email = value!
                            .toLowerCase(); //pb doesn't automatically allow caps emails
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      autofillHints: const [AutofillHints.password],
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                    const SizedBox(height: 20),
                    Semantics(
                      label: "Login Button",
                      child: ElevatedButton(
                        onPressed: () async {
                          _formKey.currentState!.save();
                          if (_email != "" && _password != "") {
                            setState(() {
                          loading = true;
                          });
                            const storage = FlutterSecureStorage();
              storage.write(key: "theme", value: "light");
          
              
              try {
          final authData = await pb.collection('users').authWithPassword(
                _email,
                _password,
              ); //if wrong password, try block will fail, and snapshot.data will be "Fail"
          
          const storage = FlutterSecureStorage();
          // await storage.write(
          //     key: "email", value: email); //only writes to FSS if correct password
          // await storage.write(key: "password", value: password);
          await storage.write(
              key: "username", value: authData.record!.data['username']);
          
          final encoded = jsonEncode(<String, dynamic>{
            "token": pb.authStore.token,
            "model": pb.authStore.model,
          });
          await storage.write(key: "pb_auth", value: encoded);
          if (!context.mounted) return;
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MyHomePage(title: "Today's Lessons")), (route) => false);
              } on ClientException catch (e) {
          if (!context.mounted) return;
          showDialog(
            barrierDismissible: false,
            context: context, builder: (context) => AlertDialog(
            
            title: const Text("Login Failed"), 
            content: Text("Error Code: ${e.statusCode}\nDetails: ${e.response['message']=="Failed to authenticate."?"Incorrect username or password":e.response['message']}"),
            actions: [TextButton(onPressed: () {
              setState(() {
                loading = false;
              });
              Navigator.pop(context);}, child: const Text("Try Again"))],
          ));
              } catch (e) {
          if (!context.mounted) return;
          showDialog(context: context, builder: (context)=> AlertDialog(
            title: const Text("Something went wrong :/"),
            content: Text(e.toString()),
            actions: [TextButton(onPressed: () =>Navigator.pop(context), child: const Text("Try Again"))]
          ));
              }
                          }
                        },
                        child: loading? const Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        ):const Text('Login'),
                      ),
                      
                    ),
                    
                    
                  ],
                ),
              )),
              const Spacer(),
                const HaikeiLayeredWaves()
        ],
      ),
          
    );
  }
}

class HaikeiLayeredWaves extends StatelessWidget {
  const HaikeiLayeredWaves({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
                  child: SvgPicture.asset(
                    "assets/layered-waves-haikei-cropped.svg",
                    height: MediaQuery.of(context).size.height/3,
                    width: MediaQuery.of(context).size.width+5,
                  fit: BoxFit.fill,)
    );
  }
}