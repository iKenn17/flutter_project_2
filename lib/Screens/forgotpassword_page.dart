import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  bool _isCodeSent = false;

  void _handleButtonPressed() {
    if (!_isCodeSent) {
      print("Requesting code...");

      setState(() {
        _isCodeSent = true;
      });
    }

    else {
      print("Submitting code...");
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
            Align(
              alignment: Alignment.topCenter,
              child: Image.asset('assets/images/app_icon.png',
              width: 150,)
            ),

            Text('Reset Password',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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

                  SizedBox(height: 20),

                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Code',
                      hintText: 'Enter Code',
                      prefixIcon: Icon(Icons.password),
                      border: OutlineInputBorder(),
                    ),

                    onChanged: (String value) {
                      
                    },
                    validator: (value) {
                      return value!.isEmpty ? 'Please enter password' : null;
                    }
                  ),

                  SizedBox(height: 20),

                  MaterialButton(
                    onPressed: _handleButtonPressed,
                    color: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text(_isCodeSent ? "Submit" : "Get Code",
                    style: TextStyle(
                      color: Colors.white
                    )),
                  )

                ],
              )
            ),
          ]  
        ),   
      ),
    );
  }
}