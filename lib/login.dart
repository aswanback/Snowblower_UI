// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:ui_463/helpers/helpers.dart';
import 'package:ui_463/register.dart';
import 'package:ui_463/auth.dart';
import 'tabs.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  thc(context) => {Theme.of(context).colorScheme};
  Cred cred = Cred.empty();
  bool error = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            color: Theme.of(context).colorScheme.background,
            child: Center(
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                      ),
                      Image.asset('assets/logo_white.png'),
                      SizedBox(
                        height: 50,
                      ),
                      CustomTextField(
                        color: Theme.of(context).colorScheme.onBackground,
                        label: 'Username',
                        onChanged: (text) {
                          setState(() {
                            cred.username = text;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        color: Theme.of(context).colorScheme.onBackground,
                        obscure: true,
                        label: 'Password',
                        onChanged: (text) {
                          setState(() {
                            cred.password = text;
                            error = false;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      error
                          ? Text(
                              'Incorrect username or password',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            )
                          : Text(''),
                      const SizedBox(height: 15),
                      CustomTextButton(
                        text: 'Login',
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        textColor: Theme.of(context).colorScheme.onPrimary,
                        onPressed: () {
                          if (credCheck.login(cred)) {
                            Navigator.push(
                              // TODO: pushReplacement
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Tabs()),
                            );
                          } else {
                            error = true;
                            setState(() {}); // force refresh
                          }
                        },
                      ),
                      CustomTextButton(
                        text: 'Register',
                        height: 20,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        textColor: Theme.of(context).colorScheme.onBackground,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Register()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
