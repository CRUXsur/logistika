import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../screens.dart';



class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var celularController = TextEditingController();
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

          //signup screen header
          const SizedBox( height: 70 ),
          Text('Registro', style: TextStyle(fontSize: 48),),
          const SizedBox( height: 40 ),

          //signup screen sign-up form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),//60
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

                    //name-email-password || signUp button
                    Form(
                      key: formKey,
                      child: Column(
                        children: [

                          //name
                          TextFormField(
                            controller: nameController,
                            validator: (val) => val == "" ? "Please write name" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              hintText: "name...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),//30
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),//30
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),//30
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),//30
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

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
                                borderRadius: BorderRadius.circular(3),//30
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),//30
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),//30
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),//30
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),

                          const SizedBox(height: 18,),

                          //celular
                          TextFormField(
                            controller: celularController,
                            validator: (val) => val == "" ? "Please write celularNumber" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.add_call,
                                color: Colors.black,
                              ),
                              hintText: "celular...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),//30
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),//30
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),//30
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3),//30
                                borderSide: const BorderSide(
                                  color: Colors.white60,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
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
                                  borderRadius: BorderRadius.circular(3),//30
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),//30
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),//30
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(3),//30
                                  borderSide: const BorderSide(
                                    color: Colors.white60,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
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
                            borderRadius: BorderRadius.circular(3),//30
                            child: InkWell(
                              onTap: ()
                              {
                                if(formKey.currentState!.validate())
                                {
                                  //validate the email
                                  //validateUserEmail();
                                }
                              },
                              borderRadius: BorderRadius.circular(3),//30
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 28,
                                ),
                                child: Text(
                                  "SignUp",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,//16
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16,),

                    //already have account button - button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                            "Already have an Account?"
                        ),
                        TextButton(
                          onPressed: ()
                          {
                            //Go2LoginScreen
                            Get.to( LoginScreen());
                          },
                          child: const Text(
                            "Login Here",
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