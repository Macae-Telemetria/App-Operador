import 'package:flutter/material.dart';
import 'package:flutter_sit_operation_application/src/bluetooth/screens/home-screen.dart';
import 'package:flutter_sit_operation_application/src/contexts/global.dart';
import 'package:flutter_sit_operation_application/src/widgets/loading-dialog.dart';
import 'package:provider/provider.dart';

import 'login_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key, required this.controller});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();


  Future<void> _submitForm(BuildContext context, GlobalContext globalContext) async {
    print("submitting...");

    showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return const LoadingDialog(
        title: "Enviando...",
      );
    });
          
    String email = _emailController.text;
    String senha = _senhaController.text;
    print("email ${  email }, senha ${  senha }");
    bool result = await globalContext.signInUser(email, senha);
    print("resultado ${result}");
    Navigator.of(context).pop();

    if(result == true) {
      Navigator.pushReplacementNamed(context, BTHomeScreen.routeName);
      return;
    }
    _showAlertDialog(context);

  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Acesso Negado'),
          content: Text('Certifique-se de ter autorização para isso.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static const routeName = '/login';

  final LoginController controller;

  @override
  Widget build(BuildContext context) {

    final globalContext = Provider.of<GlobalContext>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Image(image: AssetImage("assets/images/logo.png")),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            TextField(
              controller: _senhaController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: 'Senha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                _submitForm(context, globalContext);
              },
              child: Text(
                'ENTRAR',
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 82.0, vertical: 16.0),
              ),
            ),
            const SizedBox(height: 32.0),
            Text(
              "Desenvolvido por:\n Eduarda Sodré, Gabriel Bertusi e Lucas Fonseca ",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
