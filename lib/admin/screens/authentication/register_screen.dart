import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


import '../screens.dart';
import '../../model/model.dart';
import 'package:logistika/api_connection/api_connection.dart';



class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formKey = GlobalKey<FormState>();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var celularController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;


  //validate admin new email, before save to db server
  validateAdminEmail() async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.validateEmail),
        body: {
          'email': emailController.text.trim(),
        },
      );

      if(res.statusCode == 200) //from flutter app the connection with api to server - success
          {
        var resBodyOfValidateEmail = jsonDecode(res.body);

        if(resBodyOfValidateEmail['emailFound'] == true)
        {
          Fluttertoast.showToast(msg: "El Email ya esta en uso!. Intente con otro.");// Email is already in someone else use. Try another email.");
        }
        else
        {
          //Fluttertoast.showToast(msg: "You are ready to save to DB SERVER!");
          //register & save new admin record to database
          registerAndSaveAdminRecord();
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }

    }
    catch(e)
    {
      //print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  //Save admin new register to server db
  registerAndSaveAdminRecord() async
  {
    Admin adminModel = Admin(
      1,
      nameController.text.trim(),
      emailController.text.trim(),
      celularController.text.trim(),
      passwordController.text.trim(),
    );

    try
    {
      var res = await http.post(
        Uri.parse(API.signUp),
        body: adminModel.toJson(),
      );

      if(res.statusCode == 200) //from flutter app the connection with api to server - success
          {
        var resBodyOfSignUp = jsonDecode(res.body);
        if(resBodyOfSignUp['success'] == true)
        {
          Fluttertoast.showToast(msg: "FELICIDADES!, Te registraste exitosamente en FiveStick.");//Congratulations, you are SignUp Successfully.");

          setState(() {
            nameController.clear(); //same as! nameController.text = "";
            emailController.clear();
            celularController.clear();
            passwordController.clear();
          });

          Future.delayed(const Duration(milliseconds: 2000), ()
          {
            Get.to( LoginScreen());
          });

        }
        else
        {
          Fluttertoast.showToast(msg: "ERROR OCURRIDO!, Vuelve a Intentar.");// Error Occurred, Try Again.");
        }
      }
    }
    catch(e)
    {
      //print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }




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
                            validator: (val) => val == "" ? "PorFavor, escriba su nombre completo" : null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              hintText: "nombre completo...",
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
                            validator: (val) => val == "" ? "PorFavor, escriba su Email" : null,
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
                            validator: (val) => val == "" ? "PorFavor, escriba su numero de Celular" : null,
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
                              validator: (val) => val == "" ? "PorFavor, escriba su password" : null,
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
                                  validateAdminEmail();
                                }
                              },
                              borderRadius: BorderRadius.circular(3),//30
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 28,
                                ),
                                child: Text(
                                  "Registrarme",
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
                            "Ya tienes una cuenta?"
                        ),
                        TextButton(
                          onPressed: ()
                          {
                            //Go2LoginScreen
                            Get.to( LoginScreen());
                          },
                          child: const Text(
                            "Ingresa Aqui",
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