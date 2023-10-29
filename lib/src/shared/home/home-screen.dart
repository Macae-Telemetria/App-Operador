import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  final String title = "SIT operador";

  static const routeName = '/';

  const MyHomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('SIT OPERADOR'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  /* CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        NetworkImage('https://example.com/user_avatar.jpg'),
                  ), */
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      Text(
                        'john.doe@example.com',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      // Handle settings button press
                    },
                    icon: Icon(Icons.settings, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: double.infinity),
              child: ElevatedButton(
                  child: const Text(
                    'BlueTooth',
                    style: TextStyle(fontSize: 24.0), // Text style
                  ),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        horizontal: 0, vertical: 32), // Button padding
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(2), // Button border radius
                    ),
                  )),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
