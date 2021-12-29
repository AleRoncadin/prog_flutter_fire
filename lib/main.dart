import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:roncadin_app/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:roncadin_app/register_screen.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'Authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

Widget _buildTitle() {
    return Center(
      child: SizedBox(
        child: Column(
          children: const <Widget>[
            Text(
              "Login",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
              // textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseapp = await Firebase.initializeApp();
  return firebaseapp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const LoginScreen();
          }
          return const Center(
            child:  CircularProgressIndicator(),
          );
        }
      ),

    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Future<User?> loginUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context}) async {
    User? user;
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Login Failed"),
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
    return user;
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    User? user;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[_buildTitle()],
              ),
          const SizedBox(
            height: 30.0,
          ),
          SizedBox(
            child: Image.asset('assets/logo.png'),
          ),
          const SizedBox(
            height: 30.0,
          ),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
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
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Password",
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              )
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
          SizedBox(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: Colors.redAccent,
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () async {
                user = await loginUsingEmailPassword(email: _emailController.text, password: _passwordController.text, context: context);
                String? str = user?.email.toString();
                if(user != null)
                {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfileScreen(user: str,)));
                  print("Logged as $str");
                }
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: Colors.black,
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () async {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>       RegisterScreen()));
              },
              child: const Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: RawMaterialButton(
              fillColor: Colors.black,
              elevation: 0.0,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              onPressed: () async {
                User? user = await Authentication.signInWithGoogle(context: context);
                String? str = user?.email.toString();
                if (user != null) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfileScreen(user: str,)));
                  print("Logged as $str");
                }
              },
              child: const Text(
                "Sign in with Google",
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
    );
  }
}