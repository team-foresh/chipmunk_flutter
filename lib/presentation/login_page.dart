import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:chipmunk_flutter/data/auth_service.dart';
import 'package:chipmunk_flutter/init.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signUp() {
    final AuthService authService = serviceLocator<AuthService>();
    authService.signUpWithEmail(
      email: "melow2@naver.com",
      password: "12345678",
    );
  }

  void _signIn() {
    final AuthService authService = serviceLocator<AuthService>();
    authService.signInWithEmail(
      email: "melow2@naver.com",
      password: "12345678",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Supanotes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: ChipmunkTextStyle.body1SemiBold(),
                decoration: InputDecoration(hintText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                style: ChipmunkTextStyle.body1SemiBold(),
                decoration: InputDecoration(hintText: 'Password'),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _signIn,
              icon: Icon(Icons.login),
              label: Text('Sign in'),
            ),
            ElevatedButton.icon(
              onPressed: _signUp,
              icon: Icon(Icons.app_registration),
              label: Text('Sign up'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
