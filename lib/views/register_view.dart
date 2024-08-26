import 'package:chat_app/constants.dart';
import 'package:chat_app/helper/show_snack_bar.dart';
import 'package:chat_app/views/chat_view.dart';
import 'package:chat_app/views/components/custom_button.dart';
import 'package:chat_app/views/components/custom_text_field.dart';
import 'package:chat_app/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterView extends StatefulWidget {
  RegisterView({super.key});
  static String route = 'RegisterPage';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String? email;

  String? password;

  bool? isLoading;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading ?? false,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: ListView(
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
                  "Sign up",
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
                        await registerUser();
                        Navigator.pushNamed(context, ChatView.route);
                        showSnackBar(context, 'Registered Successfully');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          showSnackBar(context, 'Weak password');
                        } else if (e.code == 'email-already-in-use') {
                          showSnackBar(context,
                              "The account already exists for that email.");
                        }
                      } catch (e) {
                        showSnackBar(context, "Form Validation");
                      }
                      isLoading = false;
                      setState(() {});
                      // showSnackBar(context, "account created successfully");
                    } else {}
                  },
                  buttonText: "REGISTER",
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an Account?",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, LoginView.route);
                      },
                      child: Text(
                        " Login",
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

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
