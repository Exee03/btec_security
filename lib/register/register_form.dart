import 'package:btec_security/auth/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:btec_security/register/register.dart';

class RegisterForm extends StatefulWidget {
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: new ThemeData(
        hintColor: Colors.white30,
        cursorColor: Theme.of(context).primaryColor,
        primaryColor: Theme.of(context).primaryColor,
      ),
      child: BlocListener(
        bloc: _registerBloc,
        listener: (BuildContext context, RegisterState state) {
          if (state.isSubmitting) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Registering...',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor),
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              );
          }
          if (state.isSuccess) {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
            Navigator.of(context).pop();
          }
          if (state.isFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Registration Failure',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black),
                      ),
                      Icon(Icons.error),
                    ],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        child: BlocBuilder(
          bloc: _registerBloc,
          builder: (BuildContext context, RegisterState state) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 30),
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      decoration: InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'Email',
                      ),
                      autocorrect: false,
                      autovalidate: true,
                      validator: (_) {
                        return !state.isEmailValid ? 'Invalid Email' : null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock),
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      autocorrect: false,
                      autovalidate: true,
                      validator: (_) {
                        return !state.isPasswordValid
                            ? 'Invalid Password'
                            : null;
                      },
                    ),
                    SizedBox(height: 30),
                    RegisterButton(
                      onPressed: isRegisterButtonEnabled(state)
                          ? _onFormSubmitted
                          : null,
                    ),
                  ],
                ),
              ),
            );
          },
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

  void _onEmailChanged() {
    _registerBloc.add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.add(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
