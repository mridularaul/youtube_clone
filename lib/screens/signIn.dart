import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:youtube/screens/home.dart';
import '../main.dart';
import '../constants.dart';
class signInPage extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();

    Future<void> signIn() async {
      try{
        await supabase.auth.signInWithPassword(
          password: passController.text.trim(),
          email: emailController.text.trim(),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>homePage()));
      }on AuthException catch (e) {
        debugPrint(e.message);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign In failed!',),
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
              Text("Sign In", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextField(
                  controller: emailController,
                  decoration: textField.copyWith(labelText: "Email",prefixIcon: Icon(Icons.mail_outline_outlined) ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: TextField(
                  controller: passController,
                  obscureText: true,
                  decoration: textField.copyWith(labelText: "Password",prefixIcon: Icon(Icons.remove_red_eye_outlined)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: signIn,
                    // onPressed: (){
                    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>homePage()));
                    // },
                    child: Text("Sign In",style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      elevation: 4,
                      shadowColor: Colors.grey,
                      backgroundColor: Colors.red,

                    ),
                  ),
                ),
              ),

            ],
          ),
        )
    );
  }

}