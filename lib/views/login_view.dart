import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/views/chat_view.dart';
import 'package:chat_app/views/components/custom_text_field.dart';
import 'package:chat_app/views/components/custom_button.dart';
import 'package:chat_app/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});
  static String route = 'LoginView';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String? email, password;

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 80,
                ),
                Center(child: Image.asset("assets/images/scholar.png")),
                const SizedBox(
                  height: 10,
                ),
                const Center(
                  child: Text(
                    "Scholar Chat",
                    style: TextStyle(
                        fontSize: 45,
                        color: Colors.white,
                        fontFamily: 'Pacifico'),
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                const Text(
                  "Log in",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Roboto'),
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextFormField(
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                  onChanged: (data) {
                    email = data;
                  },
                  hintText: "Enter your Email",
                ),
                const SizedBox(
                  height: 15,
                ),
                CustomTextFormField(
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                  obsecureText: true,
                  onChanged: (data) {
                    password = data;
                  },
                  hintText: "Enter your Password",
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomButton(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        var auth = FirebaseAuth.instance;
                        await loginUser();
                        Navigator.pushNamed(context, ChatView.route,
                            arguments: email);
                        showSnackBar(context, 'Logged in Successfully');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showSnackBar(
                              context, 'No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          showSnackBar(context,
                              "Wrong password provided for that user.");
                        }
                      } catch (e) {
                        print(e);
                        showSnackBar(context, "Form Validation");
                      }
                      isLoading = false;
                      setState(() {});
                      // showSnackBar(context, "account created successfully");
                    } else {}
                  },
                  buttonText: "LOGIN",
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Dont have an Account?",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterView.route);
                      },
                      child: const Text(
                        " Register",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color(0xFFC7EDE6)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
