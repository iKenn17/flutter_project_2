import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmedpasswordController = TextEditingController();
  bool _isObscured1 = true;
  bool _isObscured2 = true;
  String? errorMessage;

  

  Future<void> signup() async {
    try {
      if (passwordController.text.trim() != confirmedpasswordController.text.trim()) {
        errorMessage = "Passwords do not match";
        return;
      }
      await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim(),
      );
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()));
        }
    }

    catch (error) {
      errorMessage = error.toString();
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
            SizedBox(
              height: 250,
              child: Image.asset('assets/images/app_icon.png')
            ),
            Text('SIGN UP',
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
                            obscureText: _isObscured1,
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
                                icon: Icon(_isObscured1 ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscured1 = !_isObscured1;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(36)
                              )
                            ),

                          ),

                          SizedBox(height: 20),

                          TextFormField(
                            obscureText: _isObscured2,
                            controller: confirmedpasswordController,
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
                              hintText: 'Confirm Password...',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(Icons.password,
                              color: Colors.black,
                              size: 20,),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(36)
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(_isObscured2 ? Icons.visibility : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscured2 = !_isObscured2;
                                  });
                                },
                              ),
                            ),

                          ),

                          

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context, MaterialPageRoute(builder: (context) => LoginPage())
                                  );
                                },
                                child: Text('Already have an account?',
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
                            onPressed: signup,
                            child: Text('SIGN UP',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12
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