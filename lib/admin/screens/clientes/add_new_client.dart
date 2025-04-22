import 'dart:convert';
import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:logistika/admin/model/model.dart';
import 'package:logistika/api_connection/api_connection.dart';


class AddNewClient extends StatelessWidget {
  AddNewClient({super.key});

  //controllers for add items model
  var formKey = GlobalKey<FormState>();
  var negocioController = TextEditingController();
  var contactoController = TextEditingController();
  var movilController = TextEditingController();
  var categoriaController = TextEditingController();
  var tipoController = TextEditingController();

//this to declare
//vars for image to db--------------------------
  RxList<int> _imageSelectedByte = <int>[].obs;
  Uint8List get imageSelectedByte => Uint8List.fromList(_imageSelectedByte);

  RxString _imageSelectedName = "".obs;
  String get imageSelectedName => _imageSelectedName.value;

  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;

  setSelectedImage(Uint8List selectedImage)
  {
    _imageSelectedByte.value = selectedImage;
  }
  setSelectedImageName(String selectedImageName)
  {
    _imageSelectedName.value = selectedImageName;
  }
//----------------------------------------------

  //add item Screen methods ----------------------------------------
  captureImageWithPhoneCamera() async
  {
    //pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);
    final pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);

    if(pickedImageXFile != null)
    {
      final bytesOfImage = await pickedImageXFile.readAsBytes();

      setSelectedImage(bytesOfImage);
      setSelectedImageName(path.basename(pickedImageXFile.path));
      Get.back();
    }

