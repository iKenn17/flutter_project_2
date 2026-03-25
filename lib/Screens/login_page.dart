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
  bool _isObscured = true;
  String? errorMessage;
  

  Future<void> login() async {
    try {
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage())
      );
      
    }

    catch (error) {
      if (!mounted) return;

      setState() {
        errorMessage = error.toString();
      }
    }
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
      body: SingleChildScrollView(
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
                              padding: EdgeInsets.all(0.5)
                            ),
                            onPressed: login,
                            child: Text('LOG IN',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ))
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
    );
    
  }
}