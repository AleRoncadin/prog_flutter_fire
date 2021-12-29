import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roncadin_app/Authentication.dart';
import 'package:roncadin_app/main.dart';


import 'myNewText.dart';


//User? user = FirebaseAuth.instance.currentUser;
//var us = user!.email!;

Widget _buildTitle() {
    return Center(
      child: Container(
        child: Column(
          children: const <Widget>[
            Text(
              "HOME",
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

class ProfileScreen extends StatefulWidget {
  final user;
  const ProfileScreen({ Key? key, this.user}): super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var _str_count = 0;
  final _str = [
  "Hello",
  "Ciao",
  "Bonjour",
  "Hallo",
  "你好世界",
  "Привет мир",
  "مرحبا بالعالم",
  "שלום עולם",
  "Hola",
  "Qo' VIvan",
  ];

  var _color_count=0;
  final _colors = [Colors.amber, 
  Colors.blue, 
  Colors.brown, 
  Colors.deepOrange,
  Colors.deepPurple,
  Colors.green,
  Colors.yellow,
  Colors.grey
  ];

  void _changeStr() {
    setState(() {
      if(_str_count > 0)
        _str_count--;
      else
        _str_count = _str.length-1;

      if(_color_count > 0)
        _color_count--;
      else
        _color_count = _colors.length-1;
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = widget.user.toString();
    return Scaffold(
      appBar: AppBar(title: _buildTitle(), backgroundColor: Colors.black,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50.0,
            ),
            Container(
                child: Text('Logged as $user'),
            ),       
          const SizedBox(
              height: 400.0,
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
                await Authentication.signOut(context: context);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: const Text(
                "Logout",
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