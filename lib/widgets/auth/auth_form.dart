import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username,
      bool isLogin, BuildContext context) submitAuthForm;
  bool isLoading;

  AuthForm(this.submitAuthForm, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String email = '';
  String username = '';
  String password = '';

  _trySubmit() {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    if (!isValid) return;

    _formKey.currentState.save();

    widget.submitAuthForm(
      email.trim(),
      password.trim(),
      username.trim(),
      _isLogin,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email Address",
                    ),
                    validator: (value) {
                      return value.isEmpty || !value.contains("@")
                          ? "Please enter a valid email address"
                          : null;
                    },
                    onSaved: (value) => email = value,
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey('username'),
                      validator: (value) {
                        return value.isEmpty
                            ? "Please enter a valid username"
                            : null;
                      },
                      decoration: InputDecoration(
                        labelText: "Username",
                      ),
                      onSaved: (value) => username = value,
                    ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      return value.isEmpty || value.length < 7
                          ? "Password must be at least 7 characters long"
                          : null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    onSaved: (value) => password = value,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogin ? 'Login' : 'Sign Up'),
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () => setState(() {
                              _isLogin = !_isLogin;
                            }),
                        child: Text(_isLogin
                            ? "Create new account"
                            : "I already have an account"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
