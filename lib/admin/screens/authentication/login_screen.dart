import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens.dart';




class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, cons)
        {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: cons.maxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  const SizedBox(height: 60,),
                  //login screen header
                  const SizedBox( height: 70 ),
                  Text('Login', style: TextStyle(fontSize: 48),),
                  const SizedBox( height: 40 ),


                  // //login screen header
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(20,50,20,50),
                  //   child: SizedBox(
                  //     width: MediaQuery.of(context).size.width,
                  //     height: 150,
                  //     child: Image.asset(
                  //       "assets/images/logo.jpg",
                  //     ),
                  //   ),
                  // ),

                  //login screen sign-in form
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.all(
                          Radius.circular(3),//60
                        ),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4,
                            color: Colors.black26,
                            offset: Offset(0, -3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 15),
                        child: Column(
                          children: [

                            //email-password-login button
                            Form(
                              key: formKey,
                              child: Column(
                                children: [

                                  //email
                                  TextFormField(
                                    controller: emailController,
                                    validator: (val) => val == "" ? "Please write email" : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                      hintText: "email...",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),//30
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),//30
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),//30
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),//30
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 7,//14
                                        vertical: 3,//6
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                  ),

                                  const SizedBox(height: 18,),

                                  //password
                                  Obx(
                                        ()=> TextFormField(
                                      controller: passwordController,
                                      obscureText: isObsecure.value,
                                      validator: (val) => val == "" ? "Please write password" : null,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.vpn_key_sharp,
                                          color: Colors.black,
                                        ),
                                        suffixIcon: Obx(
                                              ()=> GestureDetector(
                                            onTap: ()
                                            {
                                              isObsecure.value = !isObsecure.value;
                                            },
                                            child: Icon(
                                              isObsecure.value ? Icons.visibility_off : Icons.visibility,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        hintText: "password...",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),//30
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),//30
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),//30
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),//30
                                          borderSide: const BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 7,//14
                                          vertical: 3,//6
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 36,),

                                  //button
                                  Material(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),//30
                                    child: InkWell(
                                      onTap: ()
                                      {
                                        if(formKey.currentState!.validate())
                                        {
                                          //loginAdminNow();
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(10),//30
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 28,
                                        ),
                                        child: Text(
                                          "Login",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16,),

                            //don't have an account button - button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                    "Don't have an Account?"
                                ),
                                TextButton(
                                  onPressed: ()
                                  {
                                    Get.to( RegisterScreen());
                                  },
                                  child: const Text(
                                    "SignUp Here",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
