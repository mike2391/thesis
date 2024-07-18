import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:pesona2/screens/main_screen.dart';
import '../repository/repository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isLoginFailed = false;
  late String _email;
  late String _password;

  void login() async {
    setState(() {
      _isLoading = true;
      _isLoginFailed = false;
    });

    final userLogin = await AuthService().loginUser(emailController.text, passwordController.text);

    setState(() {
      _isLoading = false;
    });

    if (userLogin != null) {
      print("User logged in successfully.");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else {
      print("Login failed");
      setState(() {
        _isLoginFailed = true;
      });
      formKey.currentState?.validate();
    }
  }

  @override
  void dispose() {
    // Bersihkan controller untuk menghindari memory leak
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [
                0.45,
                1,
              ],
              colors: [
                Color(0xff315EFF),
                Color(0xff042254),
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        child: Image.asset(
                          color: const Color(0xff163E96),
                          "assets/logo_login.png",
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(labelText: 'Email'),
                              validator: (val) {
                                if (!EmailValidator.validate(val!, true)) {
                                  return 'Not a valid email.';
                                }
                                if (_isLoginFailed) {
                                  return 'Incorrect email or password.';
                                }
                                return null;
                              },
                              onSaved: (val) => _email = val!,
                            ),
                            TextFormField(
                              controller: passwordController,
                              decoration: const InputDecoration(labelText: 'Password'),
                              validator: (val) {
                                if (val!.length < 8) {
                                  return 'Password too short.';
                                }
                                if (_isLoginFailed) {
                                  return 'Incorrect email or password.';
                                }
                                return null;
                              },
                              obscureText: true,
                              onSaved: (val) => _password = val!,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                        child: _isLoading ?
                        const Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text('Validasi ke server'),
                          ],
                        ) // Menampilkan animasi loading saat _isLoading bernilai true
                            : FilledButton(
                          onPressed: () {
                              login();
                          },
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(Color(0xff3D67FF)),
                          ),
                          child: const Text('Sign In'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
