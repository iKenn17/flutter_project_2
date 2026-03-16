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

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser(BuildContext context) {
    
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
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset('assets/images/app_icon.png',
              width: 150,)
            ),
            Text('Log in',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),

            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
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
                      border: OutlineInputBorder(),
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
            )

          ],
          
        ),
      ),
    );
    
  }
}