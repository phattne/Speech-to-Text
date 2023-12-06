import 'package:flutter/material.dart';
import 'package:tetsapp/screens/homepage.dart';
import 'package:tetsapp/screens/voskdemo.dart';

class BackGround extends StatelessWidget {
  const BackGround({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.purple,
      body: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/image/chat.png'))),
                ),
              ),
              Text(
                'Welcom',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    fontSize: 45,
                    color: Colors.white),
              ),
              Text(
                'Translate',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white),
              ),
              Text(
                'Welcome to our translation app',
                style: TextStyle(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: Colors.black),
              ),
              SizedBox(
                height: 100,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.amber,
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontStyle: FontStyle.normal)),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const VoskFlutterDemo())),
                child: Text('Get Started'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
