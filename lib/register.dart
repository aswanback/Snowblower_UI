import 'package:flutter/material.dart';
import 'package:ui_463/helpers/helpers.dart';
import 'package:ui_463/tabs.dart';
import 'auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Cred cred = Cred.empty();
  bool error = false;
  bool passwordError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        titleTextStyle: Theme.of(context).textTheme.displaySmall,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        toolbarHeight: 50,
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          color: Theme.of(context).colorScheme.secondary,
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo_white.png',
                      width: 300,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CustomTextField(
                      color: Theme.of(context).colorScheme.onSecondary,
                      label: 'Username',
                      onChanged: (text) {
                        setState(() {
                          error = false;
                          cred.username = text;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      color: Theme.of(context).colorScheme.onSecondary,
                      obscure: true,
                      label: 'Password',
                      onChanged: (text) {
                        setState(() {
                          cred.password = text;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      color: Theme.of(context).colorScheme.onSecondary,
                      obscure: true,
                      label: 'Confirm Password',
                      onChanged: (text) {
                        setState(() {
                          if (cred.password != text) {
                            passwordError = true;
                          } else {
                            passwordError = false;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      color: Theme.of(context).colorScheme.onSecondary,
                      label: 'Robot ID',
                      onChanged: (text) {
                        setState(() {
                          error = false;
                          cred.robotId = text;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    error
                        ? Text(
                            'This account already exists.',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          )
                        : passwordError
                            ? Text('Passwords do not match.',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error))
                            : const Text(''),
                    const SizedBox(height: 15),
                    CustomTextButton(
                      text: 'Create Account',
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      textColor: Theme.of(context).colorScheme.onSurface,
                      onPressed: () {
                        if (!passwordError) {
                          if (credCheck.register(cred)) {
                            Navigator.push(
                              // TODO: pushReplacement
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Tabs()),
                            );
                          } else {
                            setState(() {
                              error = true;
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