    // print("imageSelectedName:: " + imageSelectedName.toString());
    // print("base64Encode(imageSelectedByte):: " + base64Encode(imageSelectedByte).toString());
    // print("imageSelectedByte:: " + imageSelectedByte.toString());

  }

  pickImageFromPhoneGallery() async
  {
    final pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);

    if(pickedImageXFile != null)
    {
      final bytesOfImage = await pickedImageXFile.readAsBytes();

      setSelectedImage(bytesOfImage);
      setSelectedImageName(path.basename(pickedImageXFile.path));
      Get.back();
    }

    // print("imageSelectedName:: " + imageSelectedName.toString());
    // print("base64Encode(imageSelectedByte):: " + base64Encode(imageSelectedByte).toString());
    // print("imageSelectedByte:: " + imageSelectedByte.toString());

  }

  showDialogBoxForImagePickingAndCapturing(context)
  {
    return showDialog(
        context: context,
        builder: (context)
        {
          return SimpleDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Item Image",
              style: TextStyle(
                color: Colors.brown,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: ()
                {
                  captureImageWithPhoneCamera();
                },
                child: const Text(
                  "Capture with Phone Camera",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {
                  pickImageFromPhoneGallery();
                },
                child: const Text(
                  "Pick Image From Phone Gallery",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {
                  Get.back();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          );
        }
    );
  }

//-------------------------------------------------------------------


//------------------------------------------------------------------------------
  saveNewClient() async {
    String newCodigo = ( ((DateTime.now().millisecondsSinceEpoch)).toString().substring(7) );

    // Se elimina cliente_id, no es necesario enviarlo
    Clientes cliente = Clientes(
      codigo: newCodigo,
      negocio: negocioController.text.trim(),
      categoria: categoriaController.text.trim(),
      tipo: tipoController.text.trim(),
      contacto: contactoController.text.trim(),
      razonSocial: '',
      nit: '',
      latitude: '',
      longitude: '',
      fijo: '',
      movil: movilController.text.trim(),
      email: '',
      totalCompra: 0,
      image: DateTime.now().millisecondsSinceEpoch.toString() + "-" + imageSelectedName,  // Solo pasamos el nombre de la imagen
    );

    try {
      var response = await http.post(
        Uri.parse(API.saveNewClient),
        body: cliente.toJson(""),  // No enviamos base64 de la imagen
      );

      if (response.statusCode == 200) {
        var resBodyOfUploadItem = jsonDecode(response.body);

        if (resBodyOfUploadItem['success'] == true) {
          Fluttertoast.showToast(msg: "Cliente nuevo ingresado con éxito");
          Get.back();  // Volver al anterior
        } else {
          Fluttertoast.showToast(msg: "Cliente no ingresado!. Vuelve a intentarlo.");
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }
  }
//------------------------------------------------------------------------------


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        //automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          "Nuevo Cliente",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              //display selected image by user
              Obx(()=> ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                  maxHeight: MediaQuery.of(context).size.width * 0.6,
                ),
                child: imageSelectedByte.length > 0
                    ? Image.memory(imageSelectedByte, fit: BoxFit.contain,)
                    : const Placeholder(color: Colors.indigo,),
              )),
              const SizedBox(height: 10),
              //select image btn
              Material(
                elevation: 1,
                color: Colors.indigo.withOpacity(0.8),
                borderRadius: BorderRadius.circular(3),
                child: InkWell(
                  onTap: ()
                  {
                    showDialogBoxForImagePickingAndCapturing(context);
                  },
                  borderRadius: BorderRadius.circular(3),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    child: Text(
                      "Front Image",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //fill item form
              Form(
                key: formKey,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        //Cliente
                        TextFormField(
                          controller: negocioController,
                          validator: (val) => val == "" ? "Cliente" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.add_business_outlined,
                              color: Colors.indigo,
                            ),
                            hintText: "Nombre Cliente...",
                            labelText: "Cliente",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: const BorderSide(
                                color: Colors.white60,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: const BorderSide(
                                color: Colors.indigo,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: const BorderSide(
                                color: Colors.indigoAccent,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
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
                        const SizedBox(height: 15),
                        //codigo - unidad - categoria
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //contacto
                            Container(
                              width: 220,
                              height: 45,
                              child: TextFormField(
                                controller: contactoController,
                                validator: (val) => val == "" ? "Please write contacto" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.indigo,
                                  ),
                                  hintText: "Contacto",
                                  labelText: "Contacto",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
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
                            const Spacer(),
                            //celular
                            Container(
                              width: 150,
                              height: 45,
                              child: TextFormField(
                                controller: movilController,
                                validator: (val) => val == "" ? "Please write celular" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.phone,
                                    color: Colors.indigo,
                                  ),
                                  hintText: "Celular",
                                  labelText: "Celular",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
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
                          ],
                        ),
                        const SizedBox(height: 15),
                        //categoria - tipo
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //categoria
                            Container(
                              width: 250,
                              height: 45,
                              child: TextFormField(
                                controller: categoriaController,
                                validator: (val) => val == "" ? "Please write categoria" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.account_tree,
                                    color: Colors.indigo,
                                  ),
                                  hintText: "Categoria",
                                  labelText: "Categoria",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
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
                            const Spacer(),
                            //tipo
                            Container(
                              width: 120,
                              height: 45,
                              child: TextFormField(
                                controller: tipoController,
                                validator: (val) => val == "" ? "Please write tipo" : null,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.type_specimen,
                                    color: Colors.indigo,
                                  ),
                                  hintText: "Tipo",
                                  labelText: "Tipo",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigo,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
                                    borderSide: const BorderSide(
                                      color: Colors.indigoAccent,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(3),
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
                          ],
                        ),
                        const SizedBox(height: 30),
                        //confirm and proceed btn
                        Obx(()=> Material(
                          elevation: 1,
                          color: imageSelectedByte.length > 0 ? Colors.indigo : Colors.indigo.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(3),
                          child: InkWell(
                            onTap: ()
                            {
                              if(imageSelectedByte.length > 0)
                              {
                                //save new client info
                                saveNewClient();
                              }
                              else
                              {
                                Fluttertoast.showToast(msg: "Please attach new Client / screenshot.");
                              }
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                              child: Text(
                                "Confirmed & Proceed",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        )),

                      ],
                    ),
                  ),
                ),
              )
              //save button
            ],
          ),
        ),
      ),

    );
  }
}
