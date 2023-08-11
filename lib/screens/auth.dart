import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:password_field_validator/password_field_validator.dart';
import 'package:sf_symbols/sf_symbols.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();

  var _isLogin = false, _passwordFieldSelected = false, _isAuthenticating = false;
  var _enteredEmail = '', _enteredPassword = '', _enteredLastName = '',
    _enteredFirstName = '';
  var _sfSymbolSize = 75.0;

  void _submit() {
    setState(() {
      _isAuthenticating = true;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 0,
                  left: 20,
                  right: 20,
                  bottom: 0
                ),
                width: _sfSymbolSize,
                child: SfSymbol(
                  name: 'questionmark.bubble.fill',
                  color: Theme.of(context).colorScheme.primary,
                  size: _sfSymbolSize,
                  weight: FontWeight.w200
                ),
              ),
              //const SizedBox(height: 15),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //Last name
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(labelText: "First Name:"),
                              validator: (value) {
                                if (value == null || value.trim().length < 4) {
                                  return "Invalid last name detected.";
                                }
                                return null;
                              },
                            ),
                          //First Name
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(labelText: "Last Name:"),
                              validator: (value) {
                                if (value == null || value.trim().length < 4) {
                                  return "Invalid last name detected.";
                                }
                                return null;
                              },
                            ),
                          //This will be for the email input
                          TextFormField(
                            decoration: const InputDecoration(labelText: "Email"),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty || !EmailValidator.validate(value)) {
                                return 'Invalid email input';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                              onTap: () {
                                setState(() {
                                  _passwordFieldSelected = false;
                                });
                              }
                          ),
                          //This one will be for the password
                          Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Column(
                              children: [
                                //if (_isLogin)
                                TextFormField(
                                  decoration: const InputDecoration(labelText: "Password"),
                                  autocorrect: false,
                                  obscureText: true,
                                  validator: (value) {
                                    return (value != null && value.trim().isNotEmpty) ?
                                    null : "Password field cannot be empty";
                                  },
                                  onSaved: (value) {
                                    _enteredPassword = value!;
                                  },
                                  controller: _passwordController,
                                  onTap: () {
                                    setState(() {
                                      _passwordFieldSelected = true;
                                    });
                                  },
                                  onEditingComplete: () {
                                    _passwordFieldSelected = false;
                                  },
                                ),
                                if (!_isLogin)
                                  const SizedBox(height: 10,),
                                if (!_isLogin)
                                  PasswordFieldValidator(
                                    minLength: 8,
                                    uppercaseCharCount: 2,
                                    lowercaseCharCount: 2,
                                    numericCharCount: 2,
                                    specialCharCount: 2,
                                    defaultColor: Theme.of(context).colorScheme.primary,
                                    successColor: Colors.lightGreen,
                                    failureColor: Colors.red,
                                    controller: _passwordController,
                                  )
                              ],
                            ),
                          ),
                          // if (_isAuthenticating)
                          //   Container(
                          //     padding: const EdgeInsets.only(top: 10),
                          //     child: const CircularProgressIndicator()
                          //   )
                          // else
                          //Buttons
                          SizedBox(height: 15,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              //textStyle: TextStyle(color: Theme.of(context).primaryColor),
                            ),
                            onPressed: _submit,
                            child: !_isAuthenticating ?
                              Text(
                              _isLogin ? "Login" : "Sign Up",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primaryContainer,
                              ),
                            ) : SizedBox(
                              height: 12,
                              width: 12,
                              child: CircularProgressIndicator(
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              ),
                            )
                          ),
                          const SizedBox(height: 5,),
                          SignInButton(
                            Buttons.GoogleDark,
                            onPressed: () {}
                          ),
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                  _sfSymbolSize = _isLogin ? 200 : 75;
                                });
                              },
                              child: Text( _isLogin ? "Create an account" : "I already have an account")
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        )
      ),
    );
  }

}