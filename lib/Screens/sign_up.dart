import 'package:flutter/material.dart';
import 'login_page.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
            Text('Sign up',
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
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),

                    onChanged: (String value) {
                      
                    },
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter email' : null;
                    }
                  ),

                  SizedBox(height: 30),

                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      hintText: 'Enter New Password',
                      prefixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(),
                    ),

                    onChanged: (String value) {
                      
                    },
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter new password' : null;
                    }
                  ),
                  
                  SizedBox(height: 30),

                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm New Password',
                      prefixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(),
                    ),

                    onChanged: (String value) {
                      
                    },
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter confirm password' : null;
                    }
                  ),

                  SizedBox(height: 10),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context, MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          },
                          child: Text('Already have an account?',
                          style: TextStyle(
                            color: Colors.black
                          ))
                        )
                      ],
                    )),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: MaterialButton(
                      onPressed: () {},
                      child: Text('Signup'),
                      color: Colors.brown,
                      textColor: Colors.white,
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