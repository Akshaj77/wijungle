import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wijungle/login_bloc/bloc/login_bloc.dart';
import 'package:wijungle/login_bloc/bloc/service_bloc.dart';
import 'package:wijungle/screens/usageScreen.dart';
// Import your LoginBloc

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginLoaded) {
            // Navigate to the new page
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BlocProvider(
                        create: (context) => ServiceBloc()..add(RunServiceEvent()),
                        child: UsageScreen(),
                      )), // Replace with your new page
            );
          } else if (state is LoginError) {
            // Show error message
            print(state.error);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          color: Color.fromRGBO(246, 246, 255, 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Image.network(
                      'https://s3-alpha-sig.figma.com/img/2281/9a03/81a73d06f156efd12ab496a41efb0ac6?Expires=1725840000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=flyPib57ZL3p6zQlTzsqwB248dpDu~98zYvZA3mnnvE7aC7wEE-OtikcyV0LL6aa0-gGgaKtxxuZz9uPnSeZRSdqa42~JMU9V1-IjYD7iucDEsisZM5-7mJGm00eKqAAFEK5VyTiVKUd1ulbxnybpiExllyMibSJepQV0bZRcgfL9EX1u93BCHo40vrPPw~Xc8PIKibi6kLctqr38-L81azwDYZh6c2ssuzsfAM6DlxoIeGFWTqLJrIL3aug7xTiWITaBMEoVDO3sy4Hd8pBu4eisxbgypLtzzmHMEMy5epVxambKvWIzIe7FimpJHUdntfRNSBGwc1SF0tr3KjCGg__',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Image.asset('images/image2.png'),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.grey,
                      margin: EdgeInsets.all(16),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Let's Secure your PC",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .1),
                             InputTextBox(passwordController: _usernameController, labelText: "username"),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .05),
                              InputTextBox(passwordController: _passwordController,labelText: "password",),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .05),
                              Row(
                                children: [
                                  Checkbox(
                                      value: true, onChanged: (bool? val) {}),
                                  Text(
                                    "By continuing, you agree to",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: 15.0,
                                        ),
                                  ),
                                  TextButton(
                                    child: Text(
                                      "Terms & Conditions",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: Colors.blue,
                                            fontSize: 15.0,
                                          ),
                                    ),
                                    onPressed: () {},
                                  ),
                                  Text(
                                    "and",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontSize: 15.0,
                                        ),
                                  ),
                                  TextButton(
                                    child: Text(
                                      "Privacy Policy",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontSize: 15.0,
                                            color: Colors.blue,
                                          ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .05),
                              SizedBox(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Log In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // Trigger the login event
                                      context.read<LoginBloc>().add(
                                            OnLoginEvent(
                                              userName:
                                                  _usernameController.text,
                                              password:
                                                  _passwordController.text,
                                            ),
                                          );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputTextBox extends StatelessWidget {
  const InputTextBox({
    super.key,
    required TextEditingController passwordController,
    required this.labelText,
  }) : _passwordController = passwordController;

  final TextEditingController _passwordController;
  final String labelText ;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      decoration:  InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        border:const  OutlineInputBorder(
          borderSide: BorderSide(
                    color: Colors.grey, // Color of the outline
                    width: 2.0, // Width of the outline
                  ),
        ),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }
}

