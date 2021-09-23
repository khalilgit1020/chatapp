import 'dart:io';

import 'package:chat_app/pickers/user_image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';

class AuthForm extends StatefulWidget {

  final Function(String email, String password, String username,File image,
      bool isLogin, BuildContext ctx) submitFn;
  final bool isLoading;

  AuthForm(this.submitFn,this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _passWord = '';
  String _email = '';
  String _userName = '';
  File _userImageFile;

  void _submit() {
    final _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if(!_isLogin && _userImageFile == null){
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('please pick an image'),
        backgroundColor: Theme.of(context).errorColor,
      ));

      return;
    }

    if (_isValid) {
      _formKey.currentState.save();
     widget.submitFn(_email.trim(),_passWord.trim(),_userName.trim(),_userImageFile,_isLogin,context);
    }
  }

  void _pickImage(File pickedImage){
    _userImageFile = pickedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Welcome to Room chat',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.all(20),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(!_isLogin) UserImagePicker(_pickImage),
                      TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        textCapitalization: TextCapitalization.none,
                        key: ValueKey('email'),
                        validator: (val) {
                          if (val.isEmpty || !val.contains('@')) {
                            return 'please enter a valid email address';
                          }
                          return null;
                        },
                        onSaved: (val) => _email = val,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'email address'),
                      ),
                      if (!_isLogin)
                        TextFormField(
                          autocorrect: true,
                          enableSuggestions: true,
                          textCapitalization: TextCapitalization.words,
                          key: ValueKey('userName'),
                          validator: (val) {
                            if (val.isEmpty || val.length < 4) {
                              return 'please enter at least 4 characters';
                            }
                            return null;
                          },
                          onSaved: (val) => _userName = val,
                          decoration: InputDecoration(labelText: 'User Name'),
                        ),
                      TextFormField(
                        key: ValueKey('password'),
                        validator: (val) {
                          if (val.isEmpty || val.length < 7) {
                            return 'please enter at least 7 characters';
                          }
                          return null;
                        },
                        onSaved: (val) => _passWord = val,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      if(widget.isLoading)
                        CircularProgressIndicator(),
                      if(!widget.isLoading)
                      RaisedButton(
                        child: Text(_isLogin ? 'Login' : 'Sign Up'),
                        onPressed: _submit,
                      ),
                      if(!widget.isLoading)
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: (){
                         setState(() {
                           _isLogin = !_isLogin;
                         });
                        },
                        child: Text(_isLogin?
                        'Create new account':
                        'I already have an account'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
