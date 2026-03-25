import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  String ? errorMessage;

  Future<void> resetPassword(String email) async {
    try {
      if (email.trim().isEmpty) {
        errorMessage = "Enter valid email...";
      }
      await auth.sendPasswordResetEmail(email: email.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset email sent!")),
      );
    }
    catch (e) {
      print(e.toString());
    }
  }
  
   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 204, 193, 177),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 33, 31),
        title: Text('Questifie',
        style: TextStyle(
          color: Colors.white,
        )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              child: Image.asset('assets/images/app_icon.png')
            ),
            Text('RESET PASSWORD',
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

                          const SizedBox(height: 0),
                          /*
                          TextFormField(
                            obscureText: true,
                            controller: codeController,
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
                              hintText: 'Enter code...',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(Icons.password,
                              color: Colors.black,
                              size: 20,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(36)
                              )
                            ),
                          ),
                          */
                          SizedBox(height: 20),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              fixedSize: Size(120, 15),
                              padding: EdgeInsets.all(0.5)
                            ),
                            onPressed: () {
                              resetPassword(emailController.text);
                            },
                            child: Text('RESET PASSWORD',
                            style: TextStyle(
                              color: Colors.white,
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