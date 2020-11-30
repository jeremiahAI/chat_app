import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(String email, String password, String username,
      File pickedImage, bool isLogin, BuildContext context) submitAuthForm;
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

  File _pickedImage;

  _trySubmit() {
    final isValid = _formKey.currentState.validate();

    FocusScope.of(context).unfocus();

    if (_pickedImage == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Please select an image."),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (!isValid) return;

    _formKey.currentState.save();

    widget.submitAuthForm(
      email.trim(),
      password.trim(),
      username.trim(),
      _pickedImage,
      _isLogin,
      context,
    );
  }

  _pickImage(File imageFile) => _pickedImage = imageFile;

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
                  if (!_isLogin) UserImagePicker(_pickImage),
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

class UserImagePicker extends StatefulWidget {
  final Function(File imageFile) submitPickedImage;

  UserImagePicker(this.submitPickedImage);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;

  _pickImage() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    setState(() {
      _pickedImage = imageFile;
    });
    widget.submitPickedImage(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
          icon: Icon(Icons.image),
          onPressed: _pickImage,
          label: Text("Add Image"),
          textColor: Theme.of(context).primaryColor,
        )
      ],
    );
  }
}
