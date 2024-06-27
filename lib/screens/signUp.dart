import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube/screens/home.dart';
import 'package:youtube/screens/signIn.dart';
import '../main.dart';
import '../constants.dart';

class signUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController usernameController = TextEditingController();

    Future<void> signUp() async {
      try {
        final response = await supabase.auth.signUp(
          email: emailController.text.trim(),
          password: passController.text.trim(),
          data: {"username": usernameController.text.trim()},
        );

        final user = response.user;
        if (user != null) {
          // Insert the user profile into the profiles table
          await supabase.from('profiles').insert({
            'id': user.id,
            'username': usernameController.text.trim(),
          });

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => homePage()));
        }
      } on AuthException catch (e) {
        debugPrint(e.message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign Up failed!'),
            backgroundColor: Colors.black87,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }

    return SafeArea(
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextField(
                  controller: emailController,
                  decoration: textField.copyWith(
                      labelText: "Email", prefixIcon: Icon(Icons.mail_outline_outlined)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextField(
                  controller: passController,
                  obscureText: true,
                  decoration: textField.copyWith(
                      labelText: "Password", prefixIcon: Icon(Icons.remove_red_eye_outlined)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextField(
                  controller: usernameController,
                  decoration: textField.copyWith(
                      labelText: "Username", prefixIcon: Icon(Icons.person_2_outlined)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: signUp,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      elevation: 4,
                      shadowColor: Colors.grey,
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
              ),
              RichText(
                  text: TextSpan(children: [
                    TextSpan(text: "Already have an account? ", style: TextStyle(color: Colors.grey)),
                    TextSpan(
                      text: "Sign In",
                      style: TextStyle(color: Colors.red),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context) => signInPage())),
                    ),
                  ]))
            ],
          ),
        ));
  }
}
