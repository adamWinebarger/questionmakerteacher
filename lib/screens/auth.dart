import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:password_field_validator/password_field_validator.dart';
import 'package:sf_symbols/sf_symbols.dart';


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
                  top: 30,
                  left: 20,
                  right: 20,
                  bottom: 20
                ),
                width: 200,
                child: SfSymbol(
                  name: 'questionmark.bubble.fill',
                  color: Theme.of(context).colorScheme.primary,
                  size: 200,
                  weight: FontWeight.w200
                ),
              ),
              const SizedBox(height: 15,),
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
                            padding: EdgeInsets.only(bottom: 10),
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
                                if (!_isLogin && _passwordFieldSelected)
                                  const SizedBox(height: 10,),
                                if (!_isLogin && _passwordFieldSelected)
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
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
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