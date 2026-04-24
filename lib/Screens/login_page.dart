import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'forgotpassword_page.dart';
import 'sign_up.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _isObscured = true;
  String? errorMessage;
  

  Future<void> login() async {
  if (isLoading) return;

  setState(() {
    isLoading = true;
    errorMessage = null;
  });

  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        )
        .timeout(const Duration(seconds: 10));

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (route) => false,
    );

  } on FirebaseAuthException catch (e) {
  String message;

  switch (e.code) {
    case 'user-not-found':
      message = "No user found with this email.";
      break;

    case 'wrong-password': // older Firebase
    case 'invalid-credential': // newer Firebase
    case 'invalid-login-credentials': // also possible
      message = "Incorrect email or password.";
      break;

    case 'invalid-email':
      message = "Invalid email format.";
      break;

    case 'too-many-requests':
      message = "Too many attempts. Try again later.";
      break;

    default:
      message = "Login failed. Please try again.";
  }

  setState(() {
    errorMessage = message;
    isLoading = false;
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
} catch (e) {
    setState(() {
      errorMessage = "Something went wrong";
      isLoading = false;
    });
  }
}

  void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsetsGeometry.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(message),
            ],
          )),
      ),
    );
  }

  /*void loginUser(BuildContext context) {
    
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email == "gks11q@gmail.com" && password == "123456") {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => HomePage()),
        );
    }

    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Incorrect email or password")),
      );
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 33, 31),
        title: Text('Questifie',
        style: TextStyle(
          color: Colors.white,
        )),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 204, 193, 177),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 250,
                  child: Image.asset('assets/images/app_icon.png')
                ),
                Text('LOG IN',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                )),
                Padding(
                  padding: EdgeInsets.all(36),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 40, 33, 31),
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: emailController,
                                enabled: !isLoading,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(36),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    )
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(36),
                                    borderSide: BorderSide(
                                      color: Colors.white
                                    )
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Enter Email...',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14
                                  ),
                                  prefixIcon: Icon(Icons.email,
                                  color: Colors.black,
                                  size: 20,),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(36)
                                  )
                                ),                      
                              ),
          
                              const SizedBox(height: 20),
                      
                              TextFormField(
                                enabled: !isLoading,
                                obscureText: _isObscured,
                                controller: passwordController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  isDense: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(36),
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    )
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(36),
                                    borderSide: BorderSide(
                                      color: Colors.white
                                    )
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Enter Password...',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  prefixIcon: Icon(Icons.password,
                                  color: Colors.black,
                                  size: 20,),
                                  suffixIcon: IconButton(
                                    icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _isObscured = !_isObscured;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(36)
                                  ),
                                ),
          
                              ),
          
                              if (errorMessage != null)
                                Text(errorMessage!, style: TextStyle(color: Colors.red)),
                              SizedBox(height: 5),
          
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                                    },
                                    child: Text('Forgot Password?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12
                                    ))
                                  ),
          
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (context) => SignupPage())
                                      );
                                    },
                                    child: Text('Create an Account',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white
                                    ))
                                  )
                                ],
                              ),
          
                              SizedBox(height: 0.5),
          
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  fixedSize: Size(80, 15),
                                  padding: EdgeInsets.all(0.5),
                                ),
                                onPressed: isLoading ? null : login,
                                child: isLoading
                                  ? const SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                    ),
                                  )
                                : const Text(
                                    'LOG IN',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                              )
          
                            ],
                          )
                        )
                      ],
                    )
                  )
                )
                /*
                Padding(
                  padding: EdgeInsets.all(36),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(36)
                          ),
                        ),
          
                        onChanged: (String email) {
                          
                        },
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return "Enter Email";
                          }
                          return null;
                        }
                      ),
          
                      SizedBox(height: 30),
          
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter Password',
                          prefixIcon: Icon(Icons.password),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(36)
                          ),
                        ),
          
                        onChanged: (String password) {
                          
                        },
                        validator: (password) {
                          if (password == null || password.isEmpty) {
                            return "Enter Password";
                          }
                          return null;
                        }
                      ),
          
                      SizedBox(height: 10),
          
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                                );
                              },
                              child: Text('Forgot Password?',
                              style: TextStyle(
                                color: Colors.black
                              ))
                            ),
          
                            TextButton(
                              onPressed: () {
                                 Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => SignupPage()),
                                );
                              },
                              child: Text('Create an Account',
                              style: TextStyle(
                                color: Colors.black
                              ))
                            )
                          ],
                        )),
          
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: MaterialButton(
                          onPressed: () => loginUser(context),
                          color: Colors.brown,
                          textColor: Colors.white,
                          child: Text('Login'),
                        ),
                      )
          
                    ],
                  )
                ) */
          
              ],
              
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
              child: CircularProgressIndicator(),
        ),
      ),
        ],
      ),
    );
    
  }
}