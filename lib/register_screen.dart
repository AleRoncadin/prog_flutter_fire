import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:googleapis/cloudsearch/v1.dart';
import 'package:roncadin_app/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:roncadin_app/main.dart';

String email = '';
String password = '';
String confirmPassword = '';
final _auth = FirebaseAuth.instance;

Widget _buildTitle() {
    return Center(
      child: Container(
        child: Column(
          children: const <Widget>[
            Text(
              "Registration",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

class RegisterScreen extends StatefulWidget {
  //const RegisterScreen({ Key? key}): super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmpasswordController = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: _buildTitle(), backgroundColor: Colors.black,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Container(
            child: Image.asset('assets/logo.png'),
          ),
          const SizedBox(
              height: 30.0,
            ),
            TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => email = value.toString().trim(),
            decoration: const InputDecoration(
              hintText: "Email",
              prefixIcon: Icon(
                Icons.mail,
                color: Colors.black,
              )
            ),
          ),
          const SizedBox(
            height: 44.0,
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            validator: (value) {
              if(value!.isEmpty) {
                return "Please enter Password";
              }
            },
            onChanged: (value) => password = value,
            decoration: const InputDecoration(
              hintText: "Password",
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              )
            ),
          ),
          const SizedBox(
            height: 44.0,
          ),
          TextFormField(
            controller: _confirmpasswordController,
            obscureText: true,
            onChanged: (value) => confirmPassword = value,
            validator: (value) {
              if(value!.isEmpty) {
                return "Please enter Password";
              }
            },       
            decoration: const InputDecoration(
              hintText: "Confirm Password",
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              )
            ),
          ),
          const SizedBox(
            height: 44.0,
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: Colors.redAccent,
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () async {
                if (password == confirmPassword)
                {
                  try {
                    await _auth.createUserWithEmailAndPassword(email: email, password: password);
                    showDialog(
                      context: context,
                      builder: (context) {
                        Future.delayed(const Duration(seconds: 3), () {
                          Navigator.of(context).pop(true);
                        });
                        return const AlertDialog(
                          title: Text('Successfully Register. You Can Login Now'),
                        );
                      });
                  } on FirebaseAuthException catch (e) {
                      showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Registration Failed"),
                        content: Text('${e.message}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('Okay'),
                          )
                        ],
                      ),
                    );
                    }
                }
                else {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Registration Failed"),
                        content: const Text("Passwords must match"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('Okay'),
                          )
                        ],
                      ),
                    );
                }

              },
              child: const Text(
                "Register",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: Colors.black,
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () async {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: const Text(
                "Go back to Home Page",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ],
          ),
        ),
    );
  }
}